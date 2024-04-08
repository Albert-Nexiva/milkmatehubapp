import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/models/feed_model.dart';

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  AddFeedScreenState createState() => AddFeedScreenState();
}

class AddFeedScreenState extends State<AddFeedScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String imageString = "";
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
                      const Text('Add Feed'),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: (value) => validateField(value, 'Name'),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) =>
                            validateField(value, 'Description'),
                      ),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                        validator: (value) => validateNumeric(value, 'Price'),
                      ),
                      TextFormField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight',
                        ),
                        validator: (value) => validateNumeric(value, 'Weight'),
                      ),
                      TextFormField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stock',
                        ),
                        validator: (value) => validateNumeric(value, 'Stock'),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (imageString.isNotEmpty)
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(children: [
                              Image.memory(
                                base64Decode(imageString),
                                fit: BoxFit.fill,
                                width: 60,
                                height: 60,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    imageString = "";
                                  });
                                },
                              ),
                            ])),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          final imagestring = await selectImage();
                          setState(() {
                            imageString = imagestring;
                          });
                          print(imageString);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt),
                                Text("Click to add Image",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              isLoading = true;
                            });
                            final feedModel = FeedModel(
                              feedId: generateRandomString(),
                              name: nameController.text,
                              price: int.parse(priceController.text),
                              weight: int.parse(weightController.text),
                              stock: int.parse(stockController.text),
                              image: imageString,
                              description: descriptionController.text,
                            );
                            FirestoreDB().addFeed(feedModel).then((value) => {
                                  setState(() {
                                    isLoading = false;
                                  }),
                                  nameController.clear(),
                                  priceController.clear(),
                                  weightController.clear(),
                                  stockController.clear(),
                                  descriptionController.clear(),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Feed added successfully'),
                                    ),
                                  ),
                                });
                          }
                        },
                        child: const Text('Save'),
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
    nameController.dispose();
    priceController.dispose();
    weightController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
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
}
