import 'package:flutter/material.dart';
import 'showpage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Layout demo',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  get selectedNumber => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the School of Computer Science'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/image.png',
                        width: 380,
                        height: 190,
                      ),
                    ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'University of Birmingham',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Birmingham, UK',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 600,
                child: const Text(
                  'Smart devices are common, but extreme weather such as strong winds or rain and snow make outdoor communication difficult.'
                      'Our goal is to communicate information and count steps by recognizing gestures that correspond to specific numbers,'
                      'leveraging basic features such as gait tracking and wrist flip detection. '
                      'This approach greatly reduces the effort required for users to deliver information under adverse conditions.',
                  softWrap: true,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child:ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceStatusPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 12),
                ),
                child: const Text('Start'),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Icon(Icons.call),
                    Text('CONTACT US'),
                  ],
                ),
                Column(
                  children: const [
                    Icon(Icons.near_me),
                    Text('ROUTE'),
                  ],
                ),
                Column(
                  children: const [
                    Icon(Icons.share),
                    Text('SHARE'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
