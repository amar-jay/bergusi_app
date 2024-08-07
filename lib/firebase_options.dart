// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCjsbAoBJVHTCynDwFG8sHSoDQhoeJcXQk',
    appId: '1:542463082231:web:2a20f02cafd4c2f4999df2',
    messagingSenderId: '542463082231',
    projectId: 'bergusi',
    authDomain: 'bergusi.firebaseapp.com',
    storageBucket: 'bergusi.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBo68BNZLR0VmuRrn4VBgD-qpWd0iGOtns',
    appId: '1:542463082231:android:c81d686f70d3b9de999df2',
    messagingSenderId: '542463082231',
    projectId: 'bergusi',
    storageBucket: 'bergusi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXIOsGfQatOkL7mJXy_c6oDxmts_pOc04',
    appId: '1:542463082231:ios:e0adcd941ba634ff999df2',
    messagingSenderId: '542463082231',
    projectId: 'bergusi',
    storageBucket: 'bergusi.appspot.com',
    iosBundleId: 'com.marmara.bergusi',
  );
}
