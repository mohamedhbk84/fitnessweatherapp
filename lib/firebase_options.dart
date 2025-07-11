// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("🔔 [Background] تم استلام إشعار: ${message.notification?.title ?? 'بدون عنوان'}");
}

Future<void> initFirebaseMessaging() async {
  await Firebase.initializeApp();

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log("✅ تم السماح بالإشعارات");

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // اشتراك في topic الطقس
    await FirebaseMessaging.instance.subscribeToTopic('weather_updates').then((_) {
      log("✅ تم الاشتراك في topic: weather_updates");
    }).catchError((e) {
      log("❌ فشل الاشتراك في topic: $e");
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      log('📱 APNs Token: $apnsToken');
    }

  } else {
    log("❌ لم يتم السماح بالإشعارات");
  }
}



class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD************YOUR_KEY',
    appId: '1:1234567890:android:abc123def456',
    messagingSenderId: '1234567890',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD************YOUR_KEY',
    appId: '1:1234567890:ios:abc123def456',
    messagingSenderId: '1234567890',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosClientId: '1234567890-abc123def456.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );
}
