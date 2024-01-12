import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class YourDataProvider with ChangeNotifier {
  List<Kural> _dataList = [];
  int _currentPage = 1; // Assuming you start with page 1
  bool _loadingMore = false;

  List<Kural> get dataList => _dataList;
  bool get loadingMore => _loadingMore;

  Future<void> fetchData() async {
    _currentPage = 1; // Reset page when fetching initial data
    await _loadData();
  }

  Future<void> loadMoreData() async {
    if (_loadingMore) {
      return;
    }

    _currentPage++;
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      _loadingMore = true;
      final apiUrl =
          'https://raw.githubusercontent.com/sudharsanvishnu/Thirukural/gh-pages/kural.json?page=$_currentPage';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> kuralList = json.decode(response.body)['kural'];
        final List<Kural> newDataList =
        kuralList.map((data) => Kural.fromJson(data)).toList();

        if (_currentPage == 1) {
          _dataList = newDataList; // Initial data
        } else {
          _dataList.addAll(newDataList); // Append more data
        }
      } else {
        print('Failed to load data');
        // Handle the error if needed
      }
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }
}
