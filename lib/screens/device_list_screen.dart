import 'package:flutter/material.dart';
import '../services/device_service.dart';
import '../models/device.dart';
import '../widgets/device_list_item.dart';
import 'device_detail_screen.dart';
import 'add_device_screen.dart';

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<Device> _devices = [];
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> result = await DeviceService.getDevices(page: _currentPage);
      setState(() {
        _devices = result['devices'];
        _totalPages = result['totalPages'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载设备列表失败：$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设备列表')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      return DeviceListItem(
                        device: _devices[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeviceDetailScreen(device: _devices[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: _currentPage > 0
                          ? () {
                              setState(() {
                                _currentPage--;
                              });
                              _loadDevices();
                            }
                          : null,
                    ),
                    Text('${_currentPage + 1} / $_totalPages'),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: _currentPage < _totalPages - 1
                          ? () {
                              setState(() {
                                _currentPage++;
                              });
                              _loadDevices();
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDeviceScreen()),
          );
          if (result == true) {
            _loadDevices();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}