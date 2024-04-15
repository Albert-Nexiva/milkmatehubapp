import 'package:flutter/material.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/supplier_model.dart';
import 'package:milkmatehub/screens/feed_order_screen.dart';
import 'package:milkmatehub/screens/insurance_screen.dart';
import 'package:milkmatehub/screens/production_records_tab.dart';
import 'package:milkmatehub/screens/user_modules/feedback.dart';
import 'package:milkmatehub/screens/user_modules/subscriptions.dart';

Widget buildGridItem(
    {required IconData icon,
    required String label,
    required VoidCallback onTap}) {
  final color = generateRandomColor();
  return InkWell(
    onTap: onTap,
    child: Card(
      color: color,
      surfaceTintColor: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ),
  );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: CacheStorageService().getAuthUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                              'Welcome ${snapshot.data?.name}, to Milkmate Hub!'),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount:
                                    (snapshot.data is SupplierModel) ? 2 : 1,
                                childAspectRatio:
                                    (snapshot.data is SupplierModel) ? 1 : 3,
                                children: (snapshot.data is SupplierModel)
                                    ? [
                                        buildGridItem(
                                          icon: Icons.list_alt_rounded,
                                          label: 'Production Records',
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ProductionRecordTabScreen()));
                                          },
                                        ),
                                        buildGridItem(
                                          icon: Icons.calendar_month,
                                          label: 'Monthly Summary',
                                          onTap: () {
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         const ProductionRecordTabScreen()));
                                          },
                                        ),
                                        buildGridItem(
                                          icon: Icons.local_hospital,
                                          label: 'Insurance Management',
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const InsuranceScreen()));
                                          },
                                        ),
                                        buildGridItem(
                                          icon: Icons.stacked_bar_chart,
                                          label: 'Feed Purchase',
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const FeedOrderScreen()));
                                          },
                                        ),
                                      ]
                                    : [
                                        buildGridItem(
                                          icon: Icons.shopping_bag,
                                          label: 'Subscriptions',
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Subscriptions()));
                                          },
                                        ),
                                        buildGridItem(
                                          icon: Icons.feedback,
                                          label: 'Feedback',
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const FeedbackScreen()));
                                          },
                                        ),
                                        buildGridItem(
                                          icon: Icons.payment,
                                          label: 'Payments',
                                          onTap: () {
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         const ProductionRecordTabScreen()));
                                          },
                                        ),
                                      ]),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Text('Welcome to milkmatehub!'),
                          SizedBox(height: 16),
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
