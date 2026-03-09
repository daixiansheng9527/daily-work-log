#!/bin/bash
# 使用手动方式创建远程仓库
# 在 PAT 更新后使用

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_NAME="daily-work-log"

echo "=== 设置 GitHub 远程仓库 ==="
echo ""

# 检查认证
echo "1. 检查 GitHub 认证..."
if ! gh auth status > /dev/null 2>&1; then
    echo "❌ 未登录到 GitHub"
    exit 1
fi
echo "✅ 已认证"
echo ""

# 创建远程仓库
echo "2. 创建远程仓库..."
gh repo create "$REPO_NAME" \
    --public \
    --description "Claw 的日常工作日志 - 每小时自动汇总" \
    --source="$SCRIPT_DIR" \
    --remote=origin \
    --push

echo ""
echo "✅ 远程仓库创建成功！"
echo "🔗 https://github.com/daixiansheng9527/$REPO_NAME"