import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';
import 'device_edit_screen.dart';

class DeviceDetailScreen extends StatefulWidget {
  final Device device;

  DeviceDetailScreen({required this.device});

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late Device _device;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _loadDeviceData();
  }

  void _loadDeviceData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> result = await DeviceService.getDeviceData(_device.id);
      Device updatedDevice = result['device'];
      setState(() {
        _device = updatedDevice;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_device.name)),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MAC地址: ${_device.macAddress}'),
                  SizedBox(height: 8),
                  Text('通信通道: ${_device.communicationChannel}'),
                  SizedBox(height: 8),
                  Text('阈值: ${_device.threshold}'),
                  SizedBox(height: 8),
                  Text('状态: ${_device.isOn ? '开启' : '关闭'}'),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeviceEditScreen(device: _device),
            ),
          ).then((_) => _loadDeviceData());
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}