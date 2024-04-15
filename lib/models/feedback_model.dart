class FeedbackModel {
  String feedbackId;
  String createdById;
  String comment;
  DateTime date;

  FeedbackModel({
    required this.feedbackId,
    required this.createdById,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'feedbackId': feedbackId,
      'createdById': createdById,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedbackId: json['feedbackId'],
      createdById: json['createdById'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }
}