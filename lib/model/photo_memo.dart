import 'package:lesson3/model/photo_comment.dart';

enum PhotoSource { camera, gallery }

enum DocKeyPhotoMemo {
  createdBy,
  title,
  memo,
  photoFilename,
  photoURL,
  timestamp,
  imageLabels,
  sharedWith,
  postId,
  commentCount,
  likesCount,
  dislikeCount,
}

class PhotoMemo {
  String? docId; // Firestore auto-generated id
  late String createdBy; // email = user id
  late String title;
  late String memo;
  late String photoFilename; //image/photo file at Cloud Storage
  late String photoURL; // URL of image
  DateTime? timestamp;
  late List<dynamic> imageLabels; // ML generated image labels
  late List<dynamic> sharedWith; // list of emails
  late String postId;
  late num commentCount;
  late num likesCount;
  late num dislikeCount;
  PhotoComment photoComment = PhotoComment();

  PhotoMemo(
      {this.docId,
      this.createdBy = '',
      this.title = '',
      this.memo = '',
      this.photoFilename = '',
      this.photoURL = '',
      this.timestamp,
      List<dynamic>? imageLabels,
      List<dynamic>? sharedWith,
      this.postId = '',
      this.likesCount = 0,
      this.dislikeCount = 0,
      this.commentCount = 0}) {
    this.imageLabels = imageLabels == null ? [] : [...imageLabels];
    this.sharedWith = sharedWith == null ? [] : [...sharedWith];
  }

  PhotoMemo.clone(PhotoMemo p) {
    docId = p.docId;
    createdBy = p.createdBy;
    title = p.title;
    memo = p.memo;
    photoFilename = p.photoFilename;
    photoURL = p.photoURL;
    timestamp = p.timestamp;
    sharedWith = [...p.sharedWith];
    imageLabels = [...p.imageLabels];
    commentCount = p.commentCount;
    likesCount = p.likesCount;
    dislikeCount = p.dislikeCount;
  }

//a.copyFrom(b) ==> a = b
  void copyFrom(PhotoMemo p) {
    docId = p.docId;
    createdBy = p.createdBy;
    title = p.title;
    memo = p.memo;
    photoFilename = p.photoFilename;
    photoURL = p.photoURL;
    timestamp = p.timestamp;
    sharedWith.clear();
    sharedWith.addAll(p.sharedWith);
    imageLabels.clear();
    imageLabels.addAll(p.imageLabels);
    commentCount = p.commentCount;
    likesCount = p.likesCount;
    dislikeCount = p.dislikeCount;
  }

  PhotoMemo.commentClone(PhotoMemo p) {
    commentCount = p.commentCount;
  }

  void likeCopy(num likes) {
    likesCount = likes;
  }

  void commentCopy(num comments) {
    commentCount = comments;
  }

  void dislikesCopy(num disLikes) {
    dislikeCount = disLikes;
  }

  // serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPhotoMemo.title.name: title,
      DocKeyPhotoMemo.createdBy.name: createdBy,
      DocKeyPhotoMemo.memo.name: memo,
      DocKeyPhotoMemo.photoFilename.name: photoFilename,
      DocKeyPhotoMemo.photoURL.name: photoURL,
      DocKeyPhotoMemo.timestamp.name: timestamp,
      DocKeyPhotoMemo.sharedWith.name: sharedWith,
      DocKeyPhotoMemo.imageLabels.name: imageLabels,
      DocKeyPhotoMemo.postId.name: postId,
      DocKeyPhotoMemo.commentCount.name: commentCount,
      DocKeyPhotoMemo.likesCount.name: likesCount,
      DocKeyPhotoMemo.dislikeCount.name: dislikeCount,
    };
  }

  //deserialization
  static PhotoMemo? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    return PhotoMemo(
        docId: docId,
        createdBy: doc[DocKeyPhotoMemo.createdBy.name] ??= 'N/A',
        title: doc[DocKeyPhotoMemo.title.name] ??= 'N/A',
        memo: doc[DocKeyPhotoMemo.memo.name] ??= 'N/A',
        photoFilename: doc[DocKeyPhotoMemo.photoFilename.name] ??= 'N/A',
        photoURL: doc[DocKeyPhotoMemo.photoURL.name] ??= 'N/A',
        sharedWith: doc[DocKeyPhotoMemo.sharedWith.name] ??= 'N/A',
        imageLabels: doc[DocKeyPhotoMemo.imageLabels.name] ??= 'N/A',
        timestamp: doc[DocKeyPhotoMemo.timestamp.name] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                doc[DocKeyPhotoMemo.timestamp.name].millisecondsSinceEpoch,
              )
            : DateTime.now(),
        commentCount: doc[DocKeyPhotoMemo.commentCount.name] ??= 0,
        likesCount: doc[DocKeyPhotoMemo.likesCount.name] ??= 0,
        dislikeCount: doc[DocKeyPhotoMemo.dislikeCount.name] ??= 0,
        postId: doc[DocKeyPhotoMemo.postId.name] ??= 'N/A');
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 3)
        ? 'Title too short'
        : null;
  }

  static String? validateMemo(String? value) {
    return (value == null || value.trim().length < 5) ? 'Memo too short' : null;
  }

  static String? validateSharedWith(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    List<String> emailList =
        value.trim().split(RegExp('(,|;| )+')).map((e) => e.trim()).toList();
    for (String e in emailList) {
      if (e.contains('@') && e.contains('.')) {
        continue;
      } else {
        return 'Invalid email address found: comma, semicolon, space separted list';
      }
    }
    return null;
  }
}
