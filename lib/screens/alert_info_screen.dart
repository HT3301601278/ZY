import 'package:flutter/material.dart';
import '../services/websocket_service.dart';

class AlertInfoScreen extends StatefulWidget {
  @override
  _AlertInfoScreenState createState() => _AlertInfoScreenState();
}

class _AlertInfoScreenState extends State<AlertInfoScreen> {
  List<String> _alerts = [];

  @override
  void initState() {
    super.initState();
    WebSocketService.connect('ws://47.116.66.208:8080/ws/alerts', _handleAlertMessage);
  }

  void _handleAlertMessage(dynamic message) {
    setState(() {
      _alerts.add(message.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('警报信息')),
      body: ListView.builder(
        itemCount: _alerts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_alerts[index]),
            leading: Icon(Icons.warning, color: Colors.red),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    WebSocketService.close('ws://47.116.66.208:8080/ws/alerts');
    super.dispose();
  }
}