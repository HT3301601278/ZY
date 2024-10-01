import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _unit = 'mg/L';

  void _changePassword() {
    // TODO: Implement change password functionality
  }

  void _logout() async {
    await AuthService.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置')),
      body: ListView(
        children: [
          ListTile(
            title: Text('修改密码'),
            onTap: _changePassword,
          ),
          ListTile(
            title: Text('单位设置'),
            trailing: DropdownButton<String>(
              value: _unit,
              items: ['mg/L', '‰'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _unit = newValue!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('退出登录'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}