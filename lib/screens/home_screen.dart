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
              if (_alertMessage != null) AlertWidget(message: _alertMessage!),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '酒精浓度监测系统',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 40),
                        _buildMenuButton(
                          icon: Icons.devices,
                          label: '设备管理',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DeviceListScreen()),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildMenuButton(
                          icon: Icons.analytics,
                          label: '数据分析',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DataAnalysisScreen()),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildMenuButton(
                          icon: Icons.warning,
                          label: '警报信息',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AlertInfoScreen()),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildMenuButton(
                          icon: Icons.settings,
                          label: '设置',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsScreen()),
                          ),
                        ),
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

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}