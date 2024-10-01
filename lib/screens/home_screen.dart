import 'package:flutter/material.dart';
import 'device_list_screen.dart';
import 'data_analysis_screen.dart';
import 'settings_screen.dart';
import '../widgets/alert_widget.dart';
import '../services/websocket_service.dart';
import 'alert_info_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _alertMessage;

  @override
  void initState() {
    super.initState();
    WebSocketService.connect('ws://47.116.66.208:8080/ws', _handleWebSocketMessage);
  }

  void _showAlert(String message) {
    setState(() {
      _alertMessage = message;
    });
  }

  void _handleWebSocketMessage(dynamic message) {
    if (message is String) {
      _showAlert(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('酒精浓度监测系统')),
      body: Column(
        children: [
          if (_alertMessage != null) AlertWidget(message: _alertMessage!),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeviceListScreen()),
                      );
                    },
                    child: Text('设备管理'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataAnalysisScreen()),
                      );
                    },
                    child: Text('数据分析'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlertInfoScreen()),
                      );
                    },
                    child: Text('警报信息'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      );
                    },
                    child: Text('设置'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}