import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/insurance_model.dart';
import 'package:milkmatehub/models/supplier_model.dart';

class InsuranceApplicationScreen extends StatefulWidget {
  const InsuranceApplicationScreen({super.key});

  @override
  InsuranceApplicationScreenState createState() =>
      InsuranceApplicationScreenState();
}

class InsuranceApplicationScreenState
    extends State<InsuranceApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numCowsInsuredController =
      TextEditingController();
  final TextEditingController _numCowsAffectedController =
      TextEditingController();
  final TextEditingController _dateOfIncidentController =
      TextEditingController();
  final TextEditingController _causeOfDeathController = TextEditingController();
  final TextEditingController _descriptionOfIncidentController =
      TextEditingController();
  String _typeOfCoverageRequestedController = "basic";

  bool isLoading = false;
  bool declared = false;
  SupplierModel? supplierModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Application'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _numCowsInsuredController,
                    decoration: const InputDecoration(
                        labelText: 'Number of Cows Insured'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter the number of cows insured';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _numCowsAffectedController,
                    decoration: const InputDecoration(
                        labelText: 'Number of Cows Affected'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter the number of cows affected';
                      }

                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          _dateOfIncidentController.text =
                              DateFormat('dd-MM-yyyy').format(value);
                        }
                      });
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _dateOfIncidentController,
                        decoration: const InputDecoration(
                            labelText: 'Date of Incident'),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter the date of the incident';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _causeOfDeathController,
                    decoration:
                        const InputDecoration(labelText: 'Cause of Death'),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter the cause of death';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf']);

                      if (result != null) {
                        File file = File(result.files.single.path!);
                        final bytes = File(file.path).readAsBytesSync();

                        setState(() {
                          _descriptionOfIncidentController.text =
                              base64Encode(bytes);
                        });
                      } 
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          _descriptionOfIncidentController.text.isEmpty
                              ? "Description of Incident"
                              : "File Added",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // TextFormField(
                  //   controller: _descriptionOfIncidentController,
                  //   decoration: const InputDecoration(
                  //       labelText: 'Description of Incident'),
                  //   validator: (value) {
                  //     if (value != null && value.isEmpty) {
                  //       return 'Please enter the description of the incident';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  DropdownButtonFormField<String>(
                    value: _typeOfCoverageRequestedController,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _typeOfCoverageRequestedController = newValue;
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: declared
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              final insuranceModel = InsuranceModel(
                                name: _nameController.text,
                                address: _addressController.text,
                                numCowsInsured: _numCowsInsuredController.text,
                                numCowsAffected:
                                    _numCowsAffectedController.text,
                                dateOfIncident: _dateOfIncidentController.text,
                                causeOfDeath: _causeOfDeathController.text,
                                descriptionOfIncident:
                                    _descriptionOfIncidentController.text,
                                typeOfCoverageRequested:
                                    _typeOfCoverageRequestedController,
                                uid: generateRandomString(),
                                supplierId: supplierModel!.uid,
                              );

                              FirestoreDB()
                                  .addInsuranceApplication(insuranceModel)
                                  .then((value) async {
                                setState(() {
                                  isLoading = false;
                                });

                                if (context.mounted) {
                                  _nameController.clear();
                                  _addressController.clear();
                                  _numCowsInsuredController.clear();
                                  _numCowsAffectedController.clear();
                                  _dateOfIncidentController.clear();
                                  _causeOfDeathController.clear();
                                  _descriptionOfIncidentController.clear();
                                  _typeOfCoverageRequestedController = "basic";
                                  declared = false;
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Insurance application submitted')));
                                }
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
                    child: const Text('Apply'),
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
    _nameController.dispose();
    _addressController.dispose();
    _numCowsInsuredController.dispose();
    _numCowsAffectedController.dispose();
    _dateOfIncidentController.dispose();
    _causeOfDeathController.dispose();
    _descriptionOfIncidentController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    CacheStorageService().getAuthUser().then((value) => setState(() {
          supplierModel = value;
        }));
    super.initState();
  }
}
