import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:qrstudent_flutter/model/profile.dart';
import 'package:qrstudent_flutter/screen/studentscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Error'),
                backgroundColor: Colors.blue,
              ),
              body: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Sign in to your account'),
                backgroundColor: Colors.blue,
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address : ',
                            style: TextStyle(fontSize: 18,color: Colors.white),
                          ),
                          TextFormField(cursorColor: Colors.white,
                            initialValue: profile.email,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'Please enter your email.'),
                              EmailValidator(
                                  errorText: 'Please enter email format.')
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? email) {
                              profile.email = email;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Password : ',
                            style: TextStyle(fontSize: 18,color: Colors.white),
                          ),
                          TextFormField(cursorColor: Colors.white,
                            obscureText: true,
                            onSaved: (String? password) {
                              profile.password = password;
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                formKey.currentState!.validate();
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: profile.email.toString(),
                                            password:
                                                profile.password.toString())
                                        .then((value) {
                                      formKey.currentState!.reset();
                                      Fluttertoast.showToast(
                                          msg:
                                              'The user account has been login successfully.',
                                          gravity: ToastGravity.CENTER);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return StudentScreen(); // go to page
                                      }));
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    String message = '';
                                    message = e.message!;
                                    Fluttertoast.showToast(
                                        msg: e.toString(),
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(fontSize: 18,color: Colors.blue),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.white)),
                            ),
                          )
                        ],
                      )),
                ),
              ),backgroundColor: Colors.blue,
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: Colors.black87,
              ),
            ),
          );
        });
  }
}
