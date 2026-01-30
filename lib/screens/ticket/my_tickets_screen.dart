import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../models/booking_model.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (!auth.isAuthenticated) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF0D5),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.confirmation_number_rounded, size: 80, color: const Color(0xFF003049).withOpacity(0.2)),
              const SizedBox(height: 16),
              const Text('Login untuk melihat tiket Anda', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('LOGIN'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF0D5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Tiket Saya', style: TextStyle(color: Color(0xFF003049), fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: FutureBuilder(
        future: ApiService().getMyTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Gagal memuat data tiket.'));
          }
          
          final bookings = (snapshot.data!.data as List).map((e) => Booking.fromJson(e)).toList();

          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.airplane_ticket_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Belum ada tiket yang dibooking', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _buildTicketCard(context, booking, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Booking booking, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TicketDetailScreen(booking: booking)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF780000).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.directions_bus_rounded, color: Color(0xFF780000)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.schedule?.bus?.name ?? 'Bus', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Order ID: #${booking.id}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  _buildStatusBadge(booking.status),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _buildLocationInfo(booking.schedule?.route?.origin ?? '', 'Asal')),
                  const Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
                  Expanded(child: _buildLocationInfo(booking.schedule?.route?.destination ?? '', 'Tujuan')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF003049).withOpacity(0.03),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(booking.schedule?.departureTime ?? DateTime.now()),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003049)),
                  ),
                  const Text('Lihat Detail →', style: TextStyle(color: Color(0xFF669BBC), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (100 * index).ms).moveY(begin: 20, end: 0),
    );
  }

  Widget _buildLocationInfo(String city, String label) {
    return Column(
      crossAxisAlignment: label == 'Asal' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        Text(city, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.orange;
    String label = 'BELUM BAYAR';
    
    if (status == 'paid') {
      color = Colors.blue;
      label = 'MENUNGGU KONFIRMASI';
    } else if (status == 'confirmed') {
      color = Colors.green;
      label = 'LUNAS (SIAP SCAN)';
    } else if (status == 'used') {
      color = Colors.red;
      label = 'TERPAKAI';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}

class TicketDetailScreen extends StatelessWidget {
  final Booking booking;
  const TicketDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003049),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('E-Tiket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    // Top Part (Bus Info)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.qr_code_2_rounded, size: 40, color: Color(0xFF780000)),
                          const SizedBox(height: 16),
                          Text(booking.schedule?.bus?.name ?? '-', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          Text('Plat Nomor: ${booking.schedule?.bus?.plateNumber ?? '-'}', style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetailItem('DARI', booking.schedule?.route?.origin ?? '-'),
                              _buildDetailItem('KE', booking.schedule?.route?.destination ?? '-'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetailItem('TANGGAL', DateFormat('dd MMM yyyy').format(booking.schedule?.departureTime ?? DateTime.now())),
                              _buildDetailItem('WAKTU', DateFormat('HH:mm').format(booking.schedule?.departureTime ?? DateTime.now())),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Dashed Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: List.generate(20, (index) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        )),
                      ),
                    ),

                    // Bottom Part (QR Code)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
                                ),
                                child: Opacity(
                                  opacity: booking.status == 'used' ? 0.1 : 1.0,
                                  child: QrImageView(
                                    data: booking.qrCodeData ?? 'INVALID',
                                    version: QrVersions.auto,
                                    size: 180.0,
                                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF003049)),
                                    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Color(0xFF003049)),
                                  ),
                                ),
                              ),
                              if (booking.status == 'used')
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Text(
                                    'TELAH DIGUNAKAN',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ).animate().rotate(begin: -0.1, end: -0.1),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            booking.status == 'used' 
                              ? 'TIKET SUDAH TIDAK BERLAKU' 
                              : (booking.status == 'confirmed' ? 'SILAKAN SCAN PADA PETUGAS' : 'MENUNGGU KONFIRMASI PEMBAYARAN'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              letterSpacing: 1.2, 
                              fontSize: 12, 
                              color: booking.status == 'used' ? Colors.red : const Color(0xFF003049)
                            )
                          ),
                          const SizedBox(height: 8),
                          Text('Tiket ID: #${booking.id}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 30),
              const Text(
                'Harap datang 15 menit sebelum keberangkatan.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: label == 'DARI' || label == 'TANGGAL' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF003049))),
      ],
    );
  }
}