import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siddhanth/pages/view_photo_page.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: const Text('Gallery'),
                pinned: false,
                floating: true,
                snap: true,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  tabs: const <Tab>[
                    Tab(text: 'Event'),
                    Tab(text: 'HighSchool'),
                    Tab(text: 'PUC'),
                  ],
                  controller: _tabController,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const <Widget>[
              Gallery(dbPath: '/event_gallery'),
              Gallery(dbPath: '/highschool_gallery'),
              Gallery(dbPath: '/puc_gallery'),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String imgUrl;
  final String? text;
  final GestureTapCallback? onTap;
  final String videoUrl;

  const GridItem(
      {super.key,
      required this.imgUrl,
      this.text,
      required this.videoUrl,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Stack(alignment: Alignment.center, children: [
          Hero(
            tag: imgUrl,
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: imgUrl,
            ),
          ),
          if (videoUrl.isNotEmpty)
            Transform.scale(
                scale: 3, child: const Center(child: Icon(Icons.play_circle)))
        ]),
      ),
    );
  }
}

class Gallery extends StatelessWidget {
  final String dbPath;

  const Gallery({super.key, required this.dbPath});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(dbPath)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
              itemCount: snapshot.requireData.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0),
              itemBuilder: (BuildContext context, int index) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }
                String videoUrl =
                    snapshot.requireData.docs[index].data()['video_url'] ?? "";
                return GridItem(
                  imgUrl: snapshot.requireData.docs[index]['url'],
                  text: snapshot.data?.docs[index].data()['text'],
                  videoUrl: videoUrl,
                  onTap: () {
                    if (videoUrl.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPhotosPage(
                            dbPath: dbPath,
                            initialPage: index,
                          ),
                        ),
                      );
                    } else {
                      launchUrl(mode:LaunchMode.externalApplication,Uri.parse(videoUrl));
                    }
                  },
                );
              },
            );
          }
        });
  }
}
