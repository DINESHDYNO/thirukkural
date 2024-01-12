import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'ProviderAPI.dart';
import 'main.dart';
import 'model.dart';
import 'onedayonethirukural.dart';

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  String apiUrl =
      'https://raw.githubusercontent.com/sudharsanvishnu/Thirukural/gh-pages/kural.json';
  List<dynamic> kuralList = [];
  static const String sharedPreferencesKey = "kuralList";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });
  }
 /* Future<void> fetchData() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("API_Categories");

    if (isCacheExist) {
      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          setState(() {
            kuralList = json.decode(response.body)['kural'];
          });
        } else {
          throw Exception('Failed to load data');
        }
      } catch (e) {
        print('Error loading data from network: $e');
      }
    } else {
      try {
        var cacheData = await APICacheManager().getCacheData("API_Categories");

        if (cacheData != null && cacheData.syncData != null) {
          var decodedData = json.decode(cacheData.syncData);

          if (decodedData != null && decodedData is Map && decodedData.containsKey('kural')) {
            var kuralData = decodedData['kural'];

            if (kuralData is List) {
              setState(() {
                kuralList = kuralData;
              });
            } else {
              print('Error: Value of key "kural" is not a list.');
            }
          } else {
            print('Error: Key "kural" not found in cached data.');
          }
        } else {
          print('Error: Cache data or syncData is null.');
        }
      } catch (e) {
        print('Error loading data from cache: $e');
      }
    }
  }*/

  Future<void> fetchData() async {
    print('Fetching data...');
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('Data loaded successfully');
        if (mounted) {
          setState(() {
            kuralList = json.decode(response.body)['kural'];
            saveDataToSharedPreferences();
          });
        }
      } else {
        print('Failed to load data');
        // Handle the error if needed
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error if needed
      if (mounted) {
        loadDataFromSharedPreferences();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the topmost one
    if (ModalRoute.of(context)!.isCurrent) {
      fetchData();
    }
  }



  // Save data to SharedPreferences
  Future<void> saveDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String kuralListJson = json.encode(kuralList);
    await prefs.setString(sharedPreferencesKey, kuralListJson);
  }

  // Load data from SharedPreferences
  Future<void> loadDataFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? kuralListJson = prefs.getString(sharedPreferencesKey);

      if (kuralListJson != null) {
        setState(() {
          kuralList = json.decode(kuralListJson);
        });
      }
    } catch (e) {
      print('Error loading data from SharedPreferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<YourDataProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>OneDayOneThirukural()));
          }, icon: Icon(Icons.add))
        ],
        title: Text('Thirukural Data'),
      ),
      body: isLoading?getShimmerLoading():
      kuralList.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : FutureBuilder(
        future: dataProvider.fetchData(),
            builder:(context,snapshot){
              if(snapshot.hasError){
                return Center(child: Text('Error: ${snapshot.error}'));
              }else{
                return  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.separated(
                    itemCount: dataProvider.dataList.length,
                    separatorBuilder: (context,index)=>Divider(),
                    itemBuilder: (context, index) {
                      Kural kural = dataProvider.dataList[index];
                      return ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${kural.number}.'),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${kural.line1}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${kural.line2}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            }
          ),
    );
  }
}
Shimmer getShimmerLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10, // Set the desired number of shimmering items
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, // Set the desired width
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
                ),
              ),
              SizedBox(width: 10), // Adjust spacing as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getShimmerContainer(13, 150),
                  getShimmerContainer(13, 200),
                  getShimmerContainer(13, 250),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, // Set the desired width
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
                ),
              ),
              SizedBox(width: 10), // Adjust spacing as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getShimmerContainer(13, 150),
                  getShimmerContainer(13, 200),
                  getShimmerContainer(13, 250),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, // Set the desired width
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
                ),
              ),
              SizedBox(width: 10), // Adjust spacing as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getShimmerContainer(13, 150),
                  getShimmerContainer(13, 200),
                  getShimmerContainer(13, 250),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, // Set the desired width
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
                ),
              ),
              SizedBox(width: 10), // Adjust spacing as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getShimmerContainer(13, 150),
                  getShimmerContainer(13, 200),
                  getShimmerContainer(13, 250),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, // Set the desired width
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
                ),
              ),
              SizedBox(width: 10), // Adjust spacing as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getShimmerContainer(13, 150),
                  getShimmerContainer(13, 200),
                  getShimmerContainer(13, 250),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, // Set the desired width
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
                ),
              ),
              SizedBox(width: 10), // Adjust spacing as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getShimmerContainer(13, 150),
                  getShimmerContainer(13, 200),
                  getShimmerContainer(13, 250),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, // Set the desired width
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
                ),
              ),
              SizedBox(width: 10), // Adjust spacing as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getShimmerContainer(13, 150),
                  getShimmerContainer(13, 200),
                  getShimmerContainer(13, 250),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, // Set the desired width
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
                ),
              ),
              SizedBox(width: 10), // Adjust spacing as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getShimmerContainer(13, 150),
                  getShimmerContainer(13, 200),
                  getShimmerContainer(13, 250),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget getShimmerContainer(double height, double width) {
  return Container(
    width: width,
    child: Container(
      height: height,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade500)],
      ),
    ),
  );
}







/*
class NewsCardSkelton extends StatelessWidget {
  double defaultPadding = 16.0;
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Skeleton(height: 120, width: 120),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Skeleton(width: 80),
              const SizedBox(height: defaultPadding / 2),
              const Skeleton(),
              const SizedBox(height: defaultPadding / 2),
              const Skeleton(),
              const SizedBox(height: defaultPadding / 2),
              Row(
                children: const [
                  Expanded(
                    child: Skeleton(),
                  ),
                  SizedBox(width: defaultPadding),
                  Expanded(
                    child: Skeleton(),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
class Skeleton extends StatelessWidget {

  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding:  EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius:
        BorderRadius.all(Radius.circular(defaultPadding))),
    );
  }
}
*/
