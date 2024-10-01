import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';
import '../widgets/chart_widget.dart';

class DataAnalysisScreen extends StatefulWidget {
  @override
  _DataAnalysisScreenState createState() => _DataAnalysisScreenState();
}

class _DataAnalysisScreenState extends State<DataAnalysisScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Device> _devices = [];
  Device? _selectedDevice;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();
  List<dynamic> _data = [];
  int _currentPage = 0;
  int _totalPages = 0;
  int _pageSize = 20;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDevices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadDevices() async {
    try {
      Map<String, dynamic> result = await DeviceService.getDevices();
      setState(() {
        _devices = result['devices'];
        if (_devices.isNotEmpty) {
          _selectedDevice = _devices.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载设备列表失败：$e')),
      );
    }
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
      // 移除这行: _currentPage = 0;
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
      _searchData();  // 添加这行来重新加载数据
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
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '数据分析',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: '表格'),
                  Tab(text: '图表'),
                ],
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
              ),
              Expanded(
                child: Card(
                  margin: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDateSelectionRow(),
                        SizedBox(height: 16),
                        _buildDeviceSelectionDropdown(),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _searchData,
                          child: Text('查找'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _buildTableView(),
                                    _buildChartView(),
                                  ],
                                ),
                        ),
                        _buildPaginationControls(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectionRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDateButton(true),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildDateButton(false),
        ),
      ],
    );
  }

  Widget _buildDateButton(bool isStartDate) {
    DateTime date = isStartDate ? _startDate : _endDate;
    return ElevatedButton(
      onPressed: () async {
        await _selectDate(context, isStartDate);
        setState(() {
          _currentPage = 0;
        });
        _searchData();
      },
      child: Text(
        '${isStartDate ? "开始" : "结束"}日期: ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        style: TextStyle(color: Colors.blue),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildDeviceSelectionDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Device>(
          value: _selectedDevice,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
          style: TextStyle(color: Colors.blue, fontSize: 16),
          items: _devices.map((Device device) {
            return DropdownMenuItem<Device>(
              value: device,
              child: Text(device.name),
            );
          }).toList(),
          onChanged: (Device? newValue) {
            setState(() {
              _selectedDevice = newValue;
              _currentPage = 0;
            });
            _searchData();
          },
          dropdownColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildTableView() {
    return _data.isEmpty
        ? Center(child: Text('暂无数据'))
        : ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              var item = _data[index] as Map<String, dynamic>;
              return ListTile(
                title: Text('值: ${item['value']}'),
                subtitle: Text('记录时间: ${item['recordTime']}'),
              );
            },
          );
  }

  Widget _buildChartView() {
    return _data.isEmpty
        ? Center(child: Text('暂无数据'))
        : ChartWidget(data: _data);
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: (_currentPage > 0 && !_isLoading) ? () => _changePage(_currentPage - 1) : null,
        ),
        Text('${_currentPage + 1} / $_totalPages'),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: (_currentPage < _totalPages - 1 && !_isLoading) ? () => _changePage(_currentPage + 1) : null,
        ),
      ],
    );
  }
}