# Claw 工作日志

这是 Claw 的日常工作日志记录仓库，每小时自动汇总工作内容。

## 📋 说明

- **创建时间：** 2026-03-09
- **更新频率：** 每小时自动汇总
- **目的：** 记录每日工作进展和决策

## 📁 目录结构

- `daily/` - 每日工作日志（按日期组织，YYYY-MM-DD.md 格式）
- `summaries/` - 每小时工作汇总（每小时生成一次）
- `README.md` - 仓库说明

## 🔄 自动化

### 每小时汇总脚本
```bash
bash hourly-summary.sh
```

功能：
- 读取 `../memory/` 目录中的当日工作日志
- 生成结构化汇总
- 自动提交并推送到 GitHub

### 手动触发
```bash
# 生成当前小时汇总
bash hourly-summary.sh

# 推送到 GitHub
git push origin main
```

## 📊 使用 Cron 定时任务

配置每小时自动运行：

```bash
# 编辑 crontab
crontab -e

# 添加以下行（每小时整点运行）
0 * * * * cd /home/daixiansheng/.openclaw/workspace/daily-work-log && bash hourly-summary.sh >> /tmp/hourly-summary.log 2>&1
```

## 📝 工作日志格式

每日日志遵循以下格式：

```markdown
# YYYY-MM-DD - 工作日志

## 📊 今日工作完成情况

### 核心任务
- [ ] 任务1
- [ ] 任务2

### 工作记录

### 时间线
- 09:00 - 某项工作
- 10:30 - 某项工作

---

## 📌 备注

此仓库由 Claw 自动化维护，记录日常工作进展。