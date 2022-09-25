import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:qrstudent_flutter/screen/studentscreen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}',style: TextStyle(fontSize: 18,color: Colors.blue),);
                              },
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}',style: TextStyle(fontSize: 18,color: Colors.blue),);
                                } else {
                                  return const Text('loading',style: TextStyle(fontSize: 18,color: Colors.blue),);
                                }
                              },
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.blue,
      );
    }
    if (result != null) {
      String sid = '${result!.code}';
      final Future<FirebaseApp> firebase = Firebase.initializeApp();
      CollectionReference _studentCollection =
          FirebaseFirestore.instance.collection('list');

      return Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("students")
              .where('sid', isEqualTo: sid)
              .snapshots(),
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
                        title: Text(
                            document["firstname"] + ' ' + document["lastname"]),
                        subtitle: Text(document["sid"]),
                        onLongPress: () async {
                          await _studentCollection.add({
                            'firstname': document["firstname"],
                            'lastname': document["lastname"],
                            'sid': document["sid"],
                            'time': FieldValue.serverTimestamp()
                            // 'time': DateTime.now()
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentScreen(),
                              ));
                        },
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
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
