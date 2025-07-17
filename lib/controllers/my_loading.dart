import 'package:flutter/cupertino.dart';

class MyLoading extends ChangeNotifier {
  // 'isForYou' related variables and methods
  bool _isForYouSelected = true;

  bool get isForYou {
    return _isForYouSelected;
  }

  setIsForYouSelected(bool isForYou) {
    _isForYouSelected = isForYou;
    notifyListeners();
  }

  // 'selectedItem' related variables and methods
  int _selectedItem = 0;

  int get getSelectedItem {
    return _selectedItem;
  }

  setSelectedItem(int selectedItem) {
    this._selectedItem = selectedItem;
    notifyListeners();
  }

  // 'profilePageIndex' related variables and methods
  int _profilePageIndex = 0;

  int get getProfilePageIndex {
    return _profilePageIndex;
  }

  setProfilePageIndex(int profilePageIndex) {
    this._profilePageIndex = profilePageIndex;
    notifyListeners();
  }

  // 'notificationPageIndex' related variables and methods
  int _notificationPageIndex = 0;

  int get getNotificationPageIndex {
    return _notificationPageIndex;
  }

  setNotificationPageIndex(int notificationPageIndex) {
    this._notificationPageIndex = notificationPageIndex;
    notifyListeners();
  }

  // 'searchPageIndex' related variables and methods
  int _searchPageIndex = 0;

  int get getSearchPageIndex {
    return _searchPageIndex;
  }

  setSearchPageIndex(int searchPageIndex) {
    this._searchPageIndex = searchPageIndex;
    notifyListeners();
  }

  // 'followerPageIndex' related variables and methods
  int _followerPageIndex = 0;

  int get getFollowerPageIndex {
    return _followerPageIndex;
  }

  setFollowerPageIndex(int searchPageIndex) {
    this._followerPageIndex = searchPageIndex;
    notifyListeners();
  }

  // 'musicPageIndex' related variables and methods
  int _musicPageIndex = 0;

  int get getMusicPageIndex {
    return _musicPageIndex;
  }

  setMusicPageIndex(int searchPageIndex) {
    this._musicPageIndex = searchPageIndex;
    notifyListeners();
  }


  // 'scrollProfileVideo' related variables and methods
  bool isScrollProfileVideo = false;

  bool get scrollProfileVideo {
    return isScrollProfileVideo;
  }

  setScrollProfileVideo(bool isScrollProfileVideo) {
    this.isScrollProfileVideo = isScrollProfileVideo;
    notifyListeners();
  }

  // 'searchText' related variables and methods
  String searchText = '';

  String get getSearchText {
    return searchText;
  }

  setSearchText(String searchText) {
    this.searchText = searchText;
    notifyListeners();
  }

  // 'musicSearchText' related variables and methods
  String musicSearchText = '';

  String get getMusicSearchText {
    return musicSearchText;
  }

  setMusicSearchText(String musicSearchText) {
    this.musicSearchText = musicSearchText;
    notifyListeners();
  }

  // 'isSearchMusic' related variables and methods
  bool isSearchMusic = false;

  bool get getIsSearchMusic {
    return isSearchMusic;
  }

  setIsSearchMusic(bool isSearchMusic) {
    this.isSearchMusic = isSearchMusic;
    notifyListeners();
  }

  // 'lastSelectSoundId' related variables and methods
  String lastSelectSoundId = '';

  String get getLastSelectSoundId {
    return lastSelectSoundId;
  }

  setLastSelectSoundId(String lastSelectSoundId) {
    this.lastSelectSoundId = lastSelectSoundId;
    notifyListeners();
  }

  // 'lastSelectSoundIsPlay' related variables and methods
  bool lastSelectSoundIsPlay = false;

  bool get getLastSelectSoundIsPlay {
    return lastSelectSoundIsPlay;
  }

  setLastSelectSoundIsPlay(bool lastSelectSoundIsPlay) {
    this.lastSelectSoundIsPlay = lastSelectSoundIsPlay;
    notifyListeners();
  }

  // 'isDownloadClick' related variables and methods
  bool isDownloadClick = false;

  bool get getIsDownloadClick {
    return isDownloadClick;
  }

  setIsDownloadClick(bool isDownloadClick) {
    this.isDownloadClick = isDownloadClick;
    notifyListeners();
  }

  // 'isUserBlockOrNot' related variables and methods
  bool isUserBlockOrNot = false;

  bool get getIsUserBlockOrNot {
    return isUserBlockOrNot;
  }

  setIsUserBlockOrNot(bool isDownloadClick) {
    this.isUserBlockOrNot = isDownloadClick;
    notifyListeners();
  }


}
