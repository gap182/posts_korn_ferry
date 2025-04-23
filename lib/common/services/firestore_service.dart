import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a reference to a collection
  static CollectionReference getCollection(String collectionName) {
    return _firestore.collection(collectionName);
  }

  // Add a document to a collection
  static Future<DocumentReference> addDocument(
    String collectionName,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collectionName).add(data);
  }

  // Get a document by ID
  static Future<DocumentSnapshot> getDocument(
    String collectionName,
    String documentId,
  ) {
    return _firestore.collection(collectionName).doc(documentId).get();
  }

  // Update a document
  static Future<void> updateDocument(
    String collectionName,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collectionName).doc(documentId).update(data);
  }

  // Delete a document
  static Future<void> deleteDocument(String collectionName, String documentId) {
    return _firestore.collection(collectionName).doc(documentId).delete();
  }

  // Get all documents from a collection
  static Stream<QuerySnapshot> getCollectionStream(String collectionName) {
    return _firestore.collection(collectionName).snapshots();
  }

  // Query documents with conditions
  static Stream<QuerySnapshot> queryCollection(
    String collectionName, {
    String? field,
    dynamic isEqualTo,
    dynamic isGreaterThan,
    dynamic isLessThan,
    int? limit,
  }) {
    Query query = _firestore.collection(collectionName);

    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    if (field != null && isGreaterThan != null) {
      query = query.where(field, isGreaterThan: isGreaterThan);
    }
    if (field != null && isLessThan != null) {
      query = query.where(field, isLessThan: isLessThan);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
  }
}
