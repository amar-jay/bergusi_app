import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myapp/pages/drone_status/drone_status_stream.dart';

class DroneStatusWidget extends StatefulWidget {
  final Stream<DroneStatus> statusStream;

  const DroneStatusWidget({super.key, required this.statusStream});

  @override
  State<DroneStatusWidget> createState() => _DroneStatusWidgetState();
}

class _DroneStatusWidgetState extends State<DroneStatusWidget> {
  late StreamSubscription<DroneStatus> _subscription;
  DroneStatus? _currentStatus;

  @override
  void initState() {
    super.initState();
    _subscription = widget.statusStream.listen((status) {
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Drone Status',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (_currentStatus != null) ...[
              _buildStatusRow('Longitude',
                  '${_currentStatus!.longitude.toStringAsFixed(6)}°'),
              _buildStatusRow('Latitude',
                  '${_currentStatus!.latitude.toStringAsFixed(6)}°'),
              _buildStatusRow('Altitude',
                  '${_currentStatus!.altitude.toStringAsFixed(2)} m'),
              _buildStatusRow(
                  'Speed', '${_currentStatus!.speed.toStringAsFixed(2)} m/s'),
              _buildStatusRow('Battery',
                  '${_currentStatus!.batteryLevel.toStringAsFixed(1)}%'),
              _buildConnectionStatus(_currentStatus!.connectionStatus),
            ] else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'connected':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'disconnected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 8),
          Text(
            'Status: $status',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Example usage:
class DroneStatusPage extends StatefulWidget {
  const DroneStatusPage({super.key});

  @override
  State<DroneStatusPage> createState() => _DroneStatusPageState();
}

class _DroneStatusPageState extends State<DroneStatusPage> {
  // This would typically come from your drone control system
  Stream<DroneStatus>? droneStatus;

  @override
  void initState() async {
    super.initState();
    final drone = await DroneStatusStream().init(DroneStatusType.random, 10);
    final s = drone.stream();
    setState(() async {
      droneStatus = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Drone Control',
            style: theme.textTheme.titleLarge,
          )),
      body: Center(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            droneStatus != null
                ? DroneStatusWidget(statusStream: droneStatus!)
                : Container(),
          ],
        ),
      )),
    );
  }
}
