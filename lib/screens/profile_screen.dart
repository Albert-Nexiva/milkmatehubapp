import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: CacheStorageService().getAuthUser(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Text('My Profile',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(snapshot.data!.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(snapshot.data!.email,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(snapshot.data!.phoneNumber,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (snapshot.data != null &&
                          snapshot.data!.address.isNotEmpty)
                        Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Text(snapshot.data!.address,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) async {
                              await CacheStorageService().resetKeys();
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) {
                                  return const LoginScreen();
                                }), (route) => false);
                              }
                            });
                          },
                          child: const Text("Sign Out")),
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
