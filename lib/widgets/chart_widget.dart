import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/device_service.dart';

class ChartWidget extends StatefulWidget {
  final int deviceId;

  ChartWidget({required this.deviceId});

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<FlSpot> _spots = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  void _loadChartData() async {
    try {
      final data = await DeviceService.getDeviceHistoricalData(widget.deviceId);
      setState(() {
        _spots = data.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value['value'].toDouble());
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '加载数据失败: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: _spots.length.toDouble() - 1,
          minY: _spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b),
          maxY: _spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b),
          lineBarsData: [
            LineChartBarData(
              spots: _spots,
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}