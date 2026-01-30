import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/schedule_model.dart';
import '../../services/api_service.dart';

class BookingScreen extends StatefulWidget {
  final Schedule schedule;
  const BookingScreen({super.key, required this.schedule});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _quantity = 1;
  String _selectedPayment = 'Transfer Bank (BCA)';
  bool _isLoading = false;

  final List<String> _paymentMethods = [
    'Transfer Bank (BCA)',
    'Transfer Bank (Mandiri)',
    'E-Wallet (GoPay)',
    'E-Wallet (OVO)',
  ];

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.schedule.price * _quantity;

    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Pesanan')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ringkasan', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jumlah Tiket'),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null, 
                              icon: const Icon(Icons.remove_circle_outline)
                            ),
                            Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: _quantity < widget.schedule.stockAvailable ? () => setState(() => _quantity++) : null, 
                              icon: const Icon(Icons.add_circle_outline)
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(totalPrice),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC1121F), fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Metode Pembayaran', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ..._paymentMethods.map((method) => RadioListTile(
                value: method, 
                groupValue: _selectedPayment, 
                title: Text(method),
                onChanged: (val) => setState(() => _selectedPayment = val!),
                activeColor: const Color(0xFF780000),
                contentPadding: EdgeInsets.zero,
              )),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    try {
                      await ApiService().createBooking(widget.schedule.id, _quantity, _selectedPayment);
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: const Text('Pemesanan Berhasil!'),
                            content: const Text('Tiket Anda telah terbit. Silakan cek di menu Tiket Saya.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pop(context); // Close Booking
                                  Navigator.pop(context); // Close Detail
                                  // In real app, maybe navigate to My Tickets tab
                                },
                                child: const Text('OK'),
                              )
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memesan tiket.')));
                      }
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
                  child: const Text('BAYAR SEKARANG'),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
