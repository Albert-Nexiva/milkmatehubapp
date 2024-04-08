import 'package:flutter/material.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/screens/apply_insurance_screen.dart';
import 'package:milkmatehub/screens/insurance_claims.dart';

Widget _buildGridItem(
    {required IconData icon,
    required String label,
    required VoidCallback onTap}) {
  final color = generateRandomColor();
  return InkWell(
    onTap: onTap,
    child: Card(
      color: color,
      surfaceTintColor: color,
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
  );
}

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Insurance Management'),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  childAspectRatio: 3,
                  children: [
                    _buildGridItem(
                      icon: Icons.receipt,
                      label: 'Apply for Insurance',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const InsuranceApplicationScreen()));
                      },
                    ),
                    _buildGridItem(
                      icon: Icons.receipt_long_rounded,
                      label: 'Insurance Claims',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const InsuranceClaimsScreen()));
                      },
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
