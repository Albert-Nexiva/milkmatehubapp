import 'package:flutter/material.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';

class InsuranceClaimsScreen extends StatelessWidget {
  const InsuranceClaimsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance'),
      ),
      body: FutureBuilder(
        future: FirestoreDB().getInsuanceClaimList(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final items = snapshot.data;
            if (items!.isNotEmpty) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Applied Claims',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.receipt, size: 40),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      record.typeOfCoverageRequested == "basic"
                                          ? "Basic Coverage - ₹3000"
                                          : "Standard Coverage - ₹5000",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    'Date: ${record.dateOfIncident}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text('FAT: ${record.fat}'),
                                  // const SizedBox(width: 10),
                                  // Text('SNF: ${record.snf}'),
                                  // const SizedBox(width: 10),
                                  // Text('CLR: ${record.clr}'),
                                ],
                              ),
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
    );
  }
}
