import 'package:flutter/material.dart';

void main() {
  runApp(const AimexApp());
}

class AimexApp extends StatelessWidget {
  const AimexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('AIMEX'),
        ),
      ),
    );
  }
}