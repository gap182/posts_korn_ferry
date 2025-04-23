import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a post by ID
  Future<Post?> getPost(String postId) async {
    final doc = await _firestore.collection('posts').doc(postId).get();
    if (!doc.exists) return null;
    return Post.fromDocument(doc);
  }

  // Update a post
  Future<void> updatePost(Post post) async {
    await _firestore.collection('posts').doc(post.id).update(post.toMap());
  }

  // Get posts with pagination
  Future<QuerySnapshot> getPosts({int? limit, String? lastPostId}) async {
    Query query = _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true);

    if (lastPostId != null) {
      final lastDoc =
          await _firestore.collection('posts').doc(lastPostId).get();
      query = query.startAfterDocument(lastDoc);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query.get();
  }

  // Increment like count
  Future<void> changeLike(String postId, int like) async {
    final post = await getPost(postId);
    if (post == null) return;

    final updatedPost = post.copyWith(liked: like);
    await updatePost(updatedPost);
  }
}
