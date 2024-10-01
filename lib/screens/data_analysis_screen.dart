import 'package:flutter/material.dart';
import '../widgets/chart_widget.dart';
import '../services/device_service.dart';
import '../models/device.dart';

class DataAnalysisScreen extends StatefulWidget {
  @override
  _DataAnalysisScreenState createState() => _DataAnalysisScreenState();
}

class _DataAnalysisScreenState extends State<DataAnalysisScreen> {
  List<Device> _devices = [];
  Device? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() async {
    Map<String, dynamic> result = await DeviceService.getDevices();
    setState(() {
      _devices = result['devices'];
      if (_devices.isNotEmpty) {
        _selectedDevice = _devices.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('数据分析')),
      body: Column(
        children: [
          DropdownButton<Device>(
            value: _selectedDevice,
            items: _devices.map((Device device) {
              return DropdownMenuItem<Device>(
                value: device,
                child: Text(device.name),
              );
            }).toList(),
            onChanged: (Device? newValue) {
              setState(() {
                _selectedDevice = newValue;
              });
            },
          ),
          if (_selectedDevice != null)
            Expanded(
              child: ChartWidget(deviceId: _selectedDevice!.id),
            ),
        ],
      ),
    );
  }
}