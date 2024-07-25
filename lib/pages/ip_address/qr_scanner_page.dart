import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/dialog.dart';
import 'package:myapp/pages/auth/components/snackbar.dart';
import 'package:myapp/routes.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _flashOn = false;
  bool _frontCamera = false;

  String? _ip;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(context, onboardingPageRoute,
            ModalRoute.withName(qrScannerPageRoute));
      }
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(context, onboardingPageRoute,
            ModalRoute.withName(ipAddressPageRoute));
      }
    });
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          // Add back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      // drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              overlayColor: Colors.white,
              borderColor: theme.primaryColor,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.hoverColor,
                        width: 4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Text(
              'Scan QR Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(
                  icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                  onPressed: _toggleFlash,
                ),
                _buildIconButton(
                  icon: Icons.flip_camera_ios,
                  onPressed: _toggleCamera,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        iconSize: 32,
      ),
    );
  }

  _handlesetIp(String? code) {
    setState(() {
      _ip = code;
    });
    Navigator.popAndPushNamed(context, droneControlPageRoute, arguments: {
      'droneIpAddress': _ip,
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      if (ipAddressValidator.isValid(scanData.code)) {
        showCustomSnackBar(context, 'invalid ip address', SnackBarType.error);
        controller.resumeCamera();
      }
      showCustomDialog(context, scanData.code ?? '', callback: () {
        _handlesetIp(scanData.code);
      }, title: "QR Code");
    });
  }

  void _toggleFlash() {
    if (controller != null) {
      controller!.toggleFlash();
      setState(() {
        _flashOn = !_flashOn;
      });
    }
  }

  void _toggleCamera() {
    if (controller != null) {
      controller!.flipCamera();
      setState(() {
        _frontCamera = !_frontCamera;
      });
    }
  }
}
