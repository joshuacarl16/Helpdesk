import 'package:uuid/uuid.dart';

// class Topic {
//   final String topicId;
//   String categoryName;
//   String userId;
//   String topicName;
//   bool helpStatus;
//   String content;
//   DateTime dateCreated;
//   int numberOfComments;

//   Topic({
//     required this.categoryName,
//     required this.userId,
//     required this.topicName,
//     this.content = '',
//     this.helpStatus = false,
//     this.numberOfComments = 0,
//     required this.dateCreated,
//   }) : topicId = const Uuid().v4();

//   @override
//   bool operator ==(covariant Topic other) => topicId == other.topicId;

//   @override
//   int get hashCode => topicId.hashCode;
// }

class Topic {
  final String categoryName;
  final String userId;
  final String topicName;
  late final bool helpStatus;
  final String content;
  final DateTime dateCreated;
  final int? numberOfComments;

  Topic({
    required this.topicName,
    required this.content,
    required this.categoryName,
    required this.userId,
    this.helpStatus = false,
    required this.dateCreated,
    required this.numberOfComments,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'topicName': topicName,
      'userId': userId,
      'content': content,
      'dateCreated': dateCreated.toString(),
      'numberOfComments': numberOfComments,
    };
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      categoryName: json['categoryName'] ?? 'N/A',
      userId: json['userId'] ?? 'N/A',
      helpStatus: json['helpStatus'] ?? false,
      dateCreated: json['dateCreated'] != null
          ? DateTime.parse(json['dateCreated'])
          : DateTime.now(),
      numberOfComments: json['numberOfComments'] ?? 0,
      topicName: json['topicName'] ?? 'N/A',
      content: json['content'] ?? 'N/A',
    );
  }
}
