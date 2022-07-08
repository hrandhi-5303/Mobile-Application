import 'package:lesson3/model/photo_memo.dart';

class Constant {
  static const devMode = true;
  static const photoFileFolder = 'photo_files';
  static const photoMemoCollection = 'photomemo_collection';
  static const photoCommentCollection = 'photocomment_collection';
}

enum ArgKey {
  user,
  downloadURL,
  filename,
  photoMemoList,
  onePhotoMemo,
  photoMemoCommentList,
  onePhotoComment,
  sharePhotoMemoList
}
