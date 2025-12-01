class WorkItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String category;
  final String status;
  final DateTime createdAt;

  WorkItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  factory WorkItem.fromJson(Map<String, dynamic> json) {
    return WorkItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
