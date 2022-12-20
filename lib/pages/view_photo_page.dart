import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPhotosPage extends StatefulWidget {
  int initialPage = 0;
  PageController? _pageController;
  String dbPath;

  ViewPhotosPage({super.key, required this.dbPath, this.initialPage = 0}) {
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  State<ViewPhotosPage> createState() => _ViewPhotosPageState();
}

class _ViewPhotosPageState extends State<ViewPhotosPage> {
  ValueNotifier<Map<String, dynamic>?> current = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(widget.dbPath)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Stack(
                children: [
                  PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      current.value = snapshot.requireData.docs[index].data();
                      var value = snapshot.requireData.docs[index].data();
                      var videoUrl = value['video_url'];
                      return (videoUrl == null)
                          ? PhotoViewGalleryPageOptions(
                              imageProvider: CachedNetworkImageProvider(
                                  snapshot.requireData.docs[index]['url']),
                              initialScale: PhotoViewComputedScale.contained,
                            )
                          : PhotoViewGalleryPageOptions.customChild(
                              disableGestures: true,
                              gestureDetectorBehavior:
                                  HitTestBehavior.deferToChild,
                              child: Stack(
                                children: [
                                  SizedBox.expand(
                                    child: CachedNetworkImage(
                                      imageUrl: value['url'],
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launchUrl(
                                          mode: LaunchMode.externalApplication,
                                          Uri.parse(value['video_url']));
                                    },
                                    child: SizedBox.expand(
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Center(
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Transform.scale(
                                                scale: 3,
                                                child: const Icon(
                                                    Icons.play_circle)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //imageProvider: CachedNetworkImageProvider(snapshot.requireData.docs[index]['url']),
                              initialScale:
                                  PhotoViewComputedScale.contained, //* 0.8,
                              //heroAttributes: PhotoViewHeroAttributes(tag: snapshot.requireData.docs[index]['url']),
                            );
                    },
                    itemCount: snapshot.requireData.docs.length,
                    loadingBuilder: (context, event) => const Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    pageController: widget._pageController,
                  ),
                ],
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (current.value?.containsKey('video_url') ?? false) {
              Share.share(current.value?['video_url'],
                  subject: 'Siddhant 2K22');
            } else {
              final temp = await getTemporaryDirectory();
              final path = '${temp.path}/image.jpg';
              final url = Uri.parse(current.value?['url'] ??"");
              final response = await http.get(url);
              await File(path).writeAsBytes(response.bodyBytes);
              await Share.shareXFiles([XFile(path)], text: 'Siddhant 2K22');
            }
          },
          child: const Icon(Icons.share)),
    );
  }
}
