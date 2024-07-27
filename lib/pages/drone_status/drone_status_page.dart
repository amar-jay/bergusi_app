import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myapp/pages/drone_status/drone_status_stream.dart';

// Assume the DroneStatus and DroneStatusStream classes are in a separate file
// import 'drone_status.dart';

class DroneStatusPage extends StatefulWidget {
  const DroneStatusPage({Key? key}) : super(key: key);

  @override
  _DroneStatusPageState createState() => _DroneStatusPageState();
}

class _DroneStatusPageState extends State<DroneStatusPage> {
  late DroneStatusStream _droneStatusStream;
  late StreamSubscription<DroneStatus> _subscription;
  DroneStatus? _currentStatus;

  @override
  void initState() {
    super.initState();
    _droneStatusStream = DroneStatusStream();
    _initializeStream();
  }

  void _initializeStream() async {
    final initialStatus = await _droneStatusStream.init(
      DroneStatusType.random,
      0,
      baseUrl: 'https://example.com/api', // Replace with your actual API URL
    );
    setState(() {
      _currentStatus = initialStatus;
    });

    _subscription = _currentStatus!.stream().listen((status) {
      setState(() {
        _currentStatus = status;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
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
                  value: '${_currentStatus!.batteryLevel.toStringAsFixed(1)}%',
                  label: 'Battery',
                ),
                _buildOverviewItem(
                  icon: Icons.speed,
                  value: '${_currentStatus!.speed.toStringAsFixed(1)} m/s',
                  label: 'Speed',
                ),
                _buildOverviewItem(
                  icon: Icons.height,
                  value: '${_currentStatus!.altitude.toStringAsFixed(1)} m',
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
        _buildInfoTile(
            'Longitude', '${_currentStatus!.longitude.toStringAsFixed(4)}°'),
        _buildInfoTile(
            'Latitude', '${_currentStatus!.latitude.toStringAsFixed(4)}°'),
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
