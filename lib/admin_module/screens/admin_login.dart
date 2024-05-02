import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/admin_module/screens/admin_dashboard.dart';
import 'package:milkmatehub/constants/asset_helper.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/supplier_model.dart';
import 'package:milkmatehub/models/user_model.dart';
import 'package:milkmatehub/screens/home_screen.dart';
import 'package:unified_auth/repo/textfield.dart';

class AdminLoginScreen extends StatefulHookWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<AdminLoginScreen> {
  StreamSubscription<User?>? userStream;
  @override
  Widget build(BuildContext context) {
    final userNameController = useTextEditingController();

    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(AssetHelper.logo),
                ),
                //Email
                const SizedBox(height: 14),
                CustomTextField(
                    controller: userNameController,
                    hintText: "Username",
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [
                      AutofillHints.email,
                      AutofillHints.telephoneNumber,
                    ],
                    validator: (value) =>
                        value!.isEmpty ? 'Username cannot be empty' : null),

                const SizedBox(height: 14),

                //Password
                CustomTextField(
                    controller: passwordController,
                    autofillHints: const <String>[
                      AutofillHints.password,
                    ],
                    hintText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) =>
                        value!.isEmpty ? 'Password cannot be empty' : null),

                const SizedBox(height: 14),
                ElevatedButton(
                    onPressed: () async {
                      isLoading.value = true;
                      if (userNameController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        if (userNameController.text ==
                                "admin@milkmatehub.com" &&
                            passwordController.text == "root") {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminDashboardScreen(),
                            ),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid Credentials'),
                            ),
                          );
                        }
                      }
                      isLoading.value = false;
                    },
                    child: const Text('Login')),
              ]),
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
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      user: value['type'] == 'supplier'
                          ? SupplierModel.fromJson(value)
                          : UserModel.fromJson(value),
                    )),
          );
        }
      }
    });
  }
}
