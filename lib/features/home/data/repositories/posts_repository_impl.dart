import '../../domain/repositories/posts_repository.dart';

import '../datasources/posts_data_source.dart';
import '../../../../common/models/post_model.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsDataSource _dataSource;

  PostsRepositoryImpl(this._dataSource);

  @override
  Future<Post?> getPost(String postId) async {
    return _dataSource.getPost(postId);
  }

  @override
  Future<void> updatePost(Post post) async {
    await _dataSource.updatePost(post);
  }

  @override
  Future<List<Post>> getPosts({int? limit, String? lastPostId}) async {
    return _dataSource.getPosts(limit: limit, lastPostId: lastPostId);
  }

  @override
  Future<void> changeLike(String postId, int like) async {
    await _dataSource.changeLike(postId, like);
  }
}
