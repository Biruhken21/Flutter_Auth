class Post {
  final String id;
  final String userId;
  final String username;
  final String userRole;
  final String? userProfileImageUrl;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int promises;
  final int cofounderRequests;
  final int shares;
  final int commentCount;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userRole,
    this.userProfileImageUrl,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    this.likes = 0,
    this.promises = 0,
    this.cofounderRequests = 0,
    this.shares = 0,
    this.commentCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userRole: json['userRole'] as String,
      userProfileImageUrl: json['userProfileImageUrl'] as String?,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: json['likes'] as int? ?? 0,
      promises: json['promises'] as int? ?? 0,
      cofounderRequests: json['cofounderRequests'] as int? ?? 0,
      shares: json['shares'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userRole': userRole,
      'userProfileImageUrl': userProfileImageUrl,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'promises': promises,
      'cofounderRequests': cofounderRequests,
      'shares': shares,
      'commentCount': commentCount,
    };
  }
}
