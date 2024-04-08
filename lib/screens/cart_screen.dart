import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Cart',
              style: TextStyle(fontSize: 24),
            ),
            // Add your cart items here
            // Example: ListView.builder(itemBuilder: ...)
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle confirm button press
                // Example: Navigator.pushNamed(context, '/checkout');
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
