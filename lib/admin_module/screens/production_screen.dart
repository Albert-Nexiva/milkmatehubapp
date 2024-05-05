import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';

class ProductionsScreen extends StatelessWidget {
  const ProductionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Records'),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: FutureBuilder(
        future: FirestoreDB().getAllProductionRecords(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final items = snapshot.data;
            if (items!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: generateRandomColor().withOpacity(0.8),
                        border:
                            Border.all(color: generateRandomColor(), width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Total production: ${items.fold<double>(0, (sum, record) => sum + double.parse(record.liter))} Liters",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final record = items[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading:
                                    const Icon(Icons.poll_rounded, size: 38),
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Supplier: ${record.supplierName}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        // Text(
                                        //   'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(record.date))}',
                                        //   style: const TextStyle(
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                      ],
                                    ),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
}
