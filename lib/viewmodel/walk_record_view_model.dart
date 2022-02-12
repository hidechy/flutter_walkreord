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
  final List<Datum> walkRecordList = [];
  final scrollController = ScrollController();
  bool hasNext = true;

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

        for (var value in walk.data) {
          walkRecordList.add(value);
        }

        hasNext = walk.hasNext;

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

///
final holidayViewModelProvider = ChangeNotifierProvider((ref) {
  return HolidayViewModel()..initialize();
});

///
class HolidayViewModel extends ChangeNotifier {
  Map<String, dynamic> holidayList = {};

  Future<void> initialize() async {
    String url = "http://toyohide.work/BrainLog/api/getholiday";
    Map<String, String> headers = {'content-type': 'application/json'};
    Response response = await post(Uri.parse(url), headers: headers);
    Map HolidayOfAll = (response != null) ? jsonDecode(response.body) : null;
    if (HolidayOfAll != null) {
      for (var i = 0; i < HolidayOfAll['data'].length; i++) {
        holidayList[HolidayOfAll['data'][i]] = '';
      }
    }
  }
}
