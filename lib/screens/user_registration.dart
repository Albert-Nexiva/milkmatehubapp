import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/user_model.dart';
import 'package:milkmatehub/screens/home_screen.dart';

class UserDetailsRegistration extends StatefulWidget {
  final User user;
  const UserDetailsRegistration({super.key, required this.user});

  @override
  UserDetailsRegistrationState createState() => UserDetailsRegistrationState();
}

class UserDetailsRegistrationState extends State<UserDetailsRegistration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _selectedConsumptionType = 'Household';
  String _selectedDeliveryType = 'Daily';

  final firestoreDB = FirebaseFirestore.instance;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: _validateNotEmpty,
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                        ),
                        validator: _validateNotEmpty,
                      ),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        validator: _validateNotEmpty,
                      ),
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                        ),
                        validator: _validateNotEmpty,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedConsumptionType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedConsumptionType = newValue!;
                          });
                        },
                        items: <String>['Household', 'Commercial']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Consumption Type',
                        ),
                      ),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        validator: _validateNumeric,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedDeliveryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDeliveryType = newValue!;
                          });
                        },
                        items: <String>['Daily', 'Weekly', 'Monthly']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Delivery Type',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            final userModel = UserModel(
                              type: 'user',
                              name: _nameController.text,
                              email: widget.user.email!,
                              address: _addressController.text,
                              phoneNumber: _phoneNumberController.text,
                              city: _cityController.text,
                              consumptionType: _selectedConsumptionType,
                              quantity: _quantityController.text,
                              deliveryType: _selectedDeliveryType,
                              uid: widget.user.uid,
                            );
                            _nameController.clear();
                            _addressController.clear();
                            _phoneNumberController.clear();
                            _cityController.clear();
                            _quantityController.clear();

                            FirestoreDB()
                                .addUser(userModel)
                                .then((value) async {
                              setState(() {
                                isLoading = false;
                              });
                              await CacheStorageService()
                                  .setAuthUser(user: userModel, supplier: null);
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            });
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
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // Validator for not empty fields
  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Validator for numeric fields
  String? _validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
}
