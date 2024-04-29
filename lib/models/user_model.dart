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
    this.type = "user",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      city: json['city'],
      consumptionType: json['consumptionType'],
      quantity: json['quantity'],
      deliveryType: json['deliveryType'],
      email: json['email'],
      uid: json['uid'],
      type: json['type'] ?? 'user',
    );
  }

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
    };
  }
}
