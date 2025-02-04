import 'package:flutter/material.dart';
import 'package:notifye/intromodal/page1.dart';
import 'package:notifye/intromodal/page2.dart';
import 'package:notifye/intromodal/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 500, // Adjust height for smaller boxes
            child: PageView(
              controller: _controller,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Page1(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Page2(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Page3(),
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.deepPurple,
              dotColor: Colors.deepPurple.shade100,
              dotHeight: 15,
              dotWidth: 15,
              spacing: 8,
            ),
          ),
        ],
      ),
    );
  }
}
