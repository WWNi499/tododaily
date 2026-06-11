# 每日待办

一个每天早上自动提醒添加任务、晚上检阅完成情况的 Todo 应用。

## 功能

- 早上 8 点后打开 App → 自动弹出添加今日待办弹窗
- 点击"稍后提醒" → 30 分钟后再次弹出，最多忽略 2 次
- 点击"今日无待办" → 当天不再弹窗
- 晚上 8 / 10 / 11 点 → 弹出检阅弹窗，查看任务完成情况
- 全部完成 → 显示"今日完美达成 🎉"，不再提醒

## 下载安装

APK 在 GitHub Actions 构建产物中：

1. 点击上方的 **Actions** 标签
2. 点击最新的构建任务
3. 在 Artifacts 中下载 **app-debug**

## 自行编译

```bash
flutter pub get
flutter build apk --debug
```

APK 输出在 `build/app/outputs/flutter-apk/app-debug.apk`
