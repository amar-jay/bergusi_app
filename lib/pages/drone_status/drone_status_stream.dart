import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class DroneStatus {
  final double longitude;
  final double latitude;
  final double altitude;
  final double speed;
  final double batteryLevel;
  final String connectionStatus;

  DroneStatus({
    required this.longitude,
    required this.latitude,
    required this.altitude,
    required this.speed,
    required this.batteryLevel,
    required this.connectionStatus,
  });

  Stream<DroneStatus> stream() {
    return Stream.periodic(
      const Duration(seconds: 1),
      (count) => this,
    );
  }
}

enum DroneStatusType { random, real }

class DroneStatusStream {
  late DroneStatus statusStream;

  late int _count;
  String _baseUrl = "";

  // initialized. if the url exists, then show results from the url else show random data
  FutureOr<DroneStatus> init(DroneStatusType type, int count,
      {String? baseUrl}) async {
    _count = count;
    if (baseUrl != null) {
      _baseUrl = baseUrl;
    }

    switch (type) {
      case DroneStatusType.random:
        return random();
      case DroneStatusType.real:
        return await real();
    }
  }

  Future<DroneStatus> _fetchData() async {
    if (_baseUrl.isEmpty) {
      throw Exception('Base URL is empty');
    }
    final response = await http.get(Uri.parse('$_baseUrl/drone_telemetry'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // type validation
      return DroneStatus(
        longitude: data['longitude'],
        latitude: data['latitude'],
        altitude: data['altitude'],
        speed: data['speed'],
        batteryLevel: data['battery_level'],
        connectionStatus: data['connection_status'],
      );
    }
    throw Exception("An error occured while fetching data");
  }

  Future<DroneStatus> real() async {
    return await _fetchData();
  }

  DroneStatus random() {
    return DroneStatus(
      longitude: 120.9762 + (_count * 0.0001),
      latitude: 14.5823 + (_count * 0.0001),
      altitude: 100 + (_count * 0.5),
      speed: 5 + (_count * 0.1),
      batteryLevel: 100 - (_count * 0.1),
      connectionStatus: _count % 10 == 0 ? 'Disconnected' : 'Connected',
    );
  }
}
