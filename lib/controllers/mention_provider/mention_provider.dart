import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:provider/provider.dart';

class MentionProvider extends ChangeNotifier {
  final List<String> matchingUserIds = [];
  List<UserModelFriendandFollow> filteredUsers = [];
  bool isShowingSuggestions = false;

  initProvider() {
    matchingUserIds.clear();
    filteredUsers.clear();
    isShowingSuggestions = false;
    notifyListeners();
  }

  void onTextChanged(context, TextEditingController controller) {
    var text = controller.text;
    int cursorPos = controller.selection.baseOffset;
    final getFriendsProvider =
        Provider.of<FriendFollower>(context, listen: false);

    // Extract the text up to the current cursor position
    String textBeforeCursor = text.substring(0, cursorPos);

    // Find the position of the last '@' character before the cursor
    int atSignIndex = textBeforeCursor.lastIndexOf('@');

    if (atSignIndex != -1) {
      // If '@' is found, extract the substring from '@' to the cursor position as the query
      String query = text.substring(atSignIndex + 1, cursorPos).trim();

      isShowingSuggestions = true; // Show suggestions

      // Filter users based on whether their username or full name starts with the query
      filteredUsers = getFriendsProvider.follower.where((user) {
        var usernameLower = user.username!.toLowerCase();
        var fullNameLower =
            "${user.firstName!} ${user.lastName!}".toLowerCase();
        return usernameLower.startsWith(query.toLowerCase()) ||
            fullNameLower.startsWith(query.toLowerCase());
      }).toList();
    } else {
      // If no '@' found or the section following '@' contains spaces (implied functionality not shown here)

      isShowingSuggestions = false; // Hide suggestions
    }

    checkCommentForUserMentions(controller.text, context);

    notifyListeners();
  }

  void checkCommentForUserMentions(String commentText, BuildContext context) {
    final provider = Provider.of<FriendFollower>(context, listen: false);
    log(commentText);

    // Regex to capture up to two words following '@'
    RegExp exp = RegExp(r'@(\w+)(?:\s+(\w+))?');
    Iterable<RegExpMatch> matches = exp.allMatches(commentText);

    // Clear existing matches
    matchingUserIds.clear();

    for (var match in matches) {
      String firstWord = match.group(1)!; // First word after '@'
      String? secondWord = match.group(2); // Second word after '@', if present
      String combinedWords =
          secondWord != null ? "$firstWord $secondWord" : firstWord;

      // Check for matches in a more streamlined way
      bool matchFound = false;
      for (var user in provider.follower) {
        if (matchFound) break; // Exit loop if a match is found

        // Check for two-word match against full names
        if (secondWord != null) {
          String fullName = "${user.firstName!} ${user.lastName!}";
          if (fullName == combinedWords) {
            if (!matchingUserIds.contains(user.id)) {
              matchingUserIds.add(user.id!);
              matchFound = true;
            }
          }
        }

        // Check for single-word match against usernames or first names
        if (!matchFound) {
          if (user.username == firstWord || user.firstName == firstWord) {
            if (!matchingUserIds.contains(user.id)) {
              matchingUserIds.add(user.id!);
              matchFound = true;
            }
          }
        }
      }
    }
    log(matchingUserIds.toString());
    notifyListeners();
  }

  void onSelectMention(index, TextEditingController controller) {
    var text = controller.text;
    int cursorPos =
        controller.selection.baseOffset; // Get the current cursor position

    // Find the position of the last '@' before the cursor
    int atSignIndex = text.lastIndexOf('@', cursorPos - 1);
    if (atSignIndex == -1) {
      return; // If no '@' found, do nothing
    }

    // Prepare the new text: take everything before '@', add the mention, add a space, then everything after the cursor
    String newText =
        "${text.substring(0, atSignIndex + 1)}${filteredUsers[index].username} ${text.substring(cursorPos)}";

    // Update the controller with the new text
    controller.value = TextEditingValue(
      text: newText,
      // Position the cursor right after the inserted mention and the space
      selection: TextSelection.collapsed(
        offset: atSignIndex +
            1 +
            filteredUsers[index].username!.length +
            1, // +1 for the space
      ),
    );

    // Hide the suggestion list and update the state

    isShowingSuggestions = false;
    notifyListeners();
  }
}
