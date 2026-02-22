import 'package:flutter/material.dart';
import '../../application/services/day_lifecycle_service.dart';
import '../../core/rules/cash_boxes.dart';
import '../../core/value_objects/cash_box_id.dart';
import '../../core/value_objects/money.dart';

class OpenDayScreen extends StatefulWidget {
  final DayLifecycleService dayService;

  const OpenDayScreen({
    super.key,
    required this.dayService,
  });

  @override
  State<OpenDayScreen> createState() => _OpenDayScreenState();
}

class _OpenDayScreenState extends State<OpenDayScreen> {
  final Map<CashBoxId, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (final box in CashBoxes.all) {
      _controllers[box] = TextEditingController(text: "0");
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final Map<CashBoxId, Money> openingBalances = {};

    for (final entry in _controllers.entries) {
      final value = double.tryParse(entry.value.text) ?? 0;
      if (value < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("لا يسمح برصيد سالب")),
        );
        return;
      }
      openingBalances[entry.key] = Money(value);
    }

    widget.dayService.openDay(openingBalances);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("أرصدة بداية اليوم"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: CashBoxes.all.map((box) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: _controllers[box],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: box.value,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text("بداية اليوم"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}