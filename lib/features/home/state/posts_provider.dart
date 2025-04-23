import 'package:flutter/material.dart';
import 'package:posts_korn_ferry/features/home/domain/repositories/posts_repository.dart';
import '../../../../common/models/post_model.dart';

class PostsProvider extends ChangeNotifier {
  final PostsRepository _repository;
  static const int _pageSize = 30;
  String? _lastPostId;
  bool _hasMorePosts = true;
  static const likeOptions = [-1, 0, 1];

  PostsProvider(this._repository) {
    _loadPosts();
  }

  List<Post> _posts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMorePosts => _hasMorePosts;
  String? get error => _error;

  int getPostLikeValue(String postId) {
    return _posts.firstWhere((post) => post.id == postId).liked;
  }

  void changeLocalPostValueLike(String postId, int like) {
    final index = _posts.indexWhere((post) => post.id == postId);

    if (index != -1) {
      final currentPostData = _posts[index];
      _posts[index] = currentPostData.copyWith(liked: like);
    }
  }

  Future<void> _loadPosts({bool loadMore = false}) async {
    try {
      if (loadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
      }
      notifyListeners();

      final newPosts = await _repository.getPosts(
        limit: _pageSize,
        lastPostId: _lastPostId,
      );

      if (newPosts.isEmpty) {
        _hasMorePosts = false;
      } else {
        if (loadMore) {
          _posts.addAll(newPosts);
        } else {
          _posts = newPosts;
        }
        _lastPostId = newPosts.last.id;
      }

      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshPosts() async {
    _lastPostId = null;
    _hasMorePosts = true;
    await _loadPosts();
  }

  Future<void> loadMorePosts() async {
    if (!_isLoadingMore && _hasMorePosts) {
      await _loadPosts(loadMore: true);
    }
  }

  Future<void> incrementLike(String postId) async {
    _error = null;
    final currentLike = getPostLikeValue(postId);
    int newLike = 1;

    // Already like, restore to 0
    if (currentLike == 1) {
      newLike = 0;
    }

    // Store original value and update UI immediately
    final originalLike = currentLike;

    if (!isAValidPostLikeData(postId, originalLike)) {
      return;
    }

    if (!isAValidLike(postId, newLike, originalLike)) {
      return;
    }

    changeLocalPostValueLike(postId, newLike);
    notifyListeners();

    try {
      await _repository.changeLike(postId, newLike);
    } catch (e) {
      // Restore original value on error
      changeLocalPostValueLike(postId, originalLike);
      _error = 'Failed to like post. Please try again.';
      notifyListeners();
    }
  }

  Future<void> decrementLike(String postId) async {
    _error = null;
    int newLike = -1;
    final currentLike = getPostLikeValue(postId);
    // Already dislike, restore to 0
    if (currentLike == -1) {
      newLike = 0;
    }

    // Store original value and update UI immediately
    final originalLike = currentLike;

    if (!isAValidPostLikeData(postId, originalLike)) {
      return;
    }

    if (!isAValidLike(postId, newLike, originalLike)) {
      return;
    }

    changeLocalPostValueLike(postId, newLike);
    notifyListeners();

    try {
      await _repository.changeLike(postId, newLike);
    } catch (e) {
      // Restore original value on error
      changeLocalPostValueLike(postId, originalLike);
      _error = 'Failed to dislike post. Please try again.';
      notifyListeners();
    }
  }

  bool isAValidPostLikeData(String postId, int originalLike) {
    // If the post has an invalid like value, reset the counter
    if (!likeOptions.contains(originalLike)) {
      changeLocalPostValueLike(postId, 0);
      _error = 'No valid Post data, try again';
      notifyListeners();
      return false;
    }
    return true;
  }

  bool isAValidLike(String postId, int newLike, int originalLike) {
    // If the like is not valid, show to the user
    if (!likeOptions.contains(newLike)) {
      changeLocalPostValueLike(postId, originalLike);
      _error = 'No valid Like, try again';
      notifyListeners();
      return false;
    }
    return true;
  }
}
