import 'package:milkmatehub/screens/sales_summary.dart';

class ProductionRecordModel {
  String readingSlot;
  String id;
  String liter;
  String fat;
  String snf;
  String clr;
  String supplierId;
  String supplierName;
  String date;

  ProductionRecordModel({
    required this.readingSlot,
    required this.id,
    required this.liter,
    required this.fat,
    required this.snf,
    required this.clr,
    required this.supplierId,
    required this.supplierName,
    required this.date,
  });

  factory ProductionRecordModel.fromJson(Map<String, dynamic> json) {
    return ProductionRecordModel(
      readingSlot: json['readingSlot'] ?? '',
      id: json['id'] ?? '',
      liter: json['liter'] ?? '0.0',
      fat: json['fat'] ?? '0.0',
      snf: json['snf'] ?? '0.0',
      clr: json['clr'] ?? '0.0',
      supplierId: json['supplierId'] ?? '',
      supplierName: json['supplierName'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'readingSlot': readingSlot,
      'id': id,
      'liter': liter,
      'fat': fat,
      'snf': snf,
      'clr': clr,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'date': date,
    };
  }
  static List<SalesData> calculateMonthlySales(List<ProductionRecordModel> records) {
    Map<String, double> monthlySales = {};

    // Calculate total sales for each month
    for (var record in records) {
      String month = record.date.substring(0, 7); // Extract month from date
      double sales = record.price;

      if (monthlySales.containsKey(month)) {
        monthlySales[month] = (monthlySales[month] ?? 0) + sales;
      } else {
        monthlySales[month] = sales;
      }
    }

    // Create SalesData objects for each month
    List<SalesData> monthlySalesData = monthlySales.entries.map((entry) {
      String month = entry.key;
      double sales = entry.value;
      return SalesData(month, sales);
    }).toList();

    return monthlySalesData;
  }

 static double getTotalGrossPrice(List<ProductionRecordModel> records) {
    double totalGrossPrice = 0;

    for (var record in records) {
      totalGrossPrice += record.price;
    }

    return totalGrossPrice;
  }
}



extension ProductionRecordModelExtension on ProductionRecordModel {
  double get price {
    double price = 50 * double.parse(liter) + (double.parse(clr) / 4) + double.parse(fat) + double.parse(snf);
    return price;
  }

  
}
