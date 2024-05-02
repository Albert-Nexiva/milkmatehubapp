import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/order_model.dart';
import 'package:milkmatehub/models/supplier_model.dart';
import 'package:milkmatehub/screens/card_details_screen.dart';
import 'package:milkmatehub/screens/dashboard_screen.dart';
import 'package:milkmatehub/screens/feed_order_screen.dart';
import 'package:milkmatehub/screens/home_screen.dart';
import 'package:provider/provider.dart';

class CardDetailsWidget extends HookWidget {
  const CardDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Card Number',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name on Card',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'CVV Code',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum PaymentMethod {
  debitCard,
  creditCard,
  cashOnDelivery,
}

class PaymentScreen extends HookWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CacheStorageService cacheStorageService = CacheStorageService();
    final isLoading = useState(false);
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: true);
    final items = cartProvider.items;
    final paymentType = useState<PaymentMethod>(PaymentMethod.cashOnDelivery);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cartProvider.items.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.items[index];
                          return ListTile(
                            leading: imageFromBase64String(item.image),
                            title: Text(item.name),
                            subtitle: Text('Price: ${item.price} Rs'),
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: Text(
                      'Total Item Price: ₹  ${cartProvider.getTotalPrice()}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: Text(
                      'Delivery Charges: ₹ 10',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.green,
                          ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.money),
                    title: Text(
                      'Grand Total: ₹ ${cartProvider.getTotalPrice() + 10}/-',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Payment Options:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListTile(
                    selectedColor: Colors.green,
                    selected: paymentType.value == PaymentMethod.debitCard,
                    leading: const Icon(Icons.credit_card),
                    title: const Text('Debit Card'),
                    onTap: () {
                      paymentType.value = PaymentMethod.debitCard;
                    },
                  ),
                  ListTile(
                    selectedColor: Colors.green,
                    selected: paymentType.value == PaymentMethod.creditCard,
                    leading: const Icon(Icons.credit_card),
                    title: const Text('Credit Card'),
                    onTap: () {
                      paymentType.value = PaymentMethod.creditCard;
                    },
                  ),
                  ListTile(
                    selectedColor: Colors.green,
                    selected: paymentType.value == PaymentMethod.cashOnDelivery,
                    leading: const Icon(Icons.money),
                    title: const Text('Cash on Delivery'),
                    onTap: () {
                      paymentType.value = PaymentMethod.cashOnDelivery;
                    },
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () async {
                            if (paymentType.value !=
                                PaymentMethod.cashOnDelivery) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CardDetailsScreen(),
                                ),
                              );
                            } else {
                              final SupplierModel user =
                                  await cacheStorageService.getAuthUser();
                              isLoading.value = true;
                              try {
                                await FirestoreDB()
                                    .placeOrder(
                                  OrderModel(
                                    orderId: generateRandomString(),
                                    supplierId: user.uid,
                                    orderDate: DateTime.now(),
                                    feeds: items,
                                    status: OrderStatus.pending,
                                  ),
                                )
                                    .then((value) {
                                  isLoading.value = false;
                                  cartProvider.clearCart();

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                           HomeScreen(
                                            user: user,
                                          ),
                                    ),
                                    (route) => false,
                                  );
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Order Placed Successfully'),
                                    ),
                                  );
                                });
                              } catch (e) {
                                if (context.mounted) {
                                  isLoading.value = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Order Failed!'),
                                    ),
                                  );
                                }
                                return;
                              }
                            }
                          },
                          child: Text(
                            paymentType.value != PaymentMethod.cashOnDelivery
                                ? 'Continue to Pay'
                                : 'Place Order',
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
              if (isLoading.value)
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
        ),
      ),
    );
  }
}
