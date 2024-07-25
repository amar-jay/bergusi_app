import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/auth/components/snackbar.dart';
import 'package:myapp/utils/theme_data.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/sign_up_form.dart';
import 'package:myapp/routes.dart';

import '../../../constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  bool acceptTerms = false;
  String _password = '';
  // ignore: prefer_final_fields
  String _verifyPassword = '';

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

  _setVerifyPassword(pass) {
    setState(() {
      _verifyPassword = pass;
    });
  }

  _gotoHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, ipAddressPageRoute, ModalRoute.withName(logInPageRoute));
  }

  _handleError(FirebaseAuthException e) {
    if (e.code == 'user-not-found') {
      showCustomSnackBar(
          context, 'No user found for that email.', SnackBarType.error);
    } else if (e.code == 'wrong-password') {
      showCustomSnackBar(context, 'Wrong password provided for that user.',
          SnackBarType.error);
    } else {
      showCustomSnackBar(
          context, 'An error occurred. Please try again.', SnackBarType.error);
    }
  }

  _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_email.isEmpty || _password.isEmpty) {
        showCustomSnackBar(context, 'Please enter your email and password',
            SnackBarType.warning);
        return;
      }

      if (_password != _verifyPassword) {
        showCustomSnackBar(
            context, 'Passwords do not match', SnackBarType.warning);
        return;
      }

      if (!acceptTerms) {
        showCustomSnackBar(context, 'Please accept the terms and conditions',
            SnackBarType.warning);
        return;
      }
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: _email, password: _password);
        debugPrint("Logged in: ${userCredential.user!.uid}");
        // Navigate to home page or show success message
        _gotoHome();
      } on FirebaseAuthException catch (e) {
        _handleError(e);
      }
    }
  }

  Future<void> _launchTerms() async {
    if (!await launchUrl(acceptTermsUrl as Uri)) {
      throw Exception('Could not launch $acceptTermsUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ThemeProvider().themeMode == ThemeMode.light
                ? Image.asset(
                    "assets/images/signup_light.jpg",
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/signup_dark.png",
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
                    "Let’s get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Please enter your valid data in order to create an account.",
                  ),
                  const SizedBox(height: defaultPadding),
                  SignUpForm(
                    formKey: _formKey,
                    setEmail: _setEmail,
                    setPassword: _setPassword,
                    setVerifyPassword: _setVerifyPassword,
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Checkbox(
                        onChanged: (value) {
                          setState(() => acceptTerms = value ?? false);
                        },
                        value: acceptTerms,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree with the",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _launchTerms,
                                text: " Terms of service ",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(
                                text: "& privacy policy.",
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  ElevatedButton(
                    onPressed: () {
                      _handleSignUp();
                    },
                    child: const Text("Continue"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do you have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, logInPageRoute);
                        },
                        child: const Text("Log in"),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
