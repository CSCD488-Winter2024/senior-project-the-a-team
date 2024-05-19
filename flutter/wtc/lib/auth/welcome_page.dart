import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wtc/intro_screens/intro_page3.dart';
import 'package:wtc/intro_screens/intro_page1.dart';
import 'package:wtc/intro_screens/intro_page2.dart';
import 'package:wtc/auth/getting_started.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key, required this.email, required this.uid});

  final String email;
  final String uid;

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  PageController _controller = PageController();

  bool _isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index){
              setState(() {
                _isLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                GestureDetector(
                  onTap: (){
                    _controller.jumpToPage(2);
                  },
                  child: const Text("Skip")
                ),

                SmoothPageIndicator(
                  controller: _controller, 
                  count: 3
                ),

                _isLastPage ?
                GestureDetector(
                   onTap: (){
                    Navigator.pushReplacement(
                      context, 
                      CupertinoPageRoute(builder: (context) => GettingStartedPage(email: widget.email, uid: widget.uid))
                    );
                  },
                  child: const Text("Done"),
                )
                :
                 GestureDetector(
                   onTap: (){
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 500), 
                      curve: Curves.easeIn
                    );
                  },
                  child: const Text("Next"),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}