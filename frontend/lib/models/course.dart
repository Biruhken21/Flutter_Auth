class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  bool isSubscribed;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isSubscribed = false,
  });
}
