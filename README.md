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

## API 文档

### 基础URL

所有API的基础URL为: `http://47.116.66.208:8080/api`

### 认证相关API

#### 1. 用户登录

- **URL**: `/users/login`
- **方法**: POST
- **描述**: 用户登录并获取认证信息
- **请求体**:
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- **成功响应**: 
  - 状态码: 200
  - 响应体: 用户信息(具体格式需要根据后端实现确定)
- **错误响应**:
  - 状态码: 401
  - 响应体: 
    ```json
    {
      "message": "Invalid username or password"
    }
    ```

**测试用例**:
1. 使用正确的用户名和密码登录
2. 使用错误的用户名登录
3. 使用错误的密码登录
4. 使用空用户名或密码登录

#### 2. 用户注册

- **URL**: `/users/register`
- **方法**: POST
- **描述**: 注册新用户
- **请求体**:
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- **成功响应**: 
  - 状态码: 200
  - 响应体: 
    ```json
    {
      "message": "User registered successfully"
    }
    ```
- **错误响应**:
  - 状态码: 400
  - 响应体: 
    ```json
    {
      "message": "Username already exists"
    }
    ```

**测试用例**:
1. 注册新用户
2. 尝试使用已存在的用户名注册
3. 使用无效的用户名或密码格式注册

#### 3. 修改密码

- **URL**: `/users/{userId}/password`
- **方法**: PUT
- **描述**: 修改用户密码
- **请求参数**:
  - `userId`: 用户ID (路径参数)
  - `oldPassword`: 旧密码 (查询参数)
  - `newPassword`: 新密码 (查询参数)
- **成功响应**: 
  - 状态码: 200
  - 响应体: 
    ```json
    {
      "message": "Password changed successfully"
    }
    ```
- **错误响应**:
  - 状态码: 400
  - 响应体: 
    ```json
    {
      "message": "Invalid old password"
    }
    ```

**测试用例**:
1. 使用正确的旧密码修改密码
2. 使用错误的旧密码尝试修改密码
3. 尝试将新密码设置为与旧密码相同

### 设备相关API

#### 1. 获取设备列表

- **URL**: `/devices`
- **方法**: GET
- **描述**: 获取设备列表，支持分页
- **请求参数**:
  - `page`: 页码 (查询参数，默认为0)
  - `size`: 每页数量 (查询参数，默认为10)
- **成功响应**: 
  - 状态码: 200
  - 响应体: 
    ```json
    {
      "content": [
        {
          "id": 1,
          "name": "Device 1",
          "macAddress": "00:11:22:33:44:55",
          "communicationChannel": "channel1",
          "threshold": 0.5,
          "isOn": true
        }
      ],
      "totalPages": 5,
      "totalElements": 50
    }
    ```

**测试用例**:
1. 获取第一页设备列表
2. 获取指定页码的设备列表
3. 使用不同的每页数量获取设备列表
4. 获取超出总页数的页码

#### 2. 获取设备详情

- **URL**: `/devices/{deviceId}`
- **方法**: GET
- **描述**: 获取指定设备的详细信息
- **请求参数**:
  - `deviceId`: 设备ID (路径参数)
- **成功响应**: 
  - 状态码: 200
  - 响应体: 
    ```json
    {
      "id": 1,
      "name": "Device 1",
      "macAddress": "00:11:22:33:44:55",
      "communicationChannel": "channel1",
      "threshold": 0.5,
      "isOn": true
    }
    ```
- **错误响应**:
  - 状态码: 404
  - 响应体: 
    ```json
    {
      "message": "Device not found"
    }
    ```

**测试用例**:
1. 获取存在的设备详情
2. 尝试获取不存在的设备详情

#### 3. 添加新设备

- **URL**: `/devices`
- **方法**: POST
- **描述**: 添加新设备
- **请求体**:
  ```json
  {
    "name": "string",
    "macAddress": "string",
    "communicationChannel": "string",
    "threshold": 0.5
  }
  ```
- **成功响应**: 
  - 状态码: 201
  - 响应体: 新创建的设备信息
- **错误响应**:
  - 状态码: 400
  - 响应体: 
    ```json
    {
      "message": "Invalid device information"
    }
    ```

**测试用例**:
1. 添加新设备
2. 尝试添加重复的MAC地址设备
3. 使用无效的设备信息添加设备

#### 4. 更新设备信息

- **URL**: `/devices/{deviceId}`
- **方法**: PUT
- **描述**: 更新指定设备的信息
- **请求参数**:
  - `deviceId`: 设备ID (路径参数)
- **请求体**:
  ```json
  {
    "name": "string",
    "threshold": 0.5,
    "isOn": true
  }
  ```
- **成功响应**: 
  - 状态码: 200
  - 响应体: 更新后的设备信息
- **错误响应**:
  - 状态码: 404
  - 响应体: 
    ```json
    {
      "message": "Device not found"
    }
    ```

**测试用例**:
1. 更新存在的设备信息
2. 尝试更新不存在的设备
3. 使用无效的信息更新设备

#### 5. 删除设备

- **URL**: `/devices/{deviceId}`
- **方法**: DELETE
- **描述**: 删除指定的设备
- **请求参数**:
  - `deviceId`: 设备ID (路径参数)
- **成功响应**: 
  - 状态码: 204
- **错误响应**:
  - 状态码: 404
  - 响应体: 
    ```json
    {
      "message": "Device not found"
    }
    ```

**测试用例**:
1. 删除存在的设备
2. 尝试删除不存在的设备
3. 删除设备后尝试再次删除同一设备

#### 6. 获取设备数据

- **URL**: `/devices/{deviceId}/data`
- **方法**: GET
- **描述**: 获取指定设备的数据，支持时间范围和分页
- **请求参数**:
  - `deviceId`: 设备ID (路径参数)
  - `startTime`: 开始时间 (查询参数，格式：yyyy-MM-dd HH:mm:ss)
  - `endTime`: 结束时间 (查询参数，格式：yyyy-MM-dd HH:mm:ss)
  - `page`: 页码 (查询参数，默认为0)
  - `size`: 每页数量 (查询参数，默认为20)
- **成功响应**: 
  - 状态码: 200
  - 响应体: 
    ```json
    {
      "content": [
        {
          "value": 0.3,
          "recordTime": "2023-05-01 10:00:00"
        }
      ],
      "totalPages": 5,
      "totalElements": 100
    }
    ```

**测试用例**:
1. 获取指定时间范围内的设备数据
2. 获取没有数据的时间范围
3. 使用不同的分页参数获取数据
4. 获取不存在设备的数据

### WebSocket API

#### 1. 实时警报

- **URL**: `ws://47.116.66.208:8080/ws`
- **描述**: 建立WebSocket连接以接收实时警报

**测试用例**:
1. 建立WebSocket连接
2. 保持连接并接收警报消息
3. 断开连接后重新连接

#### 2. 警报信息流

- **URL**: `ws://47.116.66.208:8080/ws/alerts`
- **描述**: 建立WebSocket连接以接收警报信息流

**测试用例**:
1. 建立WebSocket连接
2. 接收并处理多个警报消息
3. 测试长时间连接的稳定性

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