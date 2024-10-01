import 'package:flutter/material.dart';
import '../services/device_service.dart';
import '../models/device.dart';

class DataAnalysisScreen extends StatefulWidget {
  @override
  _DataAnalysisScreenState createState() => _DataAnalysisScreenState();
}

class _DataAnalysisScreenState extends State<DataAnalysisScreen> {
  List<Device> _devices = [];
  Device? _selectedDevice;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();
  List<dynamic> _data = [];
  bool _isLoading = false;
  int _currentPage = 0;
  int _totalPages = 0;
  int _pageSize = 10;

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

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _searchData() async {
    if (_selectedDevice == null) return;

    setState(() {
      _isLoading = true;
      _currentPage = 0;
    });

    try {
      String formattedStartDate = "${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')} 00:00:00";
      String formattedEndDate = "${_endDate.year}-${_endDate.month.toString().padLeft(2, '0')}-${_endDate.day.toString().padLeft(2, '0')} 23:59:59";
      
      Map<String, dynamic> result = await DeviceService.getDeviceData(
        _selectedDevice!.id,
        startTime: formattedStartDate,
        endTime: formattedEndDate,
        page: _currentPage,
        size: _pageSize
      );

      setState(() {
        _data = result['content'] as List<dynamic>;
        _totalPages = result['totalPages'];
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载数据失败：$e')),
      );
    }
  }

  void _changePage(int page) {
    if (page >= 0 && page < _totalPages) {
      setState(() {
        _currentPage = page;
      });
      _searchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('数据分析')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text('开始日期: ${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text('结束日期: ${_endDate.year}-${_endDate.month.toString().padLeft(2, '0')}-${_endDate.day.toString().padLeft(2, '0')}'),
                  ),
                ),
              ],
            ),
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
            ElevatedButton(
              onPressed: _searchData,
              child: Text('查找'),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        var item = _data[index] as Map<String, dynamic>;
                        return ListTile(
                          title: Text('值: ${item['value']}'),
                          subtitle: Text('记录时间: ${item['recordTime']}'),
                        );
                      },
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: _currentPage > 0 ? () => _changePage(_currentPage - 1) : null,
                ),
                Text('${_currentPage + 1} / $_totalPages'),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: _currentPage < _totalPages - 1 ? () => _changePage(_currentPage + 1) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}