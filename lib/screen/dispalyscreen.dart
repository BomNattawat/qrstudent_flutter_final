import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrstudent_flutter/screen/logout.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR STUDENT"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("list").orderBy('time', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: Colors.black87,
              ),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(document["sid"]),
                          ),
                        ),
                      ),
                      title: Text(document["firstname"] + ' ' + document["lastname"]),
                      subtitle:
                          Text(document["time"].toDate().toString()),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),backgroundColor: Colors.blue,
    );
  }
}
