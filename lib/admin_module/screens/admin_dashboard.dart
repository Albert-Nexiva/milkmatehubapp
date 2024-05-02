import 'package:flutter/material.dart';
import 'package:milkmatehub/admin_module/screens/feed_management/feed_management_tab.dart';
import 'package:milkmatehub/admin_module/screens/insurance_management.dart';
import 'package:milkmatehub/admin_module/screens/production_screen.dart';
import 'package:milkmatehub/admin_module/screens/subscriptions_management.dart';
import 'package:milkmatehub/admin_module/screens/supplier_management_screen.dart';
import 'package:milkmatehub/screens/dashboard_screen.dart';
import 'package:milkmatehub/screens/login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Welcome, to Milkmate Hub!'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 1,
                    childAspectRatio: 2.5,
                    children: [
                      buildGridItem(
                        icon: Icons.list_alt_rounded,
                        label: 'Production Records',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProductionsScreen(),
                            ),
                          );
                        },
                      ),
                      buildGridItem(
                        icon: Icons.stacked_bar_chart,
                        label: 'Feed Management',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FeedManagementTabScreen(),
                            ),
                          );
                        },
                      ),
                      buildGridItem(
                        icon: Icons.supervised_user_circle,
                        label: 'Supplier Management',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SupplierManagementScreen(),
                            ),
                          );
                        },
                      ),
                      buildGridItem(
                        icon: Icons.local_hospital,
                        label: 'Insurance management',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const InsuranceManagement(),
                            ),
                          );
                        },
                      ),
                      buildGridItem(
                        icon: Icons.bar_chart,
                        label: 'Subscription management',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SubscriptionManagement(),
                            ),
                          );
                        },
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
