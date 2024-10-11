import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://47.116.66.208:8080/api';
  static User? currentUser;

  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      currentUser = User.fromJson(userData);
      return true;
    }
    return false;
  }

  static Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    return response.statusCode == 200;
  }

  static Future<void> logout() async {
    currentUser = null;
  }

  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    final userId = await _getUserId();
    if (userId == null) {
      return false;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/password?oldPassword=$oldPassword&newPassword=$newPassword'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Change password failed: ${response.body}');
      return false;
    }
  }

  static Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}