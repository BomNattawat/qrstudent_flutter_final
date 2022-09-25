import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qrstudent_flutter/screen/homescreen.dart';
import 'package:url_launcher/url_launcher.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final auth = FirebaseAuth.instance;
  final Uri _url = Uri.parse('https://qr-student-565e2.web.app');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _launchUrl,
                  icon: Icon(
                    Icons.web_stories,
                    color: Colors.blue,
                  ),
                  label: Text(
                    'Website',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return homescreen();
                      }));
                    });
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.blue,
                  ),
                  label: Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue,
    );
  }

  Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
}
