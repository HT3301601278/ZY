import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _unit = 'mg/L';

  void _changePassword() async {
    String oldPassword = '';
    String newPassword = '';

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('修改密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: '旧密码'),
                onChanged: (value) => oldPassword = value,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: '新密码'),
                onChanged: (value) => newPassword = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('取消'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('确认'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        bool success = await AuthService.changePassword(oldPassword, newPassword);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('密码修改成功')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('密码修改失败，请重试')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('密码修改出错：$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.blue.shade700],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      '设置',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  margin: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  child: ListView(
                    children: [
                      _buildSettingItem(
                        icon: Icons.lock,
                        title: '修改密码',
                        onTap: _changePassword,
                      ),
                      _buildSettingItem(
                        icon: Icons.straighten,
                        title: '单位设置',
                        onTap: () {}, // 添加一个空的onTap函数
                        trailing: DropdownButton<String>(
                          value: _unit,
                          onChanged: (String? newValue) {
                            setState(() {
                              _unit = newValue!;
                            });
                          },
                          items: <String>['mg/L', 'g/100mL', '‰']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}