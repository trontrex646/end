import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ClockControlScreen(),
    );
  }
}

class ClockControlScreen extends StatefulWidget {
  @override
  _ClockControlScreenState createState() => _ClockControlScreenState();
}

class _ClockControlScreenState extends State<ClockControlScreen> {
  final TextEditingController messageController = TextEditingController();
  String status = "Unknown";

  Future<void> controlClock(String action) async {
    final response = await http.post(
      Uri.parse('http://<Raspberry-Pi-IP>:5000/control'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': action}),
    );

    if (response.statusCode == 200) {
      setState(() {
        status = jsonDecode(response.body)['status'];
      });
    } else {
      setState(() {
        status = "Failed to control clock";
      });
    }
  }

  Future<void> updateMessage() async {
    final response = await http.post(
      Uri.parse('http://<Raspberry-Pi-IP>:5000/message'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': messageController.text}),
    );

    if (response.statusCode == 200) {
      setState(() {
        status = jsonDecode(response.body)['status'];
      });
    } else {
      setState(() {
        status = "Failed to update message";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clock Control")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => controlClock("start"),
              child: Text("Start Clock"),
            ),
            ElevatedButton(
              onPressed: () => controlClock("stop"),
              child: Text("Stop Clock"),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: "Enter Custom Message"),
            ),
            ElevatedButton(
              onPressed: updateMessage,
              child: Text("Update Message"),
            ),
            SizedBox(height: 20),
            Text("Status: $status"),
          ],
        ),
      ),
    );
  }
}
