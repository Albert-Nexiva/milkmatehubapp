import 'package:flutter/material.dart';
import 'package:milkmatehub/constants/asset_helper.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/screens/home_screen.dart';
import 'package:milkmatehub/screens/login_screen.dart';
import 'package:unified_auth/unified_auth.dart';

Future<void> navigateToHome(BuildContext context) async {
  final user = await CacheStorageService().getAuthUser();
  if (user != null) {
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen(
                user: user,
          )),
          (route) => false);
    }
  } else {
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }
  }
}

//Providers

//routes

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  Widget build(BuildContext context) {
    return const UnifiedSplashScreen(
      icon: AssetHelper.logo,
    );
  }

  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => navigateToHome(context));
  }
}
