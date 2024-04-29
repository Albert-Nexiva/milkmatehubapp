import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/supplier_model.dart';
import 'package:milkmatehub/screens/home_screen.dart';

class SupplierRegistration extends StatefulWidget {
  final User user;
  const SupplierRegistration({super.key, required this.user});

  @override
  SupplierRegistrationState createState() => SupplierRegistrationState();
}

class SupplierRegistrationState extends State<SupplierRegistration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _cowCountController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _bankAccountNumberController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankBranchController = TextEditingController();
  final TextEditingController _bankIFSCController = TextEditingController();
  final TextEditingController _insuranceCoverageController =
      TextEditingController();

  final List<Cow> _cowList = [];
  String _insuranceCoverageValue = 'basic';
  final TextEditingController _cowIDController = TextEditingController();
  final TextEditingController _cowBreedController = TextEditingController();
  final TextEditingController _cowAgeController = TextEditingController();
  final TextEditingController _cowProductionCapacityController =
      TextEditingController();
  final firestoreDB = FirebaseFirestore.instance;
  bool isLoading = false;
  bool addCow = false;
  bool declared = false;
  final _formKey = GlobalKey<FormState>();
  String fcmToken = '';
  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() {
      fcmToken = token.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Details'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Stack(children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      }),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cowCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'No. of Cows',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of cows';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_cowList.length <
                            int.parse(_cowCountController.text)) {
                          setState(() {
                            addCow = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'You have already added the required number of cows',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Tap to add Cow'),
                    ),
                  ),
                  if (addCow)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _cowIDController,
                            decoration: const InputDecoration(
                              labelText: 'Cow Tag Number',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the cow tag number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _cowBreedController,
                            decoration: const InputDecoration(
                              labelText: 'Cow Breed',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the cow breed';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _cowAgeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Cow Age',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the cow age';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _cowProductionCapacityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Milk Production Capacity',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the milk production capacity';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              _cowList.add(
                                Cow(
                                  id: _cowIDController.text,
                                  breed: _cowBreedController.text,
                                  age: int.parse(_cowAgeController.text),
                                  productionCapacity: int.parse(
                                      _cowProductionCapacityController.text),
                                ),
                              );
                              setState(() {
                                addCow = false;
                                _cowAgeController.clear();
                                _cowBreedController.clear();
                                _cowIDController.clear();
                                _cowProductionCapacityController.clear();
                              });
                            },
                            child: const Text('Add Cow',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cowList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Tag: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _cowList[index].id,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Breed: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _cowList[index].breed,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Age: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${_cowList[index].age}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Milk Capacity: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${_cowList[index].productionCapacity}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _cowList.removeAt(index);
                                });
                              },
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  TextFormField(
                    controller: _experienceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Experience Years',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your experience years';
                      }
                      return null;
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Text(
                          'Bank Details',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          controller: _bankAccountNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Bank Account Number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a bank account number';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _bankNameController,
                          decoration: const InputDecoration(
                            labelText: 'Bank Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a bank name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _bankBranchController,
                          decoration: const InputDecoration(
                            labelText: 'Bank Branch',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a bank branch';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _bankIFSCController,
                          decoration: const InputDecoration(
                            labelText: 'Bank IFSC',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a bank IFSC';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: _insuranceCoverageValue,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _insuranceCoverageValue = newValue;
                          _insuranceCoverageController.text = newValue;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Insurance Coverage',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'basic',
                        child: Text('Basic Coverage - ₹3000'),
                      ),
                      DropdownMenuItem(
                        value: 'standard',
                        child: Text('Standard Coverage - ₹5000'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an insurance coverage';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: declared,
                          onChanged: (value) {
                            setState(() {
                              declared = value!;
                            });
                          },
                        ),
                        const Flexible(
                          flex: 1,
                          child: Text(
                            'I confirm that the above details provided are correct and true to my knowledge.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: declared
                        ? () {
                            if (_cowList.length <
                                int.parse(_cowCountController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please add all the cows',
                                  ),
                                ),
                              );
                            } else if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              final supplierModel = SupplierModel(
                                  type: "supplier",
                                  uid: widget.user.uid,
                                  name: _nameController.text,
                                  address: _addressController.text,
                                  phoneNumber: _phoneController.text,
                                  city: _cityController.text,
                                  numberOfCows:
                                      int.parse(_cowCountController.text),
                                  cows: _cowList.map((cow) => cow).toList(),
                                  experienceYears:
                                      int.parse(_experienceController.text),
                                  bank: Bank(
                                    accountNumber:
                                        _bankAccountNumberController.text,
                                    branch: _bankBranchController.text,
                                    ifsc: _bankIFSCController.text,
                                    bankName: _bankNameController.text,
                                  ),
                                  insuranceCoverage:
                                      _insuranceCoverageController.text,
                                  email: widget.user.email!,
                                  fcm: fcmToken);

                              FirestoreDB()
                                  .addSupplier(supplierModel)
                                  .then((value) async {
                                setState(() {
                                  isLoading = false;
                                });
                                await CacheStorageService().setAuthUser(
                                    user: null, supplier: supplierModel);
                                if (context.mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                                _nameController.clear();
                                _phoneController.clear();
                                _addressController.clear();
                                _cityController.clear();
                                _cowCountController.clear();
                                _cowList.clear();
                                _experienceController.clear();
                                _bankAccountNumberController.clear();
                                _bankNameController.clear();
                                _bankBranchController.clear();
                                _bankIFSCController.clear();
                              });
                            }
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey; // Disabled color
                          }
                          return Colors.blue; // Enabled color
                        },
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ]),
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
          ]),
        ),
      ),
    );
  }
}
