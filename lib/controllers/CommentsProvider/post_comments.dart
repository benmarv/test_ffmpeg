import 'package:flutter/cupertino.dart';

class PostComments extends ChangeNotifier {
  List<Map<String, dynamic>> comments = [];

// Function to update post comments data
addPostCommentsData({index, postId}) {
  if (comments[index]['postId'] == postId) {
    comments[index]['totalComments'] =
        (int.parse(comments[index]['totalComments']) + 1).toString();
    notifyListeners();
  }
}

// Function to make the post comments list empty
makePostEmptyList() {
  comments = [];
  notifyListeners();
}

// Function to delete post comments data
deletePostCommentsData({index, postId}) {
  if (comments[index]['postId'] == postId) {
    comments[index]['totalComments'] =
        (int.parse(comments[index]['totalComments']) - 1).toString();
    notifyListeners();
  }

}

// Function to add post comments
addPostComment({postId, totalComments, index, addAtFirstIndex}) {
  switch (addAtFirstIndex) {
    case false:
      {
        comments.add({"postId": postId, "totalComments": totalComments});
        notifyListeners();
        break;
      }
    case true:
      {
        comments
            .insert(0, {"postId": postId, "totalComments": totalComments});
        notifyListeners();
        break;
      }
  }
}

}
