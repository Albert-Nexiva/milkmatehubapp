import 'package:flutter/material.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/models/insurance_model.dart';

class InsuranceManagement extends StatefulWidget {
  const InsuranceManagement({
    super.key,
  });

  @override
  State<InsuranceManagement> createState() => _InsuranceManagementState();
}

class _InsuranceManagementState extends State<InsuranceManagement> {
  Future<List<InsuranceModel>>? futureMethod;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Management'),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: Stack(
        children: [
          FutureBuilder(
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
                                    color:
                                        const Color.fromARGB(255, 52, 33, 33),
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
                                          record.status,
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
                                    'Sum Insured: ${record.typeOfCoverageRequested}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Affected Cattles: ${record.numCowsAffected}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Insured Cattles: ${record.numCowsInsured}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          try {
                                            FirestoreDB()
                                                .rejectInsuranceClaim(
                                                    record.uid)
                                                .then((value) => setState(() {
                                                      isLoading = false;
                                                      futureMethod = FirestoreDB()
                                                          .getInsuranceClaims();
                                                    }));
                                          } on Exception catch (_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Failed to reject claim'),
                                              ),
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                            'Reject',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      items[index].status == 'approved'
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                try {
                                                  FirestoreDB()
                                                      .approveInsuranceClaim(
                                                          record.uid)
                                                      .then((value) =>
                                                          setState(() {
                                                            isLoading = false;
                                                            futureMethod =
                                                                FirestoreDB()
                                                                    .getInsuranceClaims();
                                                          }));
                                                } on Exception catch (_) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Failed to approve claim'),
                                                    ),
                                                  );
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: const Text(
                                                  'Approve',
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
  void didChangeDependencies() {
    futureMethod = FirestoreDB().getInsuranceClaims();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant InsuranceManagement oldWidget) {
    futureMethod = FirestoreDB().getInsuranceClaims();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    futureMethod = FirestoreDB().getInsuranceClaims();
    super.initState();
  }
}
