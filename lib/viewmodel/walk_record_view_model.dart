import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../model/walk.dart';

final walkRecordViewModelProvider = ChangeNotifierProvider((ref) {
  return WalkRecordViewModel()..initialize();
});

class WalkRecordViewModel extends ChangeNotifier {
  // screenに渡す値
  bool isInitSuccess = false;
  final List<Walk> walkRecordList = [];
  final scrollController = ScrollController();

  // screenに渡さない値
  bool _isFetching = false;
  int _pageNo = 0;

  ///
  Future<void> initialize() async {
    scrollController.addListener(_scrollListener);

    await _getWalkRecordByApi();

    isInitSuccess = true;

    notifyListeners();
  }

  ///
  void _scrollListener() {
    double positionRate =
        scrollController.offset / scrollController.position.maxScrollExtent;

    if (positionRate.floor() == 1 && !_isFetching) {
      _getWalkRecordByApi();
    }

    notifyListeners();
  }

  ///
  Future<void> _getWalkRecordByApi() async {
    _isFetching = true;

    try {
      ////////////////////////////////////////
      String url = "http://toyohide.work/BrainLog/api/getWalkRecord";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"size": "30", "page": _pageNo.toString()});
      Response response =
          await post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final walk = walkFromJson(response.body);

        for (var data in walk) {
          walkRecordList.add(data);
        }

        _pageNo++;

        notifyListeners();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
      ////////////////////////////////////////
    } catch (error) {
      print('Request failed error: $error.');
    } finally {
      _isFetching = false;
    }
  }

  ///
  @override
  void dispose() {
    scrollController.dispose();
    walkRecordList.clear();
    super.dispose();
  }
}
