import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_constants.dart';

class Post {
  final String id;
  final String author;
  final String content;
  final int liked;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.liked = 0,
    required this.createdAt,
  });

  // Convert Post to Map
  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.author: author,
      FirestoreConstants.content: content,
      FirestoreConstants.liked: liked,
      FirestoreConstants.timestamp: Timestamp.fromDate(createdAt),
    };
  }

  // Create Post from DocumentSnapshot
  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Post(
      id: doc.id,
      author: data[FirestoreConstants.author],
      content: data[FirestoreConstants.content],
      liked: data[FirestoreConstants.liked] ?? 0,
      createdAt: (data[FirestoreConstants.timestamp] as Timestamp).toDate(),
    );
  }

  // Create a copy of Post with updated fields
  Post copyWith({
    String? id,
    String? author,
    String? content,
    int? liked,
    DateTime? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      liked: liked ?? this.liked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
