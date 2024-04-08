import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/firebase/firebaseconfig.dart';
import 'package:milkmatehub/local_storage/key_value_storage_base.dart';
import 'package:milkmatehub/screens/start_up_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseConfig.initializeFirebase();
  CacheStorageBase.init();
  runApp(const Milkmatehub());
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
