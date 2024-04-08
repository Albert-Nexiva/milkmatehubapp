import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/models/production_record_model.dart';

class ProductionRecordsScreen extends StatelessWidget {
  const ProductionRecordsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: FirestoreDB().getProductionRecords(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final items = snapshot.data;
                if (items!.isNotEmpty) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: generateRandomColor().withOpacity(0.8),
                            border: Border.all(
                                color: generateRandomColor(), width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total production: ${items.fold<double>(0, (sum, record) => sum + double.parse(record.liter))} Liters",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const Divider(),
                              Text(
                                "Total earnings: ₹ ${items.fold<double>(0, (sum, record) => sum + (record.price))}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final record = items[index];
                            return Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "₹ ${record.price}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Liter: ${record.liter}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(record.date))}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('FAT: ${record.fat}'),
                                    const SizedBox(width: 10),
                                    Text('SNF: ${record.snf}'),
                                    const SizedBox(width: 10),
                                    Text('CLR: ${record.clr}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
        ],
      ),
    );
  }
}
