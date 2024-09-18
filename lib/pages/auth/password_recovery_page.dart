// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bergusi/constants.dart';
import 'package:bergusi/pages/auth/components/reset_password_form.dart';
import 'package:bergusi/pages/auth/components/snackbar.dart';
import 'package:bergusi/routes.dart';
import 'package:bergusi/utils/theme_data.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  _setEmail(emal) {
    setState(() {
      _emailController.text = emal;
    });
  }

  // snackbar reset password
  void _snackbar_rp() {
    showCustomSnackBar(
        context, 'Password reset email sent', SnackBarType.notification);
  }

  // snackbar error
  void _snackbar_error(String? message) {
    showCustomSnackBar(context, message ?? "Unknown error", SnackBarType.error);
  }

  _gotoLogin() {
    Navigator.of(context).pop();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text)
            .then((value) {
          _snackbar_rp();
          _gotoLogin();
        });
      } on FirebaseAuthException catch (e) {
        _snackbar_error(e.message);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
                        Text(
                          "Şifreyi sifirla!",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        const Text(
                            "Quickly and easily reset your password to regain access to your account."),
                        const SizedBox(height: defaultPadding),
                        ResetPasswordForm(
                          formKey: _formKey,
                          setEmail: _setEmail,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Hmm, want to try again?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, logInPageRoute);
                              },
                              child: const Text("Go to Login"),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 700
                              ? MediaQuery.of(context).size.height * 0.1
                              : defaultPadding,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _handleResetPassword();
                          },
                          child: const Text("Change Password"),
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
