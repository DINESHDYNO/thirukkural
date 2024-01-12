import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ShimmerEffect(),
      ),
    );
  }
}

class ShimmerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: 120,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 13,
                  width: 100,
                  color: Colors.black.withOpacity(0.04),
                ),
                SizedBox(height: 5),
                Container(
                  height: 13,
                  width: 140,
                  color: Colors.black.withOpacity(0.04),
                ),
                SizedBox(height: 5),
                Container(
                  height: 13,
                  width: 190,
                  color: Colors.black.withOpacity(0.04),
                ),
                SizedBox(height: 5),
                Container(
                  height: 13,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.04),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 13,
                        color: Colors.black.withOpacity(0.04),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 15,
                        color: Colors.black.withOpacity(0.04),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
