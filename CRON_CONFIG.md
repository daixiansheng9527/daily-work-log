# Claw 自动化工作日志 Cron 配置

## 配置内容
每小时自动汇总工作日志并推送到 GitHub

## Cron 任务
```bash
0 * * * * cd /home/daixiansheng/.openclaw/workspace/daily-work-log && bash hourly-summary.sh >> /tmp/hourly-summary.log 2>&1
```

## 说明
- **执行时间：** 每小时整点（00分）
- **执行路径：** ~/.openclaw/workspace/daily-work-log
- **脚本：** hourly-summary.sh
- **日志文件：** /tmp/hourly-summary.log

## 手动测试
```bash
cd /home/daixiansheng/.openclaw/workspace/daily-work-log
bash hourly-summary.sh
```

## 查看日志
```bash
tail -f /tmp/hourly-summary.log
```

---

添加时间：2026-03-09 18:36