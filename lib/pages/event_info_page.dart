import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfettiStateNotification extends Notification {
  final bool play;
  const ConfettiStateNotification({required this.play});
}

class EventInfoPage extends StatefulWidget {
  const EventInfoPage({super.key});
  
  @override
  State<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Info"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Description :",
                  style: TextStyle(color: Colors.yellow, fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    """Welcome to the quiz competition! This competition consists of five rounds, each with its own set of questions on a variety of topics.
Round 1: Quizardry
Round 2: Fortunate Dice
Round 3: Treasure Hunt
Round 4: IQ Arrest
Round 5: Ultimate Showdown
Get ready to put your trivia skills to the test and see how you measure up against the competition in Quizardry, Fortunate Dice, Treasure Hunt, IQ Arrest, and the Ultimate Showdown!
"""),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Rules :",
                  style: TextStyle(color: Colors.yellow, fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    """1. The participants are required to wear their School / College uniforms.
2. The participants must bring the School / College ID card and also the golden tickets. 6. The participants should be accompanied by the in-charge teachers.
3. Any kind of vulgarity, offensive language and misbehavior will result in immediate disqualification and
no arguments will be encouraged.
4. The organizing committee reserves the right to make any change in the rules to ensure smooth functioning of the event.
5. In all rounds Quiz Master's decision will be final and no arguments will be entertained."""),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Event Heads :",
                  style: TextStyle(color: Colors.yellow, fontSize: 18),
                ),
              ),
              EventHead(
                  headName: "Vaishak S Bangera", phoneNo: "+917618710300"),
              const SizedBox(
                height: 8,
              ),
              EventHead(
                  headName: "Poorvashree Acharya", phoneNo: "+918762811032"),
              const SizedBox(
                height: 16,
              ),
              EventStatus(
                name: "High School Results",
                nameInDB: "high_school_results",
              ),
              const SizedBox(
                height: 16,
              ),
              EventStatus(
                name: "PUC Results",
                nameInDB: "puc_results",
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EventHead extends StatelessWidget {
  String headName;
  String phoneNo;

  EventHead({Key? key, required this.headName, required this.phoneNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              headName,
              style: const TextStyle(fontSize: 18),
            ),
            GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse('tel:$phoneNo'));
                },
                child: const Text("Call",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        decoration: TextDecoration.underline)))
          ],
        ),
      ),
    );
  }
}

class EventStatus extends StatefulWidget {
  String name;
  String nameInDB;

  EventStatus({Key? key, required this.name, required this.nameInDB})
      : super(key: key);

  @override
  State<EventStatus> createState() => _EventStatusState();
}

class _EventStatusState extends State<EventStatus> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      theme: const ExpandableThemeData(iconColor: Colors.white),
      header: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.name,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      expanded: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(widget.nameInDB)
              .orderBy('round')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return StatefulBuilder(
              builder: (_, setState) => Stepper(
                margin: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                currentStep: currentStep,
                steps: getSteps(snapshot),
                type: StepperType.vertical,
                controlsBuilder: (_, __) => Row(children: const []),
                onStepTapped: (step) {
                  setState(() {
                    currentStep = step;
                  });
                },
              ),
            );
          }),
      collapsed: SizedBox.fromSize(
        size: Size.zero,
      ),
    );
  }

  List<Step> getSteps(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return [
      for (int i = 0; i < (snapshot.data?.size ?? 0); i++)
        Step(
          title: Text(snapshot.data?.docs[i]['name']),
          subtitle: snapshot.data?.docs[i]['status'] != null
              ? Text(snapshot.data?.docs[i]['status'])
              : null,
          //Temporary solution to use  new line
          content: snapshot.data?.docs[i]['result'] == null
              ? const SizedBox.shrink()
              : Text(snapshot.data?.docs[i]['result']
                      .toString()
                      .replaceAll('\\n', '\n') ??
                  ""),
          state: snapshot.data?.docs[i]['status'] == null
              ? StepState.disabled
              : snapshot.data?.docs[i]['result'] == null
                  ? StepState.indexed
                  : StepState.complete,
          isActive: snapshot.data?.docs[i]['status'] != null,
        ),
    ];
  }
}
