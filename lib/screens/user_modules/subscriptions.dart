import 'package:flutter/material.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/user_model.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  final TextEditingController _quantityController = TextEditingController();
  String _selectedConsumptionType = 'Household';
  String _selectedDeliveryType = 'Daily';

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscriptions'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child: Container(
                            //     padding: const EdgeInsets.all(16),
                            //     child: const Text('My Subscriptions',
                            //         style: TextStyle(
                            //             fontSize: 24,
                            //             color: Colors.black,
                            //             fontWeight: FontWeight.bold)),
                            //   ),
                            // ),
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
                            Card(
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.shopping_bag,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(snapshot.data!.consumptionType,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.water_drop_rounded,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                            snapshot.data!.quantity + " Litres",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.delivery_dining,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(snapshot.data!.deliveryType,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return (Form(
                                            key: _formKey,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  DropdownButtonFormField(
                                                    value:
                                                        _selectedConsumptionType,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _selectedConsumptionType =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: [
                                                      'Household',
                                                      'Commercial'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Consumption Type',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        _quantityController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Quantity',
                                                    ),
                                                    validator: _validateNumeric,
                                                  ),
                                                  DropdownButtonFormField(
                                                    value:
                                                        _selectedDeliveryType,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _selectedDeliveryType =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: [
                                                      'Daily',
                                                      'Weekly',
                                                      'Monthly'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Delivery Type',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16.0),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            FirestoreDB()
                                                                .updateUserSubscription(UserModel(
                                                                    name: snapshot
                                                                        .data!
                                                                        .name,
                                                                    address: snapshot
                                                                        .data!
                                                                        .address,
                                                                    phoneNumber:
                                                                        snapshot
                                                                            .data!
                                                                            .phoneNumber,
                                                                    city: snapshot
                                                                        .data!
                                                                        .city,
                                                                    consumptionType:
                                                                        _selectedConsumptionType,
                                                                    quantity:
                                                                        _quantityController
                                                                            .text,
                                                                    deliveryType:
                                                                        _selectedDeliveryType,
                                                                    email: snapshot
                                                                        .data!
                                                                        .email,
                                                                    uid: snapshot
                                                                        .data!
                                                                        .uid))
                                                                .then(
                                                                    (value) async {
                                                              await CacheStorageService().setAuthUser(
                                                                  user: UserModel(
                                                                      name: snapshot
                                                                          .data!
                                                                          .name,
                                                                      address: snapshot
                                                                          .data!
                                                                          .address,
                                                                      phoneNumber: snapshot
                                                                          .data!
                                                                          .phoneNumber,
                                                                      city: snapshot
                                                                          .data!
                                                                          .city,
                                                                      consumptionType:
                                                                          _selectedConsumptionType,
                                                                      quantity:
                                                                          _quantityController
                                                                              .text,
                                                                      deliveryType:
                                                                          _selectedDeliveryType,
                                                                      email: snapshot
                                                                          .data!
                                                                          .email,
                                                                      uid: snapshot
                                                                          .data!
                                                                          .uid),
                                                                  supplier:
                                                                      null);
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                              if (context
                                                                  .mounted) {
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            });
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: Colors
                                                              .green, // Set button color to red
                                                        ),
                                                        child: const Text(
                                                          'Update Subscription',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.green, // Set button color to red
                                  ),
                                  child: const Text(
                                    'Change Subscription',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
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
    );
  }

  @override
  void initState() {
    CacheStorageService().getAuthUser().then((value) => {
          _selectedConsumptionType = value.consumptionType,
          _quantityController.text = value.quantity,
          _selectedDeliveryType = value.deliveryType,
        });
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
