#!/bin/bash
# 每小时工作汇总脚本
# 用途：从 memory/ 读取当天工作日志，生成汇总

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$SCRIPT_DIR/../memory"
SUMMARY_DIR="$SCRIPT_DIR/summaries"
DAILY_DIR="$SCRIPT_DIR/daily"

# 获取当前日期
TODAY=$(date +%Y-%m-%d)
NOW=$(date '+%Y-%m-%d %H:%M:%S')

# 创建日期文件
DAILY_FILE="$DAILY_DIR/$TODAY.md"

# 创建汇总文件
SUMMARY_FILE="$SUMMARY_DIR/$TODAY-hourly-$(date +%H).md"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }

info "开始每小时工作汇总..."
info "日期: $TODAY"
info "时间: $NOW"
echo ""

# 检查工作空间日志是否存在
MEMORY_FILE="$WORKSPACE_DIR/$TODAY.md"
if [ -f "$MEMORY_FILE" ]; then
    info "读取今日工作日志: $MEMORY_FILE"

    # 提取工作时间线
    echo "# 每小时工作汇总 - $TODAY $(date +%H:00)" > "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo "**生成时间：** $NOW" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
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
    info "今日工作日志不存在，创建空文件..."
    echo "# $TODAY - 工作日志" > "$MEMORY_FILE"
    echo "" >> "$MEMORY_FILE"
    echo "*创建时间: $NOW*" >> "$MEMORY_FILE"
    echo "" >> "$MEMORY_FILE"
    success "工作日志已创建: $MEMORY_FILE"
fi

# 提交到 Git
info "提交到 Git..."
cd "$SCRIPT_DIR"
git add -A
git commit -m "每小时汇总: $TODAY $(date +%H:00)" || info "无变更需要提交"
success "Git 提交完成"

# 推送到 GitHub
info "推送到 GitHub..."
if git push origin main 2>/dev/null; then
    success "推送成功"
elif git push origin master 2>/dev/null; then
    success "推送成功"
else
    info "推送失败，可能需要先设置远程仓库"
fi

echo ""
success "每小时工作汇总完成！"