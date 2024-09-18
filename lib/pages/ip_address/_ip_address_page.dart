import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bergusi/constants.dart';
// import 'package:bergusi/drawer.dart';
import 'package:bergusi/pages/auth/components/set_ip_form.dart';
import 'package:bergusi/routes.dart';

class IpAddressPage extends StatefulWidget {
  const IpAddressPage({super.key});

  @override
  State<IpAddressPage> createState() => _IpAddressPageState();
}

class _IpAddressPageState extends State<IpAddressPage> {
  final bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(context, onboardingPageRoute,
            ModalRoute.withName(ipAddressPageRoute));
      }
    });

    // if user is logged in to firebase then navigate to home page
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      // set orientation to potrait
      // drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          child: const Text("Change New IP Address"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Wanna checkout demo?"),
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
                      ],
                    ),
                  ),
            const SizedBox.expand(),
            Image.asset(
              "assets/images/bg-img.webp",
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
              // pin to the bottom
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      ),
    );
  }
}
