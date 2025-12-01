class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String role;
  final String? profileImageUrl;
  final String? bio;
  final List<String> skills;
  final List<String> interests;
  final List<String> followers;
  final List<String> following;
  final int followerCount;
  final int promiseCount;
  final int cofounderCount;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.role = 'user',
    this.profileImageUrl,
    this.bio,
    this.skills = const [],
    this.interests = const [],
    this.followers = const [],
    this.following = const [],
    this.followerCount = 0,
    this.promiseCount = 0,
    this.cofounderCount = 0,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      // Handle both '_id' and 'id' fields
      final id = json['_id']?.toString() ?? json['id']?.toString() ?? 'unknown_id';
      
      // Handle username - use email prefix if not available
      final email = json['email']?.toString() ?? '';
      final username = json['username']?.toString() ?? email.split('@').first;
      
      // Handle fullName - use email prefix if not available
      final fullName = json['fullName']?.toString() ?? 
                      json['name']?.toString() ?? 
                      email.split('@').first;
      
      return User(
        id: id,
        username: username,
        email: email,
        fullName: fullName,
        role: (json['role'] as String?)?.toLowerCase() ?? 'user',
        profileImageUrl: json['profileImageUrl']?.toString(),
        bio: json['bio']?.toString(),
        skills: List<String>.from(json['skills'] ?? []),
        interests: List<String>.from(json['interests'] ?? []),
        followers: List<String>.from(json['followers']?.map((f) => f.toString()) ?? []),
        following: List<String>.from(json['following']?.map((f) => f.toString()) ?? []),
        followerCount: (json['followerCount'] is int) ? json['followerCount'] : 
                      (int.tryParse(json['followerCount']?.toString() ?? '0') ?? 0),
        promiseCount: (json['promiseCount'] is int) ? json['promiseCount'] : 
                     (int.tryParse(json['promiseCount']?.toString() ?? '0') ?? 0),
        cofounderCount: (json['cofounderCount'] is int) ? json['cofounderCount'] : 
                       (int.tryParse(json['cofounderCount']?.toString() ?? '0') ?? 0),
        createdAt: json['createdAt'] is DateTime 
            ? json['createdAt'] 
            : (json['createdAt'] is String 
                ? DateTime.tryParse(json['createdAt']) 
                : null),
      );
    } catch (e) {
      print('Error parsing User from JSON: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'skills': skills,
      'interests': interests,
      'followers': followers,
      'following': following,
      'followerCount': followerCount,
      'promiseCount': promiseCount,
      'cofounderCount': cofounderCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
