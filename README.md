# 酒精浓度监测系统

## 项目简介

这是一个基于Flutter开发的酒精浓度监测系统移动应用。该系统旨在帮助用户管理酒精检测设备、查看和分析酒精浓度数据,以及接收实时警报。

## 功能特性

1. 用户认证
   - 登录
   - 注册
   - 修改密码

2. 设备管理
   - 查看设备列表
   - 添加新设备
   - 查看设备详情

3. 数据分析
   - 查看历史数据
   - 数据图表展示
   - 数据筛选和分页

4. 实时警报
   - 接收WebSocket实时警报

5. 系统设置
   - 修改密码
   - 设置测量单位

## 项目结构

```
lib/
├── main.dart
├── models/
│   └── device.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── device_list_screen.dart
│   ├── device_detail_screen.dart
│   ├── add_device_screen.dart
│   ├── data_analysis_screen.dart
│   ├── alert_info_screen.dart
│   └── settings_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── device_service.dart
│   └── websocket_service.dart
└── widgets/
    ├── alert_widget.dart
    ├── chart_widget.dart
    └── device_list_item.dart
```

## 核心组件说明

### 1. 登录和注册 (Login and Register)

- 登录界面: `login_screen.dart`
- 注册界面: `register_screen.dart`

这两个界面负责用户的身份验证。它们使用`auth_service.dart`来处理与后端的认证请求。

### 2. 主页面 (Home Screen)

- 主界面: `home_screen.dart`

主界面是用户登录后看到的第一个界面,它包含了进入其他功能模块的入口。

### 3. 设备管理 (Device Management)

- 设备列表: `device_list_screen.dart`
- 设备详情: `device_detail_screen.dart`
- 添加设备: `add_device_screen.dart`

这些界面负责设备的CRUD操作。它们使用`device_service.dart`来与后端进行通信。

### 4. 数据分析 (Data Analysis)

- 数据分析界面: `data_analysis_screen.dart`

该界面负责展示历史数据和图表。它使用`chart_widget.dart`来渲染图表。

### 5. 警报系统 (Alert System)

- 警报信息界面: `alert_info_screen.dart`
- 警报组件: `alert_widget.dart`

这些组件负责显示和管理警报信息。实时警报通过`websocket_service.dart`接收。

### 6. 设置 (Settings)

- 设置界面: `settings_screen.dart`

该界面允许用户修改密码和设置测量单位。

## 关键服务

1. `auth_service.dart`: 处理用户认证相关的API请求。
2. `device_service.dart`: 处理与设备相关的API请求。
3. `websocket_service.dart`: 管理WebSocket连接,用于接收实时警报。

## 如何运行项目

1. 确保你已经安装了Flutter SDK和Dart。
2. 克隆此仓库到本地。
3. 在项目根目录运行 `flutter pub get` 安装依赖。
4. 连接模拟器或真机设备。
5. 运行 `flutter run` 启动应用。

## 学习建议

1. 从`main.dart`开始,了解应用的入口点和整体结构。
2. 仔细阅读`screens`文件夹中的各个界面文件,理解用户界面的构建方式。
3. 研究`services`文件夹中的服务类,了解如何与后端API进行交互。
4. 查看`widgets`文件夹中的自定义组件,学习如何创建可重用的UI组件。
5. 尝试修改一些UI元素或添加新功能,以加深对项目的理解。