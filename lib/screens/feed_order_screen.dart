import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/models/feed_model.dart';
import 'package:milkmatehub/screens/cart_screen.dart';
import 'package:provider/provider.dart';

class CartProvider extends ChangeNotifier {
  List<FeedModel> items = [];

  void addToCart(FeedModel item) {
    items.add(item);
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in items) {
      totalPrice += item.price;
    }
    return totalPrice;
  }

  bool isInCart(FeedModel item) {
    return items.contains(item);
  }

  void removeFromCart(FeedModel item) {
    items.remove(item);
    notifyListeners();
  }
}

class FeedOrderScreen extends HookWidget {
  const FeedOrderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(0);
    final pageController = usePageController(initialPage: 0);

    final cartProvider = Provider.of<CartProvider>(
      context,
      listen: true,
    );
    Future<List<FeedModel>> future = useMemoized(() async {
      final items = await FirestoreDB().getFeedList();
      return items;
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            cartProvider.clearCart();
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Feed Orders'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          selectedIndex.value = index;
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Feeds',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.items.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Cart',
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: 3,
        controller: pageController,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return FutureBuilder(
                future: future,
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
                            return Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child:
                                            imageFromBase64String(record.image),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(record.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 10),
                                            Text(
                                              record.description,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "₹ ${record.price}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Qty: ${record.weight}KG',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: InkWell(
                                                onTap: () {
                                                  if (cartProvider
                                                      .isInCart(record)) {
                                                    cartProvider
                                                        .removeFromCart(record);
                                                  } else {
                                                    cartProvider
                                                        .addToCart(record);
                                                  }
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: cartProvider
                                                            .isInCart(record)
                                                        ? Colors.red
                                                        : Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    cartProvider
                                                            .isInCart(record)
                                                        ? 'Remove from cart'
                                                        : 'Add to cart',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ]),
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
              );
            case 1:
              return const CartScreen();

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
