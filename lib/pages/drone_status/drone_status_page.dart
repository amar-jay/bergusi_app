import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bergusi/pages/drone_status/drone_status_stream.dart';

// Assume the DroneStatus and DroneStatusStream classes are in a separate file

class DroneStatusPage extends StatefulWidget {
  const DroneStatusPage({super.key});

  @override
  _DroneStatusPageState createState() => _DroneStatusPageState();
}

class _DroneStatusPageState extends State<DroneStatusPage> {
  DroneStatusStream? _droneStatusStream;
  StreamSubscription<DroneStatus>? _subscription;
  DroneStatus? _currentStatus;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    setState(() {
      _droneStatusStream = DroneStatusStream();
    });
    final initialStatus = _droneStatusStream?.random(10);
    setState(() {
      _currentStatus = initialStatus;
    });

    setState(() {
      _subscription = _currentStatus?.stream().listen((status) {
        setState(() {
          _currentStatus = status;
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drone Status',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _currentStatus == null
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusOverview(),
                    const SizedBox(height: 24),
                    _buildDetailedInfo(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusOverview() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOverviewItem(
                  icon: Icons.battery_charging_full,
                  value: '${_currentStatus?.batteryLevel.toStringAsFixed(1)}%',
                  label: 'Battery',
                ),
                _buildOverviewItem(
                  icon: Icons.speed,
                  value: '${_currentStatus?.speed.toStringAsFixed(1)} m/s',
                  label: 'Speed',
                ),
                _buildOverviewItem(
                  icon: Icons.height,
                  value: '${_currentStatus?.altitude.toStringAsFixed(1)} m',
                  label: 'Altitude',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildConnectionStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(
      {required IconData icon, required String value, required String label}) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    final isConnected = _currentStatus!.connectionStatus == 'Connected';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isConnected ? Icons.wifi : Icons.wifi_off,
          color: isConnected ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          _currentStatus!.connectionStatus,
          style: TextStyle(
            color: isConnected ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInfoTile('Distance covered (X)',
            '${_currentStatus!.longitude.toStringAsFixed(4)}°'),
        _buildInfoTile('Distance convered (Y)',
            '${_currentStatus!.latitude.toStringAsFixed(4)}°'),
        _buildInfoTile('Distance convered (Z)',
            '${_currentStatus!.latitude.toStringAsFixed(4)}°'),
        _buildInfoTile('Roll', '${_currentStatus!.roll.toStringAsFixed(2)}°'),
        _buildInfoTile('Pitch', '${_currentStatus!.pitch.toStringAsFixed(2)}°'),
        _buildInfoTile('Yaw', '${_currentStatus!.yaw.toStringAsFixed(2)}°'),
        const SizedBox(height: 24),
        const Text('Velocity Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInfoTile('Velocity (X)',
            '${_currentStatus!.velocityX.toStringAsFixed(2)} m/s'),
        _buildInfoTile('Velocity (Y)',
            '${_currentStatus!.velocityY.toStringAsFixed(2)} m/s'),
        _buildInfoTile('Velocity (Z)',
            '${_currentStatus!.velocityZ.toStringAsFixed(2)} m/s'),
        const SizedBox(height: 24),
        const Text('Acceleration Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInfoTile('Acceleration (X)',
            '${_currentStatus!.accelerationX.toStringAsFixed(2)} m/s^2'),
        _buildInfoTile('Acceleration (Y)',
            '${_currentStatus!.accelerationY.toStringAsFixed(2)} m/s^2'),
        _buildInfoTile('Acceleration (Z)',
            '${_currentStatus!.accelerationZ.toStringAsFixed(2)} m/s^2'),
        const SizedBox(height: 24),
        const Text('Status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInfoTile('Status', _currentStatus!.status),
        const SizedBox(height: 24),
        const Text('Battery Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInfoTile('Battery Level',
            '${_currentStatus!.batteryLevel.toStringAsFixed(1)}%'),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
