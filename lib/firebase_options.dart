import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'FirebaseOptions have not been configured for this platform.',
        );
      default:
        throw UnsupportedError(
          'FirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaaG767C2BtBH4xBifgu4I_h8op-XjTl0',
    appId: '1:332942455853:android:8482793109268b4199b4a4',
    messagingSenderId: '332942455853',
    projectId: 'mabras-fruitslice',
    databaseURL:
        'https://mabras-fruitslice-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mabras-fruitslice.firebasestorage.app',
  );
}

