import 'dart:convert';
import 'dart:async';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OneDayOneThirukural extends StatefulWidget {
  const OneDayOneThirukural({Key? key}) : super(key: key);

  @override
  _OneDayOneThirukuralState createState() => _OneDayOneThirukuralState();
}

class _OneDayOneThirukuralState extends State<OneDayOneThirukural> {
  String apiUrl =
      'https://raw.githubusercontent.com/sudharsanvishnu/Thirukural/gh-pages/kural.json';

  List<dynamic> kuralList = [];
  DateTime currentDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
    startTimer();
  }

  Future<void> fetchData() async {
    var cacheKey = "API_Categories";

    try {
      // Check if the cache exists
      var isCacheExists =
      await APICacheManager().isAPICacheKeyExist(cacheKey);

      if (isCacheExists) {
        // If cache exists, load data from cache
        var cachedData = await APICacheManager().getCacheData(cacheKey);
        setState(() {
          kuralList = json.decode(cachedData.toString())['kural'];
        });
      } else {
        // If cache doesn't exist, make a network request
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          // Update state with data from the network
          setState(() {
            kuralList = json.decode(response.body)['kural'];
          });

          // Cache the data for future use
         /* await APICacheManager().addCacheData(
            cacheKey,
            response.body,
          );*/
        } else {
          throw Exception('Failed to load data. Status code: ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      print('Error: $e\n$stackTrace');
    }
  }

  void startTimer() {
    // Change the duration to a more reasonable interval (e.g., every hour)
    Timer.periodic(Duration(days: 1), (timer) {
      fetchData();
    });
  }


  @override
  Widget build(BuildContext context) {
    if (kuralList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    int currentHour = currentDateTime.day;
    int indexToShow = currentHour % kuralList.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thirukural Data'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Current Date: ${DateFormat('dd-MM-yyyy').format(currentDateTime)}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${kuralList[indexToShow]['Number']}.'),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${kuralList[indexToShow]['Line1']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${kuralList[indexToShow]['Line2']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
