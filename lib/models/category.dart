class Category {
  String categoryId;
  String categoryName;
  bool isClicked;
  String userId;
  Category({
    required this.categoryId,
    required this.categoryName,
    required this.userId,
    this.isClicked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'userId': userId,
    };
  }

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      userId: map['userId'],
    );
  }

  @override
  bool operator ==(covariant Category other) => categoryId == other.categoryId;

  @override
  int get hashCode => categoryId.hashCode;
}
