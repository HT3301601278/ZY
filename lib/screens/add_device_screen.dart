import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _macAddress = '';
  String _communicationChannel = '';
  double? _threshold;
  bool _isLoading = false;

  void _addDevice() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      Device newDevice = Device(
        id: 0,
        name: _name,
        macAddress: _macAddress,
        communicationChannel: _communicationChannel,
        threshold: _threshold,
        isOn: false,
      );
      
      print('准备添加的设备信息：${newDevice.toJson()}');
      
      try {
        bool success = await DeviceService.addDevice(newDevice);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('设备添加成功')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('设备添加失败，请检查设备信息是否正确')),
          );
        }
      } catch (e) {
        print('添加设备时发生异常：$e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('添加设备时发生错误：$e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
                  '添加新设备',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          label: '设备名称',
                          onSaved: (value) => _name = value!,
                          validator: (value) => value!.isEmpty ? '请输入设备名称' : null,
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          label: 'MAC地址',
                          onSaved: (value) => _macAddress = value!,
                          validator: (value) => value!.isEmpty ? '请输入MAC地址' : null,
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          label: '通信通道',
                          onSaved: (value) => _communicationChannel = value!,
                          validator: (value) => value!.isEmpty ? '请输入通信通道' : null,
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          label: '阈值（可选）',
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _threshold = value != null && value.isNotEmpty ? double.parse(value) : null,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (double.tryParse(value) == null) {
                                return '请输入有效的数字';
                              }
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _addDevice,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.blue)
                              : Text('添加设备', style: TextStyle(color: Colors.blue)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
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

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}