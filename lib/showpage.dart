import 'package:flutter/material.dart';
import 'package:appui/help_data.dart';
import 'main.dart';
import 'settingpage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await Permission.location.request();
  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
}

class DeviceStatusPage extends StatefulWidget {
  const DeviceStatusPage({super.key});

  @override
  State<DeviceStatusPage> createState() => _DeviceStatusPageState();
}

class _DeviceStatusPageState extends State<DeviceStatusPage> {
  late StreamSubscription<List<ScanResult>> _scanSubscription;

  int stepCount = 1350;
  int selectedNumber = -1;
  String wristStatus = "Active";
  String helpMessage = "Keep going";

  @override
  void initState() {
    super.initState();
    requestPermissions().then((_) {
      startListeningBLE();
    });
  }

  void startListeningBLE() {
    print("✅ Start Bluetooth scan");

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        final data = r.advertisementData.manufacturerData;
        if (data.isNotEmpty) {
          final rawBytes = data.values.first;
          try {
            final msg = utf8.decode(rawBytes);
            print("📡 Received broadcast data: $msg");

            if (msg.contains("W:") && msg.contains("G:") && msg.contains("S:")) {
              parseBLEMessage(msg);
            }
          } catch (e) {
            print("❌ Decoding failed: $e");
          }
        }
      }
    });

    FlutterBluePlus.startScan();
  }

  void parseBLEMessage(String msg) {
    final parts = msg.split('#');
    String wrist = '';
    int gesture = -1;
    int steps = 0;

    for (var part in parts) {
      if (part.startsWith("W:")) {
        wrist = part.substring(2);
      } else if (part.startsWith("G:")) {
        gesture = int.tryParse(part.substring(2)) ?? -1;
      } else if (part.startsWith("S:")) {
        steps = int.tryParse(part.substring(2)) ?? 0;
      }
    }

    setState(() {
      wristStatus = wrist;
      selectedNumber = gesture;
      stepCount = steps;
      helpMessage = HelpDataManager.getHelpMessage(gesture) ?? "null";
    });
  }

  @override
  void dispose() {
    _scanSubscription.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipment Condition"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Wrist Condition：", style: TextStyle(fontSize: 18)),
            Text(wristStatus, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            const Text("Help Information：", style: TextStyle(fontSize: 18)),
            Text(helpMessage, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 100),

            const Text("Current number of steps：", style: TextStyle(fontSize: 18)),
            Text("$stepCount", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NumberSelectorPage()),
                    );
                  },
                  child: const Text("Setting"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  child: const Text("Home"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}