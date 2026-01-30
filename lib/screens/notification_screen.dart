import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/api_service.dart';
import '../../models/announcement_model.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import 'home/announcement_detail_screen.dart';
import 'ticket/my_tickets_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _activeTab = 0; // 0 for Announcements, 1 for Transactions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0D5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Notifikasi',
          style: TextStyle(color: const Color(0xFF003049), fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildTabSwitcher(),
          const SizedBox(height: 16),
          Expanded(
            child: _activeTab == 0 ? const _AnnouncementList() : const _TransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            _buildTabButton(0, 'Berita', Icons.campaign_rounded),
            _buildTabButton(1, 'Transaksi', Icons.receipt_long_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    bool isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF003049) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isActive ? Colors.white : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnouncementList extends StatelessWidget {
  const _AnnouncementList();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService().getAnnouncements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || (snapshot.data!.data as List).isEmpty) {
          return _buildEmptyState(Icons.notifications_none_rounded, 'Belum ada berita terbaru');
        }
        
        final data = (snapshot.data!.data as List).map((e) => Announcement.fromJson(e)).toList();
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return _buildModernCard(
              context,
              icon: item.type == 'delay' ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
              iconColor: item.type == 'delay' ? Colors.red : const Color(0xFF669BBC),
              title: item.title,
              subtitle: item.content,
              time: 'Terbaru',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnnouncementDetailScreen(announcement: item))),
            ).animate().fadeIn(delay: (100 * index).ms).moveY(begin: 20, end: 0);
          },
        );
      },
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isAuthenticated) return _buildEmptyState(Icons.lock_outline_rounded, 'Login untuk melihat transaksi');

    return FutureBuilder(
      future: ApiService().getMyTickets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || (snapshot.data!.data as List).isEmpty) {
          return _buildEmptyState(Icons.history_rounded, 'Belum ada riwayat transaksi');
        }

        final data = (snapshot.data!.data as List).map((e) => Booking.fromJson(e)).toList();
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return _buildModernCard(
              context,
              icon: Icons.check_circle_outline_rounded,
              iconColor: Colors.green,
              title: 'Pemesanan Berhasil',
              subtitle: '${item.schedule?.route?.origin} ➔ ${item.schedule?.route?.destination}',
              time: '#${item.id}',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TicketDetailScreen(booking: item))),
            ).animate().fadeIn(delay: (100 * index).ms).moveY(begin: 20, end: 0);
          },
        );
      },
    );
  }
}

Widget _buildModernCard(BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required String time,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003049))),
                    Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyState(IconData icon, String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(message, style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
      ],
    ),
  );
}