import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nooray Ki Screen"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Text(
          "Yay Lo Gi Chal Gya kaam",
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
