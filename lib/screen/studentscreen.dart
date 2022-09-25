import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qrstudent_flutter/screen/dispalyscreen.dart';
import 'package:qrstudent_flutter/screen/logout.dart';
import 'package:qrstudent_flutter/screen/scannerscreen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: MaterialApp(
          home: Scaffold(
            // appBar: AppBar(
            //   title: Text('QR STUDENT'),
            //   backgroundColor: Colors.black87,
            // ),
            body: TabBarView(
              children: [DisplayScreen(), ScannerScreen(), LogoutScreen()],
            ),
            bottomNavigationBar: TabBar(tabs: [
              Tab(
                text: 'Student',
              ),
              Tab(
                text: 'Scanner',
              ),
              Tab(
                text: 'More',
              )
            ]),
            backgroundColor: Colors.blue
          ),
        ));
  }
}
