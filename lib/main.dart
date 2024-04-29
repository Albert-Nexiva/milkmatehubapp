import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/api/firebase_messaging_api.dart';
import 'package:milkmatehub/firebase/firebaseconfig.dart';
import 'package:milkmatehub/local_storage/key_value_storage_base.dart';
import 'package:milkmatehub/notification_helper.dart';
import 'package:milkmatehub/screens/feed_order_screen.dart';
import 'package:milkmatehub/screens/start_up_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();
  CacheStorageBase.init();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  NotificationHelper.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: const Milkmatehub()));
}

class Milkmatehub extends HookWidget {
  const Milkmatehub({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Milkmate Hub',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const StartupScreen()),
    );
  }
}
