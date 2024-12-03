import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCjYnxuEzTqEVU276cGvt_2gpk_Lcedzi4',
    appId: '1:789203855732:web:9bdee454e74119d92f6421',
    messagingSenderId: '789203855732',
    projectId: 'skku-dm',
    authDomain: 'skku-dm.firebaseapp.com',
    storageBucket: 'skku-dm.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJcOES-Dy7xVxvxtv0EaCRZ25FsBrWelg',
    appId: '1:789203855732:android:d45fd5ddbfbd2aff2f6421',
    messagingSenderId: '789203855732',
    projectId: 'skku-dm',
    storageBucket: 'skku-dm.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkUdCjGCTtSZ_V1dLXJLjZhCUhCWfZ-qg',
    appId: '1:789203855732:ios:210dd62b7e3dace22f6421',
    messagingSenderId: '789203855732',
    projectId: 'skku-dm',
    storageBucket: 'skku-dm.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );
}
