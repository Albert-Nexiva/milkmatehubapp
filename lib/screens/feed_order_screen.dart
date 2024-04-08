import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/screens/cart_screen.dart';

class FeedOrderScreen extends HookWidget {
  const FeedOrderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(0);
    final pageController = usePageController(initialPage: 0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Orders'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          selectedIndex.value = index;
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Feeds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
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
                future: FirestoreDB().getFeedList(),
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
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: imageFromBase64String(record.image),
                                ),
                                title: Column(children: [
                                  Text(record.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    record.description,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₹ ${record.price}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        'Qty: ${record.weight}KG',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ]),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        //   Navigator.of(context).push(MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           EditFeedScreen(feedModel: record)));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Text(
                                          'Buy Now',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
