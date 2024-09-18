import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class DroneTelemetryPage extends StatelessWidget {
  final String droneIpAddress;

  const DroneTelemetryPage({super.key, required this.droneIpAddress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Drone Telemetry'),
          backgroundColor: Colors.transparent,
        ),
        body: Column(children: [
          Text('Drone IP Address: $droneIpAddress'),
          DroneTelemetryWidget(baseUrl: 'http://$droneIpAddress'),
        ]));
  }
}

class DroneTelemetryWidget extends StatefulWidget {
  final String baseUrl;

  const DroneTelemetryWidget({super.key, required this.baseUrl});

  @override
  State<DroneTelemetryWidget> createState() => _DroneTelemetryWidgetState();
}

class _DroneTelemetryWidgetState extends State<DroneTelemetryWidget> {
  Map<String, dynamic> telemetryData = {};
  List<FlSpot> altitudeData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (timer) => _fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    debugPrint(widget.baseUrl);
    final response =
        await http.get(Uri.parse('${widget.baseUrl}/drone_telemetry'));
    if (response.statusCode == 200) {
      setState(() {
        telemetryData = json.decode(response.body);
        _updateAltitudeData();
      });
    }
  }

  void _updateAltitudeData() {
    if (altitudeData.length >= 60) {
      altitudeData.removeAt(0);
    }
    altitudeData.add(
        FlSpot(altitudeData.length.toDouble(), telemetryData['altitude'] ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusSection(),
            const SizedBox(height: 20),
            _buildPositionSection(),
            const SizedBox(height: 20),
            _buildOrientationSection(),
            const SizedBox(height: 20),
            _buildVelocitySection(),
            const SizedBox(height: 20),
            _buildAccelerationSection(),
            const SizedBox(height: 20),
            _buildAltitudeChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${telemetryData['status'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleSmall),
            Text('Battery: ${telemetryData['battery'] ?? 'N/A'}%'),
            Text('Temperature: ${telemetryData['temperature'] ?? 'N/A'}°C'),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Position', style: Theme.of(context).textTheme.titleSmall),
            Text('X: ${telemetryData['distance_x'] ?? 'N/A'} m'),
            Text('Y: ${telemetryData['distance_y'] ?? 'N/A'} m'),
            Text('Z: ${telemetryData['distance_z'] ?? 'N/A'} m'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrientationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Orientation', style: Theme.of(context).textTheme.titleSmall),
            Text('Roll: ${telemetryData['roll'] ?? 'N/A'}°'),
            Text('Pitch: ${telemetryData['pitch'] ?? 'N/A'}°'),
            Text('Yaw: ${telemetryData['yaw'] ?? 'N/A'}°'),
          ],
        ),
      ),
    );
  }

  Widget _buildVelocitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Velocity', style: Theme.of(context).textTheme.titleSmall),
            Text('X: ${telemetryData['velocity_x'] ?? 'N/A'} m/s'),
            Text('Y: ${telemetryData['velocity_y'] ?? 'N/A'} m/s'),
            Text('Z: ${telemetryData['velocity_z'] ?? 'N/A'} m/s'),
          ],
        ),
      ),
    );
  }

  Widget _buildAccelerationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Acceleration', style: Theme.of(context).textTheme.titleSmall),
            Text('X: ${telemetryData['acceleration_x'] ?? 'N/A'} m/s²'),
            Text('Y: ${telemetryData['acceleration_y'] ?? 'N/A'} m/s²'),
            Text('Z: ${telemetryData['acceleration_z'] ?? 'N/A'} m/s²'),
          ],
        ),
      ),
    );
  }

  Widget _buildAltitudeChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Altitude Over Time',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 60,
                  minY: 0,
                  maxY: (altitudeData
                          .map((spot) => spot.y)
                          .reduce((a, b) => a > b ? a : b) *
                      1.2),
                  lineBarsData: [
                    LineChartBarData(
                      spots: altitudeData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
