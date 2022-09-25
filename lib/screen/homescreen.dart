import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qrstudent_flutter/screen/login.dart';
import 'package:qrstudent_flutter/screen/register.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR STUDENT',
      home: Scaffold(
        appBar: AppBar(
          title: Text("QR STUDENT",),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Image.asset('images/qr-code.png'),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RegisterScreen();
                  }));
                },
                icon: Icon(Icons.app_registration,color: Colors.blue,),
                label: Text(
                  " SIGN UP ",
                  style: TextStyle(fontSize: 18,color: Colors.blue),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                },
                icon: Icon(Icons.login,color: Colors.blue,),
                label: Text(
                  " SIGN IN ",
                  style: TextStyle(fontSize: 18,color: Colors.blue),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            )
          ]),
        ),backgroundColor: Colors.blue,
      ),
    );
  }
}
