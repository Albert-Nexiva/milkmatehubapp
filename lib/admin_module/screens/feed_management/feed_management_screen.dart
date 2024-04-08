import 'package:flutter/material.dart';
import 'package:milkmatehub/admin_module/screens/feed_management/edit_feed_screen.dart';
import 'package:milkmatehub/constants/methods.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';

class FeedManagementScreen extends StatefulWidget {
  const FeedManagementScreen({
    super.key,
  });

  @override
  State<FeedManagementScreen> createState() => _FeedManagementScreenState();
}

class _FeedManagementScreenState extends State<FeedManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
                        border: Border.all(color: Colors.grey, width: 1),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            record.description,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹ ${record.price}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              Text(
                                'Qty: ${record.weight}KG',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                        ]),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirmation'),
                                      content: const Text(
                                          'Are you sure you want to delete this supplier?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            FirestoreDB()
                                                .deleteFeed(record.feedId);
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditFeedScreen(feedModel: record)));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'Edit',
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
      ),
    );
  }
}
