import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/admin_module/screens/admin_login.dart';
import 'package:milkmatehub/constants/asset_helper.dart';
import 'package:milkmatehub/firebase/firebaseconfig.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/supplier_model.dart';
import 'package:milkmatehub/models/user_model.dart';
import 'package:milkmatehub/screens/home_screen.dart';
import 'package:milkmatehub/screens/registration_screen.dart';
import 'package:unified_auth/unified_auth.dart';

class LoginScreen extends StatefulHookWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StreamSubscription<User?>? userStream;
  @override
  Widget build(BuildContext context) {
    final userNameController = useTextEditingController();

    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final isSupplier = useState(false);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            LoginAuth(
              background: AssetHelper.bg,
              logo: AssetHelper.logo,
              usernameController: userNameController,
              passwordController: passwordController,
              usernameValidator: (value) =>
                  value!.isEmpty ? 'Username cannot be empty' : null,
              passwordValidator: (value) =>
                  value!.isEmpty ? 'Password cannot be empty' : null,
              usernameHintText: 'Username',
              passwordHintText: 'Password',
              onSupplierRegister: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(
                            userType: UserType.supplier,
                          )),
                );
              },
              onUserRegister: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(
                            userType: UserType.customer,
                          )),
                );
              },
              onLogin: (loginData) async {
                isLoading.value = true;
                try {
                  FireAuth.signInUsingEmailPassword(
                    email: userNameController.text,
                    password: passwordController.text,
                    context: context,
                  );
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                  setState(() {
                    isLoading.value = false;
                  });
                }
                setState(() {
                  userStream = FirebaseAuth.instance.authStateChanges().listen(
                      (User? user) {
                    if (user != null) {
                      saveAndNavigate(user, context, isSupplier.value);
                    }
                  }, onDone: () {
                    isLoading.value = false;
                  }, onError: (Object error, StackTrace stackTrace) {
                    if (error == 'invalid-credential') {
                      if (context.mounted) {
                        setState(() {
                          isLoading.value = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid User!'),
                          ),
                        );
                      }
                    } else if (error == 'wrong-password') {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Incorrect Password!'),
                          ),
                        );
                        setState(() {
                          isLoading.value = false;
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid User!'),
                        ),
                      );
                      setState(() {
                        isLoading.value = false;
                      });
                    }
                  }, cancelOnError: true);
                });
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AdminLoginScreen()));
                        },
                      ),
                      Row(
                        children: [
                          Text(
                              isSupplier.value
                                  ? 'Supplier Login'
                                  : 'Customer Login',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Switch.adaptive(
                              value: isSupplier.value,
                              onChanged: (value) {
                                isSupplier.value = value;
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading.value)
              Center(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const CircularProgressIndicator()),
              ), // Add CircularProgressIndicator here
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (mounted) {
      userStream?.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveAndNavigate(
      User user, BuildContext context, bool isSupplier) async {
    FirestoreDB().getUser(user.uid, isSupplier).then((value) async {
      if (value != null) {
        final isCached = value['type'] == 'supplier'
            ? await CacheStorageService()
                .setAuthUser(supplier: SupplierModel.fromJson(value))
            : await CacheStorageService()
                .setAuthUser(user: UserModel.fromJson(value));

        if (context.mounted && isCached) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    });
  }
}
