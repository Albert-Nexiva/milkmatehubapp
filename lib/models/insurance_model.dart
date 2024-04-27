class InsuranceModel {
  String uid;
  String supplierId;
  String name;
  String address;
  String numCowsInsured;
  String numCowsAffected;
  String dateOfIncident;
  String causeOfDeath;
  String descriptionOfIncident;
  String typeOfCoverageRequested;
  String status;

  InsuranceModel({
    required this.uid,
    required this.supplierId,
    required this.name,
    required this.address,
    required this.numCowsInsured,
    required this.numCowsAffected,
    required this.dateOfIncident,
    required this.causeOfDeath,
    required this.descriptionOfIncident,
    required this.typeOfCoverageRequested,
    this.status = 'Pending',
  });

  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    return InsuranceModel(
      uid: json['uid'] ?? "",
      supplierId: json['supplierId'] ?? '',
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      numCowsInsured: json['numCowsInsured'] ?? "",
      numCowsAffected: json['numCowsAffected'] ?? "",
      dateOfIncident: json['dateOfIncident'] ?? "",
      causeOfDeath: json['causeOfDeath'] ?? "",
      descriptionOfIncident: json['descriptionOfIncident'] ?? '',
      typeOfCoverageRequested: json['typeOfCoverageRequested'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'supplierId': supplierId,
      'name': name,
      'address': address,
      'numCowsInsured': numCowsInsured,
      'numCowsAffected': numCowsAffected,
      'dateOfIncident': dateOfIncident,
      'causeOfDeath': causeOfDeath,
      'descriptionOfIncident': descriptionOfIncident,
      'typeOfCoverageRequested': typeOfCoverageRequested,
      'status': status,
    };
  }
}
