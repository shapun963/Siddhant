import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDevsPage extends StatefulWidget {
  const AboutDevsPage({super.key});

  @override
  State<AboutDevsPage> createState() => _AboutDevsPageState();
}

class _AboutDevsPageState extends State<AboutDevsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Developers"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('developers')
                  .doc('img_urls')
                  .snapshots(),
              builder: (context, snapshot) {
                return Column(children: [
                  LayoutBuilder(
                    builder: (_, constraints) => SizedBox(
                      width: constraints.biggest.width / 2,
                      height: constraints.biggest.width / 2,
                      child: DeveloperInfo(
                          name: "Shapun S Poonja",
                          imageUrl: snapshot.data?.get('shapun')),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: DeveloperInfo(
                            name: "Vivek Pai",
                            imageUrl: snapshot.data?.get('vivek')),
                      ),
                      Flexible(
                        flex: 1,
                        child: DeveloperInfo(
                            name: "Raskhitha Poojary",
                            imageUrl: snapshot.data?.get('rakshitha')),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: DeveloperInfo(
                            name: "Sai Neha",
                            imageUrl: snapshot.data?.get('sai_neha')),
                      ),
                      Flexible(
                        flex: 1,
                        child: DeveloperInfo(
                            name: "Shasha Shetty",
                            imageUrl: snapshot.data?.get('shasha')),
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            launchUrl(mode:LaunchMode.externalApplication,Uri.parse('https://github.com/shapun963/siddhant'));
                          },
                          icon: const Icon(Icons.open_in_browser),
                          label: const Text("View SourceCode on Github"),),
                    ),
                  )
                ]);
              }),
        ),
      ),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const DeveloperInfo({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              imageUrl == null
                  ? const Center(child: CircularProgressIndicator())
                  : CachedNetworkImage(
                      imageUrl: imageUrl!,
                      placeholder: (_, __) =>
                          const Center(child: CircularProgressIndicator()),
                    ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
