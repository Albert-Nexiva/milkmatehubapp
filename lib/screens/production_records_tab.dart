import 'package:flutter/material.dart';
import 'package:milkmatehub/screens/production_recorder_screen.dart';
import 'package:milkmatehub/screens/production_records_screen.dart';

class ProductionRecordTabScreen extends StatefulWidget {
  const ProductionRecordTabScreen({super.key});

  @override
  ProductionRecordTabScreenState createState() =>
      ProductionRecordTabScreenState();
}

class ProductionRecordTabScreenState extends State<ProductionRecordTabScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Records'),
        bottom: _tabController == null
            ? null
            : TabBar(
                controller: _tabController!,
                tabs: const [
                  Tab(text: 'Add Record'),
                  Tab(text: 'Records'),
                ],
              ),
      ),
      body: _tabController == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController!,
              children: const [
                ProductionRecorderScreen(),
                ProductionRecordsScreen()
              ],
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
