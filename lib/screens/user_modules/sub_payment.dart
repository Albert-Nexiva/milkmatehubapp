import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/screens/dashboard_screen.dart';
import 'package:milkmatehub/screens/home_screen.dart';
import 'package:milkmatehub/screens/user_modules/sub_card_details.dart';

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

class SubPaymentScreen extends HookWidget {
  final String paymentTotal;
  const SubPaymentScreen({super.key, required this.paymentTotal});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

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
                      'Payment Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: Text(
                      'Total Payment Price: ₹  $paymentTotal',
                      style: Theme.of(context).textTheme.titleSmall,
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
                    title: const Text('Pay in Person'),
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
                                      const SubCardDetailsScreen(),
                                ),
                              );
                            } else {
                              isLoading.value = true;
                              try {
                                isLoading.value = false;

                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                           HomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Payment Successful'),
                                    ),
                                  );
                                }
                                // await FirestoreDB()
                                //     .placeOrder(
                                //   OrderModel(
                                //     orderId: generateRandomString(),
                                //     supplierId: user.uid,
                                //     orderDate: DateTime.now(),
                                //     feeds: items,
                                //     status: OrderStatus.pending,
                                //   ),
                                // )
                                //     .then((value) {

                                // });
                              } catch (e) {
                                if (context.mounted) {
                                  isLoading.value = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Payment Failed!'),
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
                                : 'Make payment',
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
