import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _macAddress = '';
  String _communicationChannel = '';
  double? _threshold; // Changed to nullable

  void _addDevice() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Device newDevice = Device(
        id: 0,
        name: _name,
        macAddress: _macAddress,
        communicationChannel: _communicationChannel,
        threshold: _threshold, // Changed to nullable
        isOn: false, // 默认设置为关闭状态
      );
      
      try {
        bool success = await DeviceService.addDevice(newDevice);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('设备添加成功')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('设备添加失败，请稍后重试')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发生错误：$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('添加新设备')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: '设备名称'),
              validator: (value) => value!.isEmpty ? '请输入设备名称' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'MAC地址'),
              validator: (value) => value!.isEmpty ? '请输入MAC地址' : null,
              onSaved: (value) => _macAddress = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '通信通道'),
              validator: (value) => value!.isEmpty ? '请输入通信通道' : null,
              onSaved: (value) => _communicationChannel = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '阈值（可选）'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (double.tryParse(value) == null) {
                    return '请输入有效的数字';
                  }
                }
                return null;
              },
              onSaved: (value) => _threshold = value != null && value.isNotEmpty ? double.parse(value) : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addDevice,
              child: Text('添加设备'),
            ),
          ],
        ),
      ),
    );
  }
}