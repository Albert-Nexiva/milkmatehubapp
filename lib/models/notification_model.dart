class NotificationModel {
  String title;
  String description;
  String? docId;
  NotificationModel(
      {required this.title, required this.description, this.docId});
  Map<String, dynamic> toJson() {
    return {'title': title, "description": description, 'docId': docId};
  }

  static fromJson(jsonDecode) {
    return NotificationModel(
      docId: jsonDecode['docId'] ?? "",
      title: jsonDecode['title'] ?? "",
      description: jsonDecode['description'] ?? "",
    );
  }
}
