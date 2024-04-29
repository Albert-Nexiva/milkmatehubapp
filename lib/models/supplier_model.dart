class Bank {
  String accountNumber;
  String bankName;
  String branch;
  String ifsc;

  Bank({
    required this.accountNumber,
    required this.bankName,
    required this.branch,
    required this.ifsc,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'bankName': bankName,
      'branch': branch,
      'ifsc': ifsc,
    };
  }

  static Bank fromJson(jsonDecode) {
    return Bank(
      accountNumber: jsonDecode['accountNumber'] ?? "",
      bankName: jsonDecode['bankName'] ?? "",
      branch: jsonDecode['branch'] ?? "",
      ifsc: jsonDecode['ifsc'] ?? "",
    );
  }
}

class Cow {
  String id;
  String breed;
  int age;
  int productionCapacity;

  Cow({
    required this.id,
    required this.breed,
    required this.age,
    required this.productionCapacity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'breed': breed,
      'age': age,
      'productionCapacity': productionCapacity,
    };
  }

  static Cow fromJson(jsonDecode) {
    return Cow(
      id: jsonDecode['id'] ?? "",
      breed: jsonDecode['breed'] ?? "",
      age: jsonDecode['age'] ?? 0,
      productionCapacity: jsonDecode['productionCapacity'] ?? 0,
    );
  }
}

class SupplierModel {
  String name;
  String address;
  String phoneNumber;
  String city;
  int numberOfCows;
  List<Cow> cows;
  int experienceYears;
  Bank bank;
  String insuranceCoverage;
  String email;
  String uid;
  String type = "supplier";
  String? fcm;

  SupplierModel(
      {required this.name,
      required this.address,
      required this.phoneNumber,
      required this.city,
      required this.numberOfCows,
      required this.cows,
      required this.experienceYears,
      required this.bank,
      required this.insuranceCoverage,
      required this.email,
      required this.uid,
      required this.type,
      this.fcm});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'city': city,
      'numberOfCows': numberOfCows,
      'cows': cows.map((cow) => cow.toJson()).toList(),
      'experienceYears': experienceYears,
      'bank': bank.toJson(),
      'insuranceCoverage': insuranceCoverage,
      'email': email,
      'uid': uid,
      'type': type,
      'fcm': fcm
    };
  }

  static SupplierModel fromJson(jsonDecode) {
    return SupplierModel(
        name: jsonDecode['name'] ?? "",
        address: jsonDecode['address'] ?? "",
        phoneNumber: jsonDecode['phoneNumber'] ?? "",
        city: jsonDecode['city'] ?? "",
        numberOfCows: jsonDecode['numberOfCows'] ?? 0,
        cows: (jsonDecode['cows'] as List<dynamic>)
            .map((cow) => Cow.fromJson(cow))
            .toList(),
        experienceYears: jsonDecode['experienceYears'] ?? 0,
        bank: Bank.fromJson(jsonDecode['bank'] ?? {}),
        insuranceCoverage: jsonDecode['insuranceCoverage'] ?? "",
        email: jsonDecode['email'] ?? "",
        uid: jsonDecode['uid'] ?? "",
        type: jsonDecode['type'] ?? "supplier",
        fcm: jsonDecode['fcm']);
  }
}
