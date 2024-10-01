import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final String message;

  AlertWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.red,
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}