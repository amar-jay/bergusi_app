import 'package:bergusi/components/outlined_active_button.dart';
import 'package:bergusi/pages/auth/components/set_ip_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bergusi/constants.dart';
import 'package:bergusi/routes.dart';
import 'package:bergusi/utils/theme_data.dart';

class IpAddressPage extends StatefulWidget {
  const IpAddressPage({super.key});

  @override
  State<IpAddressPage> createState() => _IpAddressPageState();
}

class _IpAddressPageState extends State<IpAddressPage> {
  final bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _ip;

  _setIp(ip) {
    setState(() {
      _ip = ip;
    });
  }

  _handlesetIp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pushNamed(context, droneControlPageRoute, arguments: {
        'droneIpAddress': _ip,
      });
    }
  }

  _handleLogout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ThemeProvider().themeMode == ThemeMode.light
                ? Image.asset(
                    "assets/images/bg-img.webp",
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/login_dark.png",
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            _isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 700
                              ? MediaQuery.of(context).size.height * 0.05
                              : defaultPadding / 2,
                        ),
                        Text(
                          "Hostu ayarlayın",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        const Text(
                            "Quickly and easily reset your password to regain access to your account."),
                        const SizedBox(height: defaultPadding),
                        SetIpForm(
                          formKey: _formKey,
                          setIp: _setIp,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _handlesetIp();
                          },
                          child: const Text("Set new IP address"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Want to see demo?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, droneControlPageRoute);
                              },
                              child: const Text("Open in test mode"),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 700
                              ? MediaQuery.of(context).size.height * 0.05
                              : defaultPadding / 2,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, qrScannerPageRoute);
                          },
                          child: const Text("Set Ip by QR Code"),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 700
                              ? MediaQuery.of(context).size.height * 0.05
                              : defaultPadding / 2,
                        ),
                        Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .primary, // Set the line color to blue
                          thickness: 2.0, // Adjust the thickness as needed
                          indent:
                              16.0, // Optional: Add indentation from the start
                          endIndent:
                              16.0, // Optional: Add indentation from the end
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 700
                              ? MediaQuery.of(context).size.height * 0.05
                              : defaultPadding / 2,
                        ),
                        OutlinedActiveButton(
                          press: () {
                            _handleLogout();
                            Navigator.popAndPushNamed(
                                context, onboardingPageRoute);

                            // go to login page
                          },
                          text: "Logout",
                          isActive: false,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
