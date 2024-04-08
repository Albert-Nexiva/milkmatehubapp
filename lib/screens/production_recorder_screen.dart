import 'package:flutter/material.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/production_record_model.dart';
import 'package:milkmatehub/models/supplier_model.dart';

class ProductionRecorderScreen extends StatefulWidget {
  const ProductionRecorderScreen({super.key});

  @override
  ProductionRecorderScreenState createState() =>
      ProductionRecorderScreenState();
}

class ProductionRecorderScreenState extends State<ProductionRecorderScreen> {
  TextEditingController selectedTimeController = TextEditingController(
    text: 'Morning',
  );
  TextEditingController literController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController snfController = TextEditingController();
  TextEditingController clrController = TextEditingController();
  DateTime? date;
  final _formKey = GlobalKey<FormState>();
  List<String> timeOptions = ['Morning', 'Evening'];
  bool isLoading = false;
  SupplierModel? supplierModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text('Add Production Record'),
                      DropdownButtonFormField<String>(
                        value: selectedTimeController.text,
                        items: timeOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTimeController.text = newValue ?? '';
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Time',
                        ),
                        validator: validateTime,
                      ),
                      TextFormField(
                        controller: literController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Liter',
                        ),
                        validator: (value) => validateNumeric(value, 'Liter'),
                      ),
                      TextFormField(
                        controller: fatController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Fat',
                        ),
                        validator: (value) => validateNumeric(value, 'Fat'),
                      ),
                      TextFormField(
                        controller: snfController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'SNF',
                        ),
                        validator: (value) => validateNumeric(value, 'SNF'),
                      ),
                      TextFormField(
                        controller: clrController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'CLR',
                        ),
                        validator: (value) => validateNumeric(value, 'CLR'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                literController.clear();
                                fatController.clear();
                                snfController.clear();
                                clrController.clear();
                                date = null;
                              });
                            },
                            child: const Text('Clear'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                FocusManager.instance.primaryFocus!.unfocus();
                                setState(() {
                                  isLoading = true;
                                });
                                final record = ProductionRecordModel(
                                  date: date?.toIso8601String() ??
                                      DateTime.now().toIso8601String(),
                                  liter: double.parse(literController.text)
                                      .toString(),
                                  fat: double.parse(fatController.text)
                                      .toString(),
                                  snf: double.parse(snfController.text)
                                      .toString(),
                                  clr: double.parse(clrController.text)
                                      .toString(),
                                  readingSlot: selectedTimeController.text,
                                  id: generateRandomString(),
                                  supplierId: supplierModel!.uid,
                                  supplierName: supplierModel!.name,
                                );

                                FirestoreDB()
                                    .addProductionRecord(record)
                                    .then((value) async {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Record added successfully'),
                                      ),
                                    );
                                    setState(() {
                                      // selectedTimeController.clear();
                                      literController.clear();
                                      fatController.clear();
                                      snfController.clear();
                                      clrController.clear();
                                      date = null;
                                    });
                                  }
                                });
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
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
  void dispose() {
    selectedTimeController.dispose();
    literController.dispose();
    fatController.dispose();
    snfController.dispose();
    clrController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    CacheStorageService().getAuthUser().then((value) => setState(() {
          supplierModel = value;
        }));
    super.initState();
  }

  String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    final numericValue = double.tryParse(value);
    if (numericValue == null || numericValue <= 0) {
      return 'Please enter a valid $fieldName';
    }
    return null;
  }

  String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a time';
    }
    return null;
  }
}
