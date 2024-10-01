class Device {
  final int id;
  final String name;
  final String macAddress;
  final String communicationChannel;
  final double? currentValue;
  final double? threshold;
  final bool isOn;

  Device({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.communicationChannel,
    this.currentValue,
    this.threshold,
    required this.isOn,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      macAddress: json['macAddress'],
      communicationChannel: json['communicationChannel'],
      currentValue: json['currentValue']?.toDouble(),
      threshold: json['threshold']?.toDouble(),
      isOn: json['isOn'],
    );
  }

  Device copyWith({
    String? name,
    double? threshold,
    bool? isOn,
  }) {
    return Device(
      id: this.id,
      name: name ?? this.name,
      macAddress: this.macAddress,
      communicationChannel: this.communicationChannel,
      currentValue: this.currentValue,
      threshold: threshold ?? this.threshold,
      isOn: isOn ?? this.isOn,
    );
  }
}