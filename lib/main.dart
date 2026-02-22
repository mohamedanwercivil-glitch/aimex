import 'package:flutter/material.dart';

import 'application/services/day_lifecycle_service.dart';
import 'presentation/screens/home_screen.dart';
import 'domain/entities/inventory.dart';

void main() {
  runApp(const AimexApp());
}

class AimexApp extends StatefulWidget {
  const AimexApp({super.key});

  @override
  State<AimexApp> createState() => _AimexAppState();
}

class _AimexAppState extends State<AimexApp> {
  late final DayLifecycleService _dayLifecycleService;
  late final Inventory _inventory;

  @override
  void initState() {
    super.initState();

    _inventory = Inventory.empty();

    _dayLifecycleService = DayLifecycleService(
      inventory: _inventory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AIMEX',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: HomeScreen(
        dayService: _dayLifecycleService,
      ),
    );
  }
}