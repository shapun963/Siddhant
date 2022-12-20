import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:siddhanth/pages/home_page.dart';
import 'package:siddhanth/widgets/gradient_mask.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pop(context);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const HomePage(),
              duration: const Duration(milliseconds: 800)));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 5.0,sigmaY: 5.0),
          child: Image.asset(
            "assets/images/background.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        GradientMask(
          colors: const [Colors.red, Colors.orange],
          child: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TyperAnimatedText(
                "Siddhant",
                curve: Curves.easeInOut,
                speed: const Duration(milliseconds: 250),
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 75,
                    fontFamily: 'Hewina',
                    decoration: TextDecoration.none),
              )
            ],
          ),
        ),
      ],
    );
  }
}
