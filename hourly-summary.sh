#!/bin/bash
# 带重试机制的每小时工作汇总脚本
# 解决网络不稳定导致的推送失败问题

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$SCRIPT_DIR/../memory"
SUMMARY_DIR="$SCRIPT_DIR/summaries"

# 获取当前日期
TODAY=$(date +%Y-%m-%d)
NOW=$(date '+%Y-%m-%d %H:%M:%S')

# 创建汇总文件
SUMMARY_FILE="$SUMMARY_DIR/$TODAY-hourly-$(date +%H).md"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }

# 带重试的函数
retry() {
    local max_attempts=3
    local attempt=1
    local delay=5

    while [ $attempt -le $max_attempts ]; do
        if "$@" 2>&1; then
            return 0
        else
            warning "尝试 $attempt/$max_attempts 失败: $*"
            if [ $attempt -lt $max_attempts ]; then
                info "等待 ${delay} 秒后重试..."
                sleep $delay
                delay=$((delay * 2))
            fi
            attempt=$((attempt + 1))
        fi
    done
    error "所有尝试失败"
    return 1
}

info "开始每小时工作汇总..."
info "日期: $TODAY"
info "时间: $NOW"
echo ""

# 读取工作日志
MEMORY_FILE="$WORKSPACE_DIR/$TODAY.md"
if [ -f "$MEMORY_FILE" ]; then
    info "读取今日工作日志"

    echo "# 每小时工作汇总 - $TODAY $(date +%H:00)" > "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo "**生成时间：** $NOW" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"

    # 提取工作时间线
    echo "## 工作概览" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo '```bash' >> "$SUMMARY_FILE"
    grep -E "^\#\#\# \d{2}:" "$MEMORY_FILE" 2>/dev/null | sed 's/^### /• /' || echo "今日暂无工作记录" >> "$SUMMARY_FILE"
    echo '```' >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"

    # 添加完整日志
    echo "## 完整日志" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo '<details>' >> "$SUMMARY_FILE"
    echo '<summary>点击查看详细日志</summary>' >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    cat "$MEMORY_FILE" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo '</details>' >> "$SUMMARY_FILE"

    success "汇总已生成: $SUMMARY_FILE"
else
    warning "今日工作日志不存在"
fi

# 提交到 Git
info "提交到 Git..."
cd "$SCRIPT_DIR"
git add -A
if git commit -m "每小时汇总: $TODAY $(date +%H:00)" 2>/dev/null; then
    success "Git 提交完成"

    # 推送到 GitHub（带重试）
    info "推送到 GitHub..."
    if retry git push origin master 2>/dev/null || retry git push origin main 2>/dev/null; then
        success "推送成功"
    else
        warning "推送失败，但本地已保存。将在下次尝试推送"
    fi
else
    info "无变更需要提交"
fi

echo ""
success "每小时工作汇总完成！"
echo ""