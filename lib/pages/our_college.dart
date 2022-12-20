import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OurCollegePage extends StatefulWidget {
  const OurCollegePage({super.key});

  @override
  State<OurCollegePage> createState() => _OurCollegePageState();
}

class _OurCollegePageState extends State<OurCollegePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About our college"),
      ),
      body: SingleChildScrollView(
        child: AnimatedSize(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
          child: Column(children: [
            Image.network(
              "http://svscbantwal.com/wp-content/uploads/2018/06/header-logo.png",
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Introduction",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    """Sri Venkataramana Swamy College, Bantwal was Established in the year 1968 by Bantwal Raghuram Mukunda Prabhu with the help of philanthropists with the motto ‘Vidya Sarvartha Sadhake’. It is the first centre of higher education to have come up in the taluk and also the most developed college in the entire taluk. Nestled among a cluster of hillocks in serene surroundings, the institution is blissfully away from the din and bustle of city life. A committed band of teachers, ably supported by a visionary Board of Management, offers affordable and quality education to rural students who pursue learning with humility and keenness. The excellent rapport that exists between the teachers and the students is unique feature of the institution. As the educational scenario in the whole country is undergoing an inevitable churning process, the institution is marching ahead with a vision based on the realities of the modern world. Retaining the traditional courses, the college offers new disciplines and a post-graduation course in commerce.
The Annual Mega Job Fair, special online courses, a good number of certificate courses and so on make the college a highly sought after one in the district. The college has been reaccredited at ‘A’ Grade (CGPA 3.31) by the National Assessment and Accreditation Council (NAAC) in the year 2016. Supported by ‘Star College Scheme’ by the DBT, Government of India.""",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(imageUrl: 'http://svscbantwal.com/wp-content/uploads/2018/06/cover03-1400x589.jpg',width: double.infinity,fit: BoxFit.fitWidth,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Location",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    """The college is situated at Vidyagiri, which is 5 kms away from enroute to Moodabidri from B. C. Road. B. C. Road is on the National Highway 75 that connects the port city of Mangalore and Bangalore. The distance between Mangalore and B.C. Road is 25 Kms. There is a railway station at B.C. Road that is known as Bantwal Railway Station. The Yashawanthapura-Kannur Express passes through B.C. Road.""",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
