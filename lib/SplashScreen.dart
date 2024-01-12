import 'package:flutter/material.dart';
import 'package:thirukural/bouttomnavigationbar.dart';
import 'package:video_player/video_player.dart';

import 'newpage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/Video.mp4');
    try {
      await _controller.initialize();
      _controller.play();
      _controller.setLooping(true); // Set to true if you want the video to loop

      // Add a delay to navigate to the next page after 4 seconds
      Future.delayed(Duration(seconds: 4), () {
        // Navigate to the next page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your next page
        );
      });
    } catch (error) {
      print('Error initializing video: $error');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          VideoPlayer(_controller),
        ],
      ),
    );
  }
}
