import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkmatehub/screens/supplier_registration.dart';
import 'package:milkmatehub/screens/user_registration.dart';

class RegistrationScreen extends StatefulWidget {
  final UserType userType;
  const RegistrationScreen({super.key, required this.userType});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userType == UserType.customer
            ? 'User Registration'
            : "Supplier Registration"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FocusManager.instance.primaryFocus!.unfocus();
                        setState(() {
                          isLoading = true;
                        });
                        final UserCredential user = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        if (user.user != null) {
                          if (context.mounted) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              switch (widget.userType) {
                                case UserType.customer:
                                  return UserDetailsRegistration(
                                    user: user.user!,
                                  );
                                case UserType.supplier:
                                  return SupplierRegistration(
                                    user: user.user!,
                                  );
                                default:
                                  return UserDetailsRegistration(
                                    user: user.user!,
                                  );
                              }
                            }), (route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('User registered successfully'),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: const CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

enum UserType { supplier, customer }
