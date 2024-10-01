import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device.dart';

class DeviceService {
  static const String baseUrl = 'http://47.116.66.208:8080/api';

  static Future<Map<String, dynamic>> getDevices({int page = 0, int size = 10}) async {
    String url = '$baseUrl/devices?page=$page&size=$size';
    print('获取设备信息的链接: $url');  // 添加这行来打印链接
    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept-Charset': 'UTF-8'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      final List<Device> devices = (data['content'] as List)
          .map((deviceJson) => Device.fromJson(deviceJson))
          .toList();
      return {
        'devices': devices,
        'totalPages': data['totalPages'],
      };
    } else {
      throw Exception('Failed to load devices');
    }
  }

  static Future<Map<String, dynamic>> getDeviceData(int deviceId, {String? startTime, String? endTime, int? page, int? size}) async {
    String url = '$baseUrl/devices/$deviceId';
    if (startTime != null && endTime != null && page != null && size != null) {
      url += '/data?startTime=$startTime&endTime=$endTime&page=$page&size=$size';
    }
    print('获取设备数据的链接: $url');  // 添加这行来打印链接
    final response = await http.get(Uri.parse(url), headers: {'Accept-Charset': 'UTF-8'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      if (startTime != null && endTime != null) {
        return data;
      } else {
        return {'device': Device.fromJson(data)};
      }
    } else {
      throw Exception('Failed to load device data');
    }
  }

  static Future<bool> addDevice(Device device) async {
    try {
      print('正在发送添加设备请求：${device.toJson()}');
      final response = await http.post(
        Uri.parse('$baseUrl/devices'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': device.name,
          'macAddress': device.macAddress,
          'communicationChannel': device.communicationChannel,
        }),
      );
      print('服务器响应状态码：${response.statusCode}');
      print('服务器响应内容：${response.body}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('添加设备时发生错误：$e');
      return false;
    }
  }

  static Future<bool> updateDevice(Device device) async {
    final response = await http.put(
      Uri.parse('$baseUrl/devices/${device.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(device.toJson()),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteDevice(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/devices/$id'));

    return response.statusCode == 204;
  }
}