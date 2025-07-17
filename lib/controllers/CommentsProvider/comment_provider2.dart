import 'package:link_on/controllers/CommentsProvider/post_comments.dart';

class PostComments2 extends PostComments {
 List<Map<String, dynamic>> otherComments = [];

// Function to add comments data
addCommentsData2({index, postId}) {
  if (otherComments[index]['postId'] == postId) {
    // Increment the total comments count and notify listeners
    otherComments[index]['totalComments'] =
        (int.parse(otherComments[index]['totalComments']) + 1).toString();
    notifyListeners();
  }
}

// Function to make the list empty
makeEmptyList2() {
  // Clear the otherComments list and notify listeners
  otherComments = [];
  notifyListeners();
}

// Function to delete comments data
deletCommentsData2({index, postId}) {
  if (otherComments[index]['postId'] == postId) {
    // Decrement the total comments count and notify listeners
    otherComments[index]['totalComments'] =
        (int.parse(otherComments[index]['totalComments']) - 1).toString();
    notifyListeners();
  }
}

// Function to add a comment
addComment2({postId, totalComments, index, addAtFirstIndex}) {
  switch (addAtFirstIndex) {
    case false:
      {
        // Add a new comment data at the end of the list
        otherComments.add({"postId": postId, "totalComments": totalComments});
        notifyListeners();
        break;
      }
    case true:
      {
        // Insert a new comment data at the beginning of the list
        otherComments
            .insert(0, {"postId": postId, "totalComments": totalComments});
        notifyListeners();
        break;
      }
  }
}

}
