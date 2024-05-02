import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/user_model.dart';
import 'package:milkmatehub/screens/home_screen.dart';

class SubCardDetailsScreen extends HookWidget {
  const SubCardDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CacheStorageService cacheStorageService = CacheStorageService();
    final cardNumberController = useTextEditingController();
    final expiryDateController = useTextEditingController();
    final cardHolderNameController = useTextEditingController();
    final cvvCodeController = useTextEditingController();
    final cardNumber = useState('');
    final expiryDate = useState('');
    final cardHolderName = useState('');
    final cvvCode = useState('');
    final isCvvFocused = useState(false);

    final formKey = GlobalKey<FormState>();

    final isLoading = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CreditCardWidget(
                      cardNumber: cardNumber.value,
                      expiryDate: expiryDate.value,
                      cardHolderName: cardHolderName.value,
                      cvvCode: cvvCode.value,
                      showBackView: isCvvFocused.value,
                      onCreditCardWidgetChange: (CreditCardBrand brand) {
                        // Callback for anytime credit card brand is changed
                      },
                    ),
                    const Divider(),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: cardNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Card Number',
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please enter card number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: expiryDateController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry Date',
                              hintText: 'MM/YY',
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please enter expiry date';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: cardHolderNameController,
                            decoration: const InputDecoration(
                              labelText: 'Cardholder Name',
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please enter cardholder name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: cvvCodeController,
                            decoration: const InputDecoration(
                              labelText: 'CVV Code',
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please enter CVV code';
                              }
                              return null;
                            },
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  cardNumber.value = cardNumberController.text;
                                  expiryDate.value = expiryDateController.text;
                                  cardHolderName.value =
                                      cardHolderNameController.text;
                                  cvvCode.value = cvvCodeController.text;
                                }
                              },
                              child: const Text('Verify Card'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  isLoading.value = true;
                                  final UserModel user =
                                      await cacheStorageService.getAuthUser();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Payment Successful'),
                                      ),
                                    );
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          user: user,
                                        ),
                                      ),
                                      (route) => false,
                                    );
                                  }
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
                            child: const Text(
                              'Confirm Payment',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
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
