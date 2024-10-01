import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceListItem extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceListItem({Key? key, required this.device, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text('MAC: ${device.macAddress}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(device.isOn ? '开启' : '关闭'),
          SizedBox(width: 8),
          Icon(
            device.isOn ? Icons.check_circle : Icons.cancel,
            color: device.isOn ? Colors.green : Colors.red,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}