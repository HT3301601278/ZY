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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      '警报信息',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _alerts.isEmpty
                    ? Center(
                        child: Text(
                          '暂无警报信息',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _alerts.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: Colors.white.withOpacity(0.9),
                            child: ListTile(
                              title: Text(_alerts[index]),
                              leading: Icon(Icons.warning, color: Colors.red),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _alerts.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WebSocketService.close('ws://47.116.66.208:8080/ws/alerts');
    super.dispose();
  }
}