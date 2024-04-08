import 'package:flutter/material.dart';
import 'package:milkmatehub/admin_module/screens/feed_management/feed_management_screen.dart';

import 'add_feed_screen.dart';

class FeedManagementTabScreen extends StatefulWidget {
  const FeedManagementTabScreen({super.key});

  @override
  FeedManagementTabScreenState createState() => FeedManagementTabScreenState();
}

class FeedManagementTabScreenState extends State<FeedManagementTabScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Management'),
        bottom: _tabController == null
            ? null
            : TabBar(
                controller: _tabController!,
                tabs: const [
                  Tab(text: 'Feeds'),
                  Tab(text: 'Add'),
                ],
              ),
      ),
      body: _tabController == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController!,
              children: const [FeedManagementScreen(), AddFeedScreen()],
            ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Delay the initialization of _tabController by 2 seconds
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: 2, vsync: this);
        });
      }
    });
  }
}
