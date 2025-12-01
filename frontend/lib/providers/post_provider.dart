import 'package:flutter/material.dart';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  final List<Post> _posts = [
    Post(
      id: '1',
      userId: 'user1',
      username: 'username',
      userRole: 'username.role',
      userProfileImageUrl: null,
      description: 'This is a sample post description.',
      imageUrl: 'https://picsum.photos/id/1018/800/600',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      commentCount: 3,
    ),
    Post(
      id: '2',
      userId: 'user2',
      username: 'johndoe',
      userRole: 'Developer',
      userProfileImageUrl: null,
      description: 'Looking for a co-founder for my new startup idea.',
      imageUrl: 'https://picsum.photos/id/1025/800/600',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      commentCount: 1,
    ),
    Post(
      id: '3',
      userId: 'user3',
      username: 'janedoe',
      userRole: 'Investor',
      userProfileImageUrl: null,
      description: 'Interested in investing in early-stage startups.',
      imageUrl: 'https://picsum.photos/id/1035/800/600',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      commentCount: 5,
    ),
  ];

  List<Post> get posts => [..._posts];

  void addPost(Post post) {
    _posts.add(post);
    notifyListeners();
  }

  void likePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedPost = Post(
        id: post.id,
        userId: post.userId,
        username: post.username,
        userRole: post.userRole,
        userProfileImageUrl: post.userProfileImageUrl,
        description: post.description,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.likes + 1,
        promises: post.promises,
        cofounderRequests: post.cofounderRequests,
        shares: post.shares,
        commentCount: post.commentCount,
      );
      _posts[postIndex] = updatedPost;
      notifyListeners();
    }
  }

  void promisePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedPost = Post(
        id: post.id,
        userId: post.userId,
        username: post.username,
        userRole: post.userRole,
        userProfileImageUrl: post.userProfileImageUrl,
        description: post.description,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.likes,
        promises: post.promises + 1,
        cofounderRequests: post.cofounderRequests,
        shares: post.shares,
        commentCount: post.commentCount,
      );
      _posts[postIndex] = updatedPost;
      notifyListeners();
    }
  }

  void cofounderRequest(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedPost = Post(
        id: post.id,
        userId: post.userId,
        username: post.username,
        userRole: post.userRole,
        userProfileImageUrl: post.userProfileImageUrl,
        description: post.description,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.likes,
        promises: post.promises,
        cofounderRequests: post.cofounderRequests + 1,
        shares: post.shares,
        commentCount: post.commentCount,
      );
      _posts[postIndex] = updatedPost;
      notifyListeners();
    }
  }

  void sharePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedPost = Post(
        id: post.id,
        userId: post.userId,
        username: post.username,
        userRole: post.userRole,
        userProfileImageUrl: post.userProfileImageUrl,
        description: post.description,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.likes,
        promises: post.promises,
        cofounderRequests: post.cofounderRequests,
        shares: post.shares + 1,
        commentCount: post.commentCount,
      );
      _posts[postIndex] = updatedPost;
      notifyListeners();
    }
  }
}
