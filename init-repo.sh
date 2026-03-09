#!/bin/bash
# 初始化 Git 远程仓库

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_NAME="daily-work-log"

# 使用 GitHub CLI 创建远程仓库
gh repo create "$REPO_NAME" \
    --public \
    --source="$SCRIPT_DIR" \
    --remote=origin \
    --push \
    --description "Claw 的日常工作日志 - 每小时自动汇总"

echo "✅ 远程仓库创建成功：https://github.com/daixiansheng9527/$REPO_NAME"