import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photo_comment.dart';
import 'package:lesson3/model/photo_memo.dart';

class FirestoreController {
  static Future<String> addPhotoMemo({required PhotoMemo photoMemo}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .add(photoMemo.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }

  static Future<void> updatePhotoMemoID({required String photoMemo}) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .doc(photoMemo)
        .update({"postId": photoMemo});

    // doc id auto-generated.
  }

  static Future<void> updatePhotoMemoCommentCount(
      {required String photoMemoDocId, required num totalCount}) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .doc(photoMemoDocId)
        .update({"commentCount": totalCount});

    // doc id auto-generated.
  }

  static Future<void> updatePhotoMemoLikesCount(
      {required String photoMemoDocId, required num totalCount}) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .doc(photoMemoDocId)
        .update({DocKeyPhotoMemo.likesCount.name: totalCount});

    // doc id auto-generated.
  }

  static Future<void> updatePhotoMemoDisLikesCount(
      {required String photoMemoDocId, required num totalCount}) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .doc(photoMemoDocId)
        .update({DocKeyPhotoMemo.dislikeCount.name: totalCount});

    // doc id auto-generated.
  }

  static Future<String> addCommentToPhotoMemo(
      {required PhotoComment photoComment}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.photoCommentCollection)
        .add(photoComment.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }

  static Future<void> updatePhotoMemoCommentID(
      {required String photoMemoCommentId}) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoCommentCollection)
        .doc(photoMemoCommentId)
        .update({"commentID": photoMemoCommentId});

    // doc id auto-generated.
  }

  static Future<List<PhotoMemo>> getPhotoMemoList({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .where(DocKeyPhotoMemo.createdBy.name, isEqualTo: email)
        .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<List<PhotoComment>> getPhotoMemoCommentList({
    required String phomemoId,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoCommentCollection)
        .where(DocKeyPhotoMemoComment.postID.name, isEqualTo: phomemoId)
        .orderBy(DocKeyPhotoMemoComment.createdAt.name, descending: true)
        .get();

    var result = <PhotoComment>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoComment.fromFirestoreDoc(document);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<void> deleteComment({
    required String docId,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoCommentCollection)
        .doc(docId)
        .delete();
  }

  static Future<void> updateComment(
      {required String docId, required String newComment}) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoCommentCollection)
        .doc(docId)
        .update({DocKeyPhotoMemoComment.commentText.name: newComment});
  }

  static Future<void> updatePhotoMemo({
    required String docId,
    required Map<String, dynamic> update,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .doc(docId)
        .update(update);
  }

  static Future<List<PhotoMemo>> searchImages({
    required String email,
    required List<String> searchLabel, // OR search
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .where(DocKeyPhotoMemo.createdBy.name, isEqualTo: email)
        .where(DocKeyPhotoMemo.imageLabels.name, arrayContainsAny: searchLabel)
        .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      var p = PhotoMemo.fromFirestoreDoc(
        doc: doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
      if (p != null) result.add(p);
    }
    return result;
  }

  static Future<void> deleteDoc({
    required String docId,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .doc(docId)
        .delete();
  }

  static Future<List<PhotoMemo>> getPhotoMemoListSharedWithMe({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .where(DocKeyPhotoMemo.sharedWith.name, arrayContains: email)
        .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }
}
