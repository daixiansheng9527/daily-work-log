#!/bin/bash
# 添加每小时工作汇总 Cron 任务

SCRIPT_DIR="/home/daixiansheng/.openclaw/workspace/daily-work-log"
LOG_FILE="/tmp/hourly-summary.log"

# 检查是否已存在
EXISTING=$(crontab -l 2>/dev/null | grep "hourly-summary.sh" | grep -v "^#" || echo "")

if [ -n "$EXISTING" ]; then
    echo "⚠️  Cron 任务已存在："
    echo "$EXISTING"
    echo ""
    read -p "是否要替换？(y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "取消操作"
        exit 0
    fi
    # 删除现有任务
    crontab -l 2>/dev/null | grep -v "hourly-summary.sh" | crontab -
fi

# 添加新的 Cron 任务
(crontab -l 2>/dev/null | grep -v "hourly-summary.sh"; echo "0 * * * * cd $SCRIPT_DIR && bash hourly-summary.sh >> $LOG_FILE 2>&1") | crontab -

echo "✅ Cron 任务已添加："
echo "   每小时整点运行：$SCRIPT_DIR/hourly-summary.sh"
echo "   日志文件：$LOG_FILE"
echo ""
echo "当前 Cron 任务列表："
crontab -l