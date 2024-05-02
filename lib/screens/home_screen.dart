import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/models/supplier_model.dart';
import 'package:milkmatehub/screens/dashboard_screen.dart';
import 'package:milkmatehub/screens/my_order_screen.dart';
import 'package:milkmatehub/screens/profile_screen.dart';

class HomeScreen extends HookWidget {
  final dynamic user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(user is SupplierModel ? 1 : 0);
    final pageController =
        usePageController(initialPage: user is SupplierModel ? 1 : 0);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        currentIndex: selectedIndex.value,
        onTap: (index) {
          selectedIndex.value = index;
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
          // Handle onTap for BottomNavigationBar
        },
        items: [
          if (user is SupplierModel)
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'My Orders',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: user is SupplierModel ? 3 : 2,
        controller: pageController,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              if (user is SupplierModel) {
                return const MyOrdersScreen();
              } else {
                return const DashboardScreen();
              }
            case 1:
              if (user is SupplierModel) {
                return const DashboardScreen();
              } else {
                return const ProfileScreen();
              }
            case 2:
              return const ProfileScreen();
            default:
              return const DashboardScreen();
          }
        },
      ),
    );
  }
}
