import 'package:flutter/material.dart';
import '../../application/services/day_lifecycle_service.dart';
import 'open_day_screen.dart';

class HomeScreen extends StatefulWidget {
  final DayLifecycleService dayService;

  const HomeScreen({
    super.key,
    required this.dayService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isOpen = widget.dayService.isDayOpen;
    final balances = widget.dayService.currentBalances;
    final total = balances.values.fold<double>(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text("AIMEX"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTotalCard(balances, total),
            const SizedBox(height: 16),
            _buildStartDayButton(isOpen),
            const SizedBox(height: 20),
            _buildGridButtons(isOpen),
            const SizedBox(height: 20),
            _buildEndDayButton(isOpen),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(Map<String, double> balances, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(
            "إجمالي الخزائن: ${_format(total)} ج.م",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: balances.entries.map((e) {
              return _cashBox(e.key, _format(e.value));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _cashBox(String title, String amount) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "$amount ج.م",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStartDayButton(bool isOpen) {
    return GestureDetector(
      onTap: isOpen
          ? null
          : () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OpenDayScreen(dayService: widget.dayService),
          ),
        );

        if (result == true) {
          setState(() {});
        }
      },
      child: Opacity(
        opacity: isOpen ? 0.5 : 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            children: [
              Icon(Icons.wb_sunny, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                "بداية اليوم",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButtons(bool isOpen) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1,
      children: [
        _gridItem("البيع", Icons.shopping_cart, Colors.orange, isOpen),
        _gridItem("الشراء", Icons.inventory, Colors.green, isOpen),
        _gridItem("المصروفات", Icons.wallet, Colors.red, isOpen),
        _gridItem("سداد عميل", Icons.handshake, Colors.teal, isOpen),
        _gridItem("جرد المخزون", Icons.search, Colors.amber, true),
        _gridItem("المسحوبات", Icons.money, Colors.purple, isOpen),
      ],
    );
  }

  Widget _gridItem(
      String title, IconData icon, Color color, bool enabled) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? () {} : null,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEndDayButton(bool isOpen) {
    return ElevatedButton(
      onPressed: isOpen
          ? () {
        widget.dayService.closeDay();
        setState(() {});
      }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        "إنهاء اليوم",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _format(double value) {
    return value.toStringAsFixed(0);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    );
  }
}