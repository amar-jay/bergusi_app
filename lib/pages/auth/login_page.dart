import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/routes.dart';
import 'package:myapp/utils/theme_data.dart';

import 'components/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _error = '';

  _setEmail(emal) {
    setState(() {
      _email = emal;
    });
  }

  _setPassword(pass) {
    setState(() {
      _password = pass;
    });
  }

  _gotoHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, ipAddressPageRoute, ModalRoute.withName(logInPageRoute));
  }

  _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        _gotoHome();

        // Navigate to home page or show success message
        debugPrint("Logged in: ${userCredential.user!.uid}");
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'user-not-found') {
            _error = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            _error = 'Wrong password provided for that user.';
          } else {
            _error = 'An error occurred. Please try again.';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ThemeProvider().themeMode == ThemeMode.light
                ? Image.asset(
                    "assets/images/login_light.jpg",
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
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Set the line color to blue
                    thickness: 2.0, // Adjust the thickness as needed
                    indent: 16.0, // Optional: Add indentation from the start
                    endIndent: 16.0, // Optional: Add indentation from the end
                  ),
                  Text(
                    "Hosgeldiniz!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Log in with your data that you intered during your registration.",
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                    formKey: _formKey,
                    setEmail: _setEmail,
                    setPassword: _setPassword,
                  ),
                  Align(
                    child: TextButton(
                      child: const Text("Forgot password"),
                      onPressed: () {
                        Navigator.pushNamed(context, passwordRecoveryPageRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height:
                        size.height > 700 ? size.height * 0.1 : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _handleLogin();
                    },
                    child: const Text("Log in"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpPageRoute);
                        },
                        child: const Text("Sign up"),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _error,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
