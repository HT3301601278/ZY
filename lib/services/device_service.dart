import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/device.dart';

class DeviceService {
  static const String baseUrl = 'http://47.116.66.208:8080/api';

  static Future<Map<String, dynamic>> getDevices({int page = 0, int size = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/devices?page=$page&size=$size'),
      headers: {'Accept-Charset': 'UTF-8'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> devicesJson = jsonResponse['content'];
      List<Device> devices = devicesJson.map((json) => Device.fromJson(json)).toList();
      return {
        'devices': devices,
        'totalPages': jsonResponse['totalPages'],
        'totalElements': jsonResponse['totalElements'],
        'currentPage': jsonResponse['number'],
      };
    } else {
      throw Exception('Failed to load devices');
    }
  }

  static Future<Device> getDeviceData(int deviceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/devices/$deviceId'),
      headers: {'Accept-Charset': 'UTF-8'},
    );

    if (response.statusCode == 200) {
      return Device.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load device data');
    }
  }

  static Future<double?> getLatestDeviceValue(int deviceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/devices/$deviceId/latest-value'),
      headers: {'Accept-Charset': 'UTF-8'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['value']?.toDouble();
    } else {
      throw Exception('Failed to load latest device value');
    }
  }

  static Future<bool> updateDevice(Device device) async {
    final response = await http.put(
      Uri.parse('$baseUrl/devices/${device.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': device.name,
        'threshold': device.threshold,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> addDevice(Device device) async {
    final response = await http.post(
      Uri.parse('$baseUrl/devices'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': device.name,
        'macAddress': device.macAddress,
        'communicationChannel': device.communicationChannel,
        'threshold': device.threshold,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<List<Map<String, dynamic>>> getDeviceHistoricalData(int deviceId) async {
    final response = await http.get(Uri.parse('$baseUrl/devices/$deviceId/historical-data'));

    if (response.statusCode == 200) {
      List<dynamic> dataJson = jsonDecode(response.body);
      return dataJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}