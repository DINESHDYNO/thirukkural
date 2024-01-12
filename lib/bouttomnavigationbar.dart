import 'package:flutter/material.dart';

import 'kural.dart';
import 'main.dart';
import 'newpage.dart';
import 'onedayonethirukural.dart';



class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myIndex = 2;
  Color color=Color(0xFF2ecc71);
  final List<Widget> tabs = [
    Intermediate(),
    NewPage(),
    KuralScreen(),
    OneDayOneThirukural(),
    OneDayOneThirukural()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f6fb),
      body: tabs[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        selectedItemColor: Color(0xFF2ed585),
        unselectedItemColor: Colors.black,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        showUnselectedLabels: true,
        iconSize: 26,
        backgroundColor: Color(0xFFf5f6fb),
        type: BottomNavigationBarType.fixed,
        items: [

          BottomNavigationBarItem(
            icon: Icon(myIndex == 0 ? Icons.play_circle :Icons.play_circle_outline, size: 25,
              color: myIndex == 0 ? color : Colors.black,),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(myIndex == 1 ?Icons.shopping_cart:Icons.shopping_cart_outlined, size: 25,
              color: myIndex == 1 ? color : Colors.black,),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(myIndex == 2 ?Icons.home:Icons.home_outlined, size: 25,
              color: myIndex == 2 ?color : Colors.black,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(myIndex == 3 ?Icons.library_books:Icons.library_books_outlined, size: 25,
              color: myIndex == 3 ? color : Colors.black,),
            label: 'Party Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(myIndex == 4 ?Icons.person:Icons.person_2_outlined, size: 25,
              color: myIndex == 4 ? color : Colors.black,),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}