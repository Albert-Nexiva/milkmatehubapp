import 'package:flutter/material.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/screens/user_modules/sub_payment.dart';

class UserPayments extends StatefulWidget {
  const UserPayments({super.key});

  @override
  State<UserPayments> createState() => _UserPaymentsState();
}

class _UserPaymentsState extends State<UserPayments> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Payments'),
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
                            //     child: const Text('My UserPayments',
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
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubPaymentScreen(
                                        paymentTotal:
                                            "${double.parse(snapshot.data!.quantity.toString()) * (snapshot.data!.deliveryType == "Daily" ? 50.0 : snapshot.data!.deliveryType == "Weekly" ? 7 * 50 : 30 * 50)}",
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Manage Payment'),
                              ),
                            )
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
    // CacheStorageService().getAuthUser().then((value) => {
    //       _selectedConsumptionType = value.consumptionType,
    //       _quantityController.text = value.quantity,
    //       _selectedDeliveryType = value.deliveryType,
    //     });
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
