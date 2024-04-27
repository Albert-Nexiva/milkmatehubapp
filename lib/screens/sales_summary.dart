import 'package:flutter/material.dart';
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/models/production_record_model.dart';
import 'package:milkmatehub/screens/dashboard_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesSummary extends StatefulWidget {
  const SalesSummary({super.key});

  @override
  State<SalesSummary> createState() => _SalesSummaryState();
}

class SalesData {
  final String month;

  final double sales;
  SalesData(this.month, this.sales);
}

class _SalesSummaryState extends State<SalesSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Summary'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: FirestoreDB().getProductionRecords(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final items = snapshot.data;
                if (items!.isNotEmpty) {
                  final data =
                      ProductionRecordModel.calculateMonthlySales(items);
                  return Column(
                    children: [
                      SfCartesianChart(
                        primaryXAxis: const CategoryAxis(),
                        // Chart title
                        title: const ChartTitle(text: 'Summary'),
                        // Enable legend
                        legend: const Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries<SalesData, String>>[
                          LineSeries<SalesData, String>(
                            dataSource: data,
                            xValueMapper: (SalesData sales, _) => sales.month,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            name: 'Sales',
                            // Enable data label
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 100,
                        width: 1000,
                        child: buildGridItem(
                          icon: Icons.monetization_on,
                          label:
                              "Total production: ${items.fold<double>(0, (sum, record) => sum + double.parse(record.liter))} Liters",
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 1000,
                        child: buildGridItem(
                          icon: Icons.monetization_on,
                          label:
                              "Total Amount : ${ProductionRecordModel.getTotalGrossPrice(items).toStringAsFixed(2)}",
                          onTap: () {},
                        ),
                      ),
                    ],
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
        ],
      ),

      //  Column(
      //   children: [
      //     //Initialize the chart widget
      //        const SizedBox(
      //       height: 50,
      //     ),
      //     Column(
      //       children: [
      //         SizedBox(
      //           height: 100,
      //           width: 1000,
      //           child: buildGridItem(
      //             icon: Icons.sell,
      //             label: "Total Liters Sold : 425 L",
      //             onTap: () {},
      //           ),
      //         ),
      //
      //         SizedBox(
      //           height: 100,
      //           width: 1000,
      //           child: buildGridItem(
      //             icon: Icons.percent,
      //             label: "Average Litres Sold Per Month : 35.14 L",
      //             onTap: () {},
      //           ),
      //         ),
      //       ],
      //     )
      //   ],
      // ),
    );
  }
}
