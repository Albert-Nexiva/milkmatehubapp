import 'package:flutter/material.dart';
import 'package:milkmatehub/admin_module/screens/edit_supplier_details_screen.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/models/supplier_model.dart';

class SupplierManagementScreen extends StatefulWidget {
  const SupplierManagementScreen({
    super.key,
  });

  @override
  State<SupplierManagementScreen> createState() =>
      _SupplierManagementScreenState();
}

class _SupplierManagementScreenState extends State<SupplierManagementScreen> {
  Future<List<SupplierModel>>? futureMethod;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers Records'),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: FutureBuilder(
        future: futureMethod,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final items = snapshot.data;
            if (items!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final record = items[index];
                    final Color color = generateRandomColor();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        surfaceTintColor: color,
                        color: color.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 52, 33, 33),
                                width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      record.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color),
                                    ),
                                    Text(
                                      record.phoneNumber,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Address: ${record.address}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'City: ${record.city}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Number of Cows: ${record.numberOfCows}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Experience Years: ${record.experienceYears}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Bank: ${record.bank.bankName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Insurance Coverage: ${record.insuranceCoverage}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Email: ${record.email}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirmation'),
                                            content: const Text(
                                                'Are you sure you want to delete this supplier?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  FirestoreDB().deleteSupplier(
                                                      record.uid);
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Yes'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('No'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditSupplierDetailsScreen(
                                                      supplierModel: record)));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Text('No records found'),
                ),
              );
            }
          } else {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: const CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    futureMethod = FirestoreDB().getAllSuppliers();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SupplierManagementScreen oldWidget) {
    futureMethod = FirestoreDB().getAllSuppliers();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    futureMethod = FirestoreDB().getAllSuppliers();
    super.initState();
  }
}
