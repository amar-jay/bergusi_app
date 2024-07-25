import 'package:flutter/material.dart';
import 'package:myapp/pages/onboarding/onboarding_page.dart';
//import 'package:myapp/pages/ip_address/qr_scanner_page.dart';
import 'package:myapp/routes.dart';
import 'package:myapp/utils/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Bergusi',
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.lightTheme(context),
          // darkTheme: CustomTheme.darkTheme(),
          themeMode: themeProvider.themeMode,
          home: const OnBoardingPage(),
          //QRScannerPage(), //const DroneTelemetryPage(droneIpAddress: "127.0.0.1:5000"),
          onGenerateRoute: generateRoute,
          initialRoute: onboardingPageRoute,
        );
      },
    );
  }
}
