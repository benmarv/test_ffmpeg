import 'dart:async';
import 'package:flutter/material.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class VideosLikeProvider extends ChangeNotifier {
  List saveData = [];
  bool? isReactedValue;
  String? globallPostId;
  Timer? _timer;
  saveReactionData(value, {insertAt}) {
    saveData.add(
      value,
    );

    notifyListeners();
  }

  makeEmptyList() {
    saveData = [];
    notifyListeners();
  }

  setVideoiLikeProvider(value, {@required id, context, required index}) async {
    log("provider get value is id $id");
    int? i;
    if (globallPostId == null) {
      globallPostId = id;
      isReactedValue ??= saveData[index]["isReacted"];
      i = index;
      videoReactionProvider(value: value, index: index, i: i, id: id);
      await setValue("videoReactionValue", saveData[index]["isReacted"]);
      _timer = Timer(
        const Duration(seconds: 2),
        () async {
          switch (getBoolAsync('videoReactionValue')) {
            case false:
              {
                if (isReactedValue == true) {
                  await hitVideoLikeApi(id: id, value: value);
                  isReactedValue = null;
                  globallPostId = null;
                  await removeKey("videoReactionValue");
                }
                break;
              }
            case true:
              {
                if (isReactedValue == false) {
                  await hitVideoLikeApi(id: id, value: value);
                  isReactedValue = null;
                  globallPostId = null;
                  await removeKey("videoReactionValue");
                }
                break;
              }
          }
        },
      );
    } else {
      if (id != globallPostId) {
        await removeKey("videoReactionValue");
        isReactedValue ??= saveData[index]["isReacted"];
        isReactedValue = null;
        i = index;
        videoReactionProvider(value: value, index: index, i: i, id: id);
        await setValue("videoReactionValue", saveData[index]["isReacted"]);
        _timer = Timer(
          const Duration(seconds: 2),
          () async {
            switch (getBoolAsync('videoReactionValue')) {
              case false:
                {
                  if (isReactedValue == true) {
                    await hitVideoLikeApi(id: id, value: value);
                    isReactedValue = null;
                    globallPostId = null;
                    await removeKey("videoReactionValue");
                  }
                  break;
                }
              case true:
                {
                  if (isReactedValue == false) {
                    await hitVideoLikeApi(id: id, value: value);
                    isReactedValue = null;
                    globallPostId = null;
                    await removeKey("videoReactionValue");
                  }
                  break;
                }
            }
          },
        );
      } else {
        _timer?.cancel();
        isReactedValue ??= saveData[index]["isReacted"];
        i = index;
        videoReactionProvider(value: value, index: index, i: i, id: id);
        await setValue("videoReactionValue", saveData[index]["isReacted"]);
        _timer = Timer(
          const Duration(seconds: 2),
          () async {
            switch (getBoolAsync('videoReactionValue')) {
              case false:
                {
                  if (isReactedValue == true) {
                    await hitVideoLikeApi(id: id, value: value);
                    isReactedValue = null;
                    globallPostId = null;
                    await removeKey("videoReactionValue");
                  }
                  break;
                }
              case true:
                {
                  if (isReactedValue == false) {
                    await hitVideoLikeApi(id: id, value: value);
                    isReactedValue = null;
                    globallPostId = null;
                    await removeKey("videoReactionValue");
                  }
                  break;
                }
            }
          },
        );
      }
    }
  }

  videoReactionProvider(
      {@required value, @required index, @required i, @required id}) {
    List tempList = [];

    tempList.add({
      "count": saveData[index]["count"],
      "isReacted": saveData[index]["isReacted"],
    });

    if (saveData[i]["postId"] == id) {
      index = i;
      log("providr data ios ${saveData[i]["postId"]}");
    }

    switch (value) {
      case 2:
        {
          log("provider get value is $value");
          saveData[index]["isReacted"] = true;
          saveData[index]["count"] = saveData[index]["count"] + 1;
          notifyListeners();
          break;
        }
      default:
        {
          log("provider get value is $value");
          saveData[index]["isReacted"] = false;
          if (saveData[index]["count"] < 0) {
            return;
          } else {
            saveData[index]["count"] = saveData[index]["count"] - 1;
          }
          notifyListeners();
          break;
        }
    }
  }

  hitVideoLikeApi({@required id, @required value}) async {
    dynamic res = await apiClient.reactionsApi(postId: id, reactionType: value);
    if (res["code"] == '200') {
    } else {}
  }
}
