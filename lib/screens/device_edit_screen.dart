import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';

class DeviceEditScreen extends StatefulWidget {
  final Device device;

  DeviceEditScreen({required this.device});

  @override
  _DeviceEditScreenState createState() => _DeviceEditScreenState();
}

class _DeviceEditScreenState extends State<DeviceEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _threshold;

  @override
  void initState() {
    super.initState();
    _name = widget.device.name;
    _threshold = widget.device.threshold ?? 0.0; // 如果 threshold 为空，则默认为 0.0
  }

  void _saveDevice() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Device updatedDevice = widget.device.copyWith(
        name: _name,
        threshold: _threshold,
        isOn: widget.device.isOn, // 保持原有的开关状态
      );
      bool success = await DeviceService.updateDevice(updatedDevice);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新设备失败，请稍后重试')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('编辑设备')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: '设备名称'),
              validator: (value) => value!.isEmpty ? '请输入设备名称' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _threshold.toString(),
              decoration: InputDecoration(labelText: '阈值'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? '请输入阈值' : null,
              onSaved: (value) => _threshold = double.parse(value!),
            ),
            ElevatedButton(
              onPressed: _saveDevice,
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}