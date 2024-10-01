import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _confirmPassword = '';

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await AuthService.register(_username, _password);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('注册成功，请返回登录')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('注册失败，请稍后重试')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('注册')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: '用户名'),
              validator: (value) => value!.isEmpty ? '请输入用户名' : null,
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '密码'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return '请输入密码';
                }
                _password = value;
                return null;
              },
              onSaved: (value) => _password = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '确认密码'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return '请再次输入密码';
                }
                if (value != _password) {
                  return '两次输入的密码不一致';
                }
                return null;
              },
              onSaved: (value) => _confirmPassword = value!,
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text('注册'),
            ),
          ],
        ),
      ),
    );
  }
}