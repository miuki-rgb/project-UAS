import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/schedule_model.dart';
import '../../providers/auth_provider.dart';
import '../transaction/booking_screen.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final Schedule schedule;
  const ScheduleDetailScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Perjalanan')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Armada', style: Theme.of(context).textTheme.labelLarge),
                        Text(schedule.bus?.name ?? '-', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text('Plat Nomor: ${schedule.bus?.plateNumber}'),
                        const Divider(height: 32),
                        Row(
                          children: [
                            const Icon(Icons.circle, size: 12, color: Color(0xFF780000)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(schedule.route?.origin ?? '-')),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 12, color: Color(0xFF003049)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(schedule.route?.destination ?? '-')),
                          ],
                        ),
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Keberangkatan'),
                            Text(DateFormat('dd MMM yyyy, HH:mm').format(schedule.departureTime), 
                                 style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Harga Tiket'),
                            Text(
                              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(schedule.price),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC1121F), fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    if (!auth.isAuthenticated) {
                      Navigator.pushNamed(context, '/login');
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BookingScreen(schedule: schedule)),
                      );
                    }
                  },
                  child: const Text('PESAN SEKARANG'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
