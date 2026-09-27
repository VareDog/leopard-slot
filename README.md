# 金钱豹水果机 🐆

单机离线的「水果机 / 跑马灯老虎机」小游戏，仿老式街机机台。
**无广告 · 无联网 · 无内购 · 分数自动存档**，纯个人娱乐用。

一个纯 HTML5 单文件游戏（`app/assets/index.html`），外面套了一个极简 Android WebView 壳打包成 APK，也可以直接用浏览器打开玩。

## 玩法

| 步骤 | 操作 |
|---|---|
| ① 上分 | 点「上分+1000」获得分数 |
| ② 押注 | 选筹码（1/5/10/50/100），点图案按钮押分，可同时押多个图案 |
| ③ 开始 | 红灯绕 24 格跑圈、减速、停下，落在哪个图案就开哪个 |
| ④ 结算 | 押中 = 押注 × 赔率；没押中则押注全输 |

**赔率表**：🍎苹果 ×2 · 🍊橙子 ×2 · 🔔铃铛 ×3 · 🍉西瓜 ×5 · ⭐星星 ×8 · 77 ×13 · BAR ×20 · 🐆雪豹 ×50

- **猜大小翻倍**：中奖后可「收分」落袋，或猜大/猜小（3 颗骰子，3~10 为小、11~18 为大，恰 50:50）。猜对奖分翻倍、可连续猜；猜错奖分清零。
- **JP 奖池**：每次押注的 10% 进入奖池，押中 🐆雪豹（×50）额外把整个奖池抱走。
- **清注**：未开局前退回押注；**退分**：分数清零并累计流水。

## 安装 APK

1. 下载仓库根目录的 `LeopardSlot.apk` 传到手机
2. 点开安装，允许「未知来源」即可（Android 5.0+）
3. 或者直接用手机/电脑浏览器打开 `app/assets/index.html` 试玩

## 项目结构

```
leopard-slot/
├── app/
│   ├── assets/index.html      # 游戏主体（HTML5 单文件，Canvas + WebAudio）
│   ├── src/.../MainActivity.java  # Android WebView 壳（全屏、竖屏、常亮）
│   └── AndroidManifest.xml
├── scripts/make_icon.ps1      # 生成应用图标
├── build.bat                  # 一键构建脚本（编译→dex→打包→对齐→签名）
└── LeopardSlot.apk            # 已构建好的成品
```

## 自己构建

构建脚本已固定本机路径，换机器需要：

1. JDK 11+（`build.bat` 里改 `JDK` 变量）
2. [build-tools 35](https://dl.google.com/android/repository/build-tools_r35_windows.zip) 解压到 `tools/android-15/`
3. [platform-34](https://dl.google.com/android/repository/platform-34-ext7_r03.zip) 解压到 `tools/android-34/`（取 `android.jar`）
4. 运行 `build.bat`，产物为根目录 `LeopardSlot.apk`

> 换机器重建后 keystore 会变化，无法覆盖安装旧版（会提示签名不一致，卸载重装即可，存档会丢）。想保留签名，请本地备份 `build/dosdog.keystore`。

## 免责声明

本项目仅供个人娱乐，所有分数均为虚拟模拟，**不涉及任何真实货币**，请勿用于赌博用途。
