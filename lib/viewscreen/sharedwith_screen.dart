// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photo_comment.dart';
import 'package:lesson3/model/photo_memo.dart';

import 'package:lesson3/viewscreen/comment_screen.dart';

import 'package:lesson3/viewscreen/view/webimage.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/sharedWithScreen';

  const SharedWithScreen(
      {required this.user, required this.photoMemoList, Key? key})
      : super(key: key);
  final List<PhotoMemo> photoMemoList;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _SharedWithScreenState();
  }
}

class _SharedWithScreenState extends State<SharedWithScreen> {
  late _Controller con;
  List<bool> editMode = [];

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    //editMode = List<bool>.filled(widget.photoMemoList.length, false);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared With: ${widget.user.email}'),
      ),
      body: con.photoMemoList.isEmpty
          ? Text(
              'No PhotoMemo shared with me',
              style: Theme.of(context).textTheme.headline6,
            )
          : ListView.builder(
              itemCount: con.photoMemoList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: WebImage(
                            url: con.photoMemoList[index].photoURL,
                            context: context,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ),
                        Text(
                          con.photoMemoList[index].title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(con.photoMemoList[index].memo),
                        Text(
                            'Created By: ${con.photoMemoList[index].createdBy}'),
                        Text(
                            'Created at: ${con.photoMemoList[index].timestamp}'),
                        Text(
                            'Shared With: ${con.photoMemoList[index].sharedWith}'),
                        Constant.devMode
                            ? Text(
                                'Image Labels: ${con.photoMemoList[index].imageLabels}')
                            : const SizedBox(
                                height: 1.0,
                              ),
                        IntrinsicWidth(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  con.postCommentScreen(index);
                                },
                                child: SizedBox(
                                  // color: Colors.amber,
                                  height: 30,
                                  width: 60,
                                  child: Stack(
                                    children: [
                                      const Align(
                                          alignment: Alignment.center,
                                          child:
                                              const Icon(Icons.comment_bank)),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          padding: const EdgeInsets.all(3),
                                          constraints: const BoxConstraints(
                                              maxHeight: 80),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Center(
                                            child: Text(
                                                "${con.photoMemoList[index].commentCount}"),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}

class _Controller {
  _SharedWithScreenState state;
  late List<PhotoMemo> photoMemoList;
  late PhotoMemo tempMemo;

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;

    for (int i = 0; i < state.widget.photoMemoList.length; i++) {
      tempMemo = PhotoMemo.clone(state.widget.photoMemoList[i]);
      print('${photoMemoList[i].commentCount}' '${photoMemoList[i].title}');
    }
  }

  void postCommentScreen(int index) async {
    List<PhotoComment> photoCommentList =
        await FirestoreController.getPhotoMemoCommentList(
            phomemoId: state.widget.photoMemoList[index].postId);
    print(state.widget.photoMemoList[index].postId);
    print(photoCommentList.length);

    await Navigator.pushNamed(
      state.context,
      CommentScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
        ArgKey.onePhotoMemo: state.widget.photoMemoList[index],
        ArgKey.photoMemoCommentList: photoCommentList
      },
    );
    state.render(() {});
  }

  // void cancel() {
  //   state.render(() => selected.clear());
  // }

}
