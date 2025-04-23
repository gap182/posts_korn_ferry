import '../../../../common/repositories/post_repository.dart';
import '../../../../common/models/post_model.dart';
import 'posts_data_source.dart';

class PostsDataSourceImpl implements PostsDataSource {
  final PostRepository _postRepository;

  PostsDataSourceImpl(this._postRepository);

  @override
  Future<Post?> getPost(String postId) async {
    return _postRepository.getPost(postId);
  }

  @override
  Future<void> updatePost(Post post) async {
    await _postRepository.updatePost(post);
  }

  @override
  Future<List<Post>> getPosts({int? limit, String? lastPostId}) async {
    final snapshot = await _postRepository.getPosts(
      limit: limit,
      lastPostId: lastPostId,
    );
    return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
  }

  @override
  Future<void> changeLike(String postId, int like) async {
    await _postRepository.changeLike(postId, like);
  }
}
