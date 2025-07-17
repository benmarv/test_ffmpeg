import 'package:flutter/foundation.dart';

class EmojiStickerProvider with ChangeNotifier {
  // The private variable to store the selected image path.
  String _selectedImgPath = '';

  // Getter for accessing the selected image path.
  String get selectedImagePath => _selectedImgPath;

  // Method to set the selected image path and notify listeners.
  void setSelectedImagePath(String imgPath) {
    _selectedImgPath = imgPath;
    notifyListeners();
  }

  // Method to clear the selected image path and notify listeners.
  void makePathEmpty() {
    _selectedImgPath = '';
    notifyListeners();
  }
}
