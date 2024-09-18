import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bergusi/constants.dart';
import 'package:bergusi/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // firebase logout
  void _logout(BuildContext context) {
    // Implement your logout logic here
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.primaryColor,
            ),
            child: const Text('Bergusi',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // ListTile(
          //   title: const Text('Onboarding'),
          //   onTap: () {
          //     Navigator.pushNamed(context, onboardingPageRoute);
          //   },
          // ),
          ListTile(
            title: const Text('IP Address'),
            onTap: () {
              Navigator.pushNamed(context, ipAddressPageRoute);
            },
          ),
          ListTile(
            title: const Text('QR Scanner'),
            onTap: () {
              Navigator.pushNamed(context, qrScannerPageRoute);
            },
          ),
          ListTile(
            title: const Text('Drone Control'),
            onTap: () {
              Navigator.pushNamed(context, droneControlPageRoute);
            },
          ),

          ListTile(
            title: const Text('Drone Status'),
            onTap: () {
              Navigator.pushNamed(context, droneStatusPageRoute);
            },
          ),
          ListTile(
            title: const Text('Drone Telemetry'),
            onTap: () {
              Navigator.pushNamed(context, droneTelemetryPageRoute);
            },
          ),

          // move button to the bottom
          const SizedBox(height: 20),

          // logout button
          ElevatedButton(
            onPressed: () => _logout(context),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
