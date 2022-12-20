import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:siddhanth/pages/about_devs.dart';
import 'package:siddhanth/pages/event_info_page.dart';
import 'package:siddhanth/pages/gallery_page.dart';
import 'package:siddhanth/pages/our_college.dart';
import 'package:siddhanth/widgets/gradient_mask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Image.asset(
                  "assets/images/background.png",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 300,
                    width: 300,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GradientMask(
                        colors: const [
                          Color.fromARGB(255, 217, 140, 15),
                          Color.fromARGB(255, 240, 51, 12)
                        ],
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText(
                              "Siddhant",
                              curve: Curves.easeInOut,
                              speed: const Duration(milliseconds: 450),
                              textStyle: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Hewina'),
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 8.0,
                        children: const <Widget>[
                          GridItem(
                            text: "Event\nInfo",
                            pageToOpen: EventInfoPage(),
                          ),
                          GridItem(
                            text: "Gallery",
                            pageToOpen: GalleryPage(),
                          ),
                          GridItem(
                            text: "Our\nCollege",
                            pageToOpen: OurCollegePage(),
                          ),
                          GridItem(
                              text: "About\nDevs",
                              pageToOpen: AboutDevsPage() //AboutDevsPage(),
                          ),
                        ],
                      ),
                    ),
                    //LatestImagesCarouselSlider(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String text;
  final Widget pageToOpen;

  const GridItem(
      {super.key,
        required this.text,
        required this.pageToOpen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 217, 140, 15),
                      Color.fromARGB(255, 240, 51, 12),
                    ]),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: AutoSizeText(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 35, fontFamily: 'Hewina'),
                        maxLines: 2,
                      )),
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: pageToOpen,
                    duration: const Duration(milliseconds: 300)));
          },
        ),
      ),
    );
  }
}