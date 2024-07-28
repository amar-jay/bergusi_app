import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:http/http.dart' as http;

class DroneStatus {
  final double longitude;
  final double latitude;
  final double altitude;
  final double speed;
  final double batteryLevel;
  final String connectionStatus;
  final double distanceX;
  final double distanceY;
  final double distanceZ;
  final double roll;
  final double pitch;
  final double yaw;
  final double velocityX;
  final double velocityY;
  final double velocityZ;
  final double accelerationX;
  final double accelerationY;
  final double accelerationZ;
  final String status;

  DroneStatus({
    required this.longitude,
    required this.latitude,
    required this.altitude,
    required this.speed,
    required this.batteryLevel,
    required this.connectionStatus,
    this.distanceX = 0,
    this.distanceY = 0,
    this.distanceZ = 0,
    this.roll = 0,
    this.pitch = 0,
    this.yaw = 0,
    this.velocityX = 0,
    this.velocityY = 0,
    this.velocityZ = 0,
    this.accelerationX = 0,
    this.accelerationY = 0,
    this.accelerationZ = 0,
    required this.status,
  });

  Stream<DroneStatus> stream() {
    return Stream.periodic(
      const Duration(seconds: 1),
      (count) => DroneStatusStream().random(count),
    );
  }
}

enum DroneStatusType { random, real }

class DroneStatusStream {
  late DroneStatus statusStream;

  //late int _count;
  String _baseUrl = "";

  // initialized. if the url exists, then show results from the url else show random data
  FutureOr<DroneStatus> init(DroneStatusType type, {String? baseUrl}) async {
    //_count = count;
    if (baseUrl != null) {
      _baseUrl = baseUrl;
    }

    switch (type) {
      case DroneStatusType.random:
        return random(1);
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
        distanceX: data['Distance_X'],
        distanceY: data['Distance_Y'],
        distanceZ: data['Distance_Z'],
        accelerationX: data['Acceleration_X'],
        accelerationY: data['Acceleration_Y'],
        accelerationZ: data['Acceleration_Z'],
        status: data['Status'],
        roll: data['Roll'],
        pitch: data['Pitch'],
        yaw: data['Yaw'],
        velocityX: data['Velocity_X'],
        velocityY: data['Velocity_Y'],
        velocityZ: data['Velocity_Z'],
      );
    }
    throw Exception("An error occured while fetching data");
  }

  Future<DroneStatus> real() async {
    return await _fetchData();
  }

  DroneStatus random(int count) {
    final dronedata = DroneDataGenerator().generateDroneData();
    return DroneStatus(
      longitude: 120.9762 + (count * 0.0001),
      latitude: 14.5823 + (count * 0.0001),
      distanceX: dronedata['Distance_X'],
      distanceY: dronedata['Distance_Y'],
      distanceZ: dronedata['Distance_Z'],
      roll: dronedata['Roll'],
      pitch: dronedata['Pitch'],
      yaw: dronedata['Yaw'],
      altitude: dronedata['Altitude'],
      velocityX: dronedata['Velocity_X'],
      velocityY: dronedata['Velocity_Y'],
      velocityZ: dronedata['Velocity_Z'],
      accelerationX: dronedata['Acceleration_X'],
      accelerationY: dronedata['Acceleration_Y'],
      accelerationZ: dronedata['Acceleration_Z'],
      status: dronedata['Status'],
      speed: sqrt(pow(dronedata['Velocity_X'], 2) +
          pow(dronedata['Velocity_Y'], 2) +
          pow(dronedata['Velocity_Z'], 2)), //calculate speed from velocity
      batteryLevel: dronedata['Battery'],
      connectionStatus: count % 10 == 0 ? 'Disconnected' : 'Connected',
    );
  }
}

class DroneDataGenerator {
  final Random _random = Random();

  Map<String, dynamic> generateDroneData() {
    var map = {
      "Distance_X": _generateDistance(),
      "Distance_Y": _generateDistance(),
      "Distance_Z": _generateDistance(),
      "Roll": _generateAngle(),
      "Pitch": _generateAngle(),
      "Yaw": _generateAngle(),
      "Altitude": _generateAltitude(),
      "Battery": _generateBattery(),
      "Velocity_X": _generateVelocity(),
      "Velocity_Y": _generateVelocity(),
      "Velocity_Z": _generateVelocity(),
      "Acceleration_X": _generateAcceleration(),
      "Acceleration_Y": _generateAcceleration(),
      "Acceleration_Z": _generateAcceleration(),
      "Roll_Rate": _generateAngularRate(),
      "Pitch_Rate": _generateAngularRate(),
      "Yaw_Rate": _generateAngularRate(),
      "Temperature": _generateTemperature(),
      "Status": _generateStatus(),
    };
    return map;
  }

  double _generateDistance() => 50 + _random.nextDouble() * 50; // 0 to 100 meters

  double _generateAngle() =>
      _random.nextDouble() * 360 - 180; // -180 to 180 degrees

  double _generateAltitude() => 60 + _random.nextDouble() * 60; // 0 to 120 meters

  double _generateBattery() =>
      60 + _random.nextDouble() * 2; // 0 to 100 percent

  double _generateVelocity() => _random.nextDouble() * 20 - 10; // -10 to 10 m/s

  double _generateAcceleration() =>
      _random.nextDouble() * 4 - 2; // -2 to 2 m/s^2

  double _generateAngularRate() =>
      _random.nextDouble() * 100 - 50; // -50 to 50 degrees/s

  double _generateTemperature() =>
      _random.nextDouble() * 50 + 10; // 10 to 60 degrees Celsius

  String _generateStatus() {
    final statuses = [
      'Connected',
      'Disconnected',
      'Flying',
      'Hovering',
      'Landing',
      'Taking Off'
    ];
    return statuses[_random.nextInt(statuses.length)];
  }
}
