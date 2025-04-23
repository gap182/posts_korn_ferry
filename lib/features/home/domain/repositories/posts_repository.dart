import '../../../../common/models/post_model.dart';

abstract class PostsRepository {
  Future<Post?> getPost(String postId);
  Future<void> updatePost(Post post);
  Future<List<Post>> getPosts({int? limit, String? lastPostId});
  Future<void> changeLike(String postId, int like);
}
