import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'ProviderAPI.dart';
import 'model.dart';
final pageBucket=PageStorageBucket();
class KuralScreen extends StatefulWidget {
  @override
  State<KuralScreen> createState() => _KuralScreenState();
}

class _KuralScreenState extends State<KuralScreen> {
  final scrollController = ScrollController();
  bool loadingMore = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);// Load scroll position during initState
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<YourDataProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // Handle add button press
            },
            icon: Icon(Icons.add),
          )
        ],
        title: Text('Thirukural Data'),
      ),
      body: FutureBuilder(
        future: dataProvider.fetchData(),
        builder: (context, snapshot) {
       /*   if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else*/ if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: PageStorage(
                bucket: pageBucket,
                child: ListView.separated(
                  key: PageStorageKey<String>('pageOne'),
                  controller: scrollController,
                  itemCount: dataProvider.dataList.length + (loadingMore ? 1 : 0),
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    if (index < dataProvider.dataList.length) {
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
                                      SizedBox(height: 5)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else if (loadingMore) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container(); // Return an empty container for the loading indicator
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (!loadingMore) {
        setState(() {
          loadingMore = true;
        });
        await context.read<YourDataProvider>().loadMoreData();
        setState(() {
          loadingMore = false;
        });
      }
    }
  }

}
