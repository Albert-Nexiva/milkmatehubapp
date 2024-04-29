class UserModel {
  String name;
  String address;
  String phoneNumber;
  String city;
  String consumptionType;
  String quantity;
  String deliveryType;
  String email;
  String uid;
  String type;
  String? fcm;
  UserModel({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.city,
    required this.consumptionType,
    required this.quantity,
    required this.deliveryType,
    required this.email,
    required this.uid,
    this.fcm,
    this.type = "user",
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'city': city,
      'consumptionType': consumptionType,
      'quantity': quantity,
      'deliveryType': deliveryType,
      'email': email,
      'uid': uid,
      'type': type,
      'fcm': fcm
    };
  }

  static fromJson(jsonDecode) {
    return UserModel(
        name: jsonDecode['name'] ?? "",
        address: jsonDecode['address'] ?? "",
        phoneNumber: jsonDecode['phoneNumber'] ?? "",
        city: jsonDecode['city'] ?? "",
        consumptionType: jsonDecode['consumptionType'] ?? "",
        quantity: jsonDecode['quantity'] ?? "",
        deliveryType: jsonDecode['deliveryType'] ?? "",
        email: jsonDecode['email'] ?? "",
        uid: jsonDecode['uid'] ?? "",
        type: jsonDecode['type'] ?? "user",
        fcm: jsonDecode['fcm'] ?? "");
  }
}
