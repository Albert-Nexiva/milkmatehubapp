import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/screens/home_screen.dart';

class SubCardDetailsScreen extends HookWidget {
  const SubCardDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: false,
                      cardNumber: cardNumber.value,
                      cvvCode: cvvCode.value,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName.value,
                      expiryDate: expiryDate.value,
                      inputConfiguration: const InputConfiguration(
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: InputDecoration(
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          labelText: 'Card Holder',
                        ),
                      ),
                      onCreditCardModelChange:
                          (CreditCardModel creditCardModel) {
                        cardNumber.value = creditCardModel.cardNumber;
                        expiryDate.value = creditCardModel.expiryDate;
                        cardHolderName.value = creditCardModel.cardHolderName;
                        cvvCode.value = creditCardModel.cvvCode;
                        isCvvFocused.value = creditCardModel.isCvvFocused;
                      },
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

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Payment Successful'),
                                      ),
                                    );
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
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
