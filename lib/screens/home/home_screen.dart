import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/api_service.dart';
import '../../models/schedule_model.dart';
import '../../models/announcement_model.dart';
import '../../providers/auth_provider.dart';
import 'schedule_detail_screen.dart';
import 'announcement_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Schedule>> _schedulesFuture;
  late Future<List<Announcement>> _announcementsFuture;
  
  String? _selectedOrigin;
  String? _selectedDestination;
  DateTime? _selectedDate;
  
  List<String> _origins = [];
  List<String> _destinations = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _loadSchedules();
    _announcementsFuture = _fetchAnnouncements();
    _apiService.getLocations().then((res) {
      setState(() {
        _origins = List<String>.from(res.data['origins']);
        _destinations = List<String>.from(res.data['destinations']);
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  void _loadSchedules() {
    setState(() {
      _schedulesFuture = _fetchSchedules(
        origin: _selectedOrigin,
        destination: _selectedDestination,
        date: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null,
      );
    });
  }

  Future<List<Schedule>> _fetchSchedules({String? origin, String? destination, String? date}) async {
    try {
      final response = await _apiService.getSchedules(origin: origin, destination: destination, date: date);
      return (response.data as List).map((e) => Schedule.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Announcement>> _fetchAnnouncements() async {
    try {
      final response = await _apiService.getAnnouncements();
      return (response.data as List).map((e) => Announcement.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0D5),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadInitialData();
          await Future.delayed(const Duration(seconds: 1)); // Give visual feedback
        },
        color: const Color(0xFF780000),
        child: CustomScrollView(
          slivers: [
                        // Header Modern & Estetik (Diperkecil)
                        SliverAppBar(
                          expandedHeight: 140, // Diperkecil dari 200
                          floating: false,
                          pinned: true,
                          elevation: 0,
                          backgroundColor: const Color(0xFF780000),
                          flexibleSpace: FlexibleSpaceBar(
                            expandedTitleScale: 1.1,
                            titlePadding: const EdgeInsets.only(left: 20, bottom: 55), // Sesuaikan jarak judul
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auth.isAuthenticated ? 'Halo, ${auth.user?.name}' : 'Halo, Teman Busket!',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 16, // Sedikit diperkecil
                                    color: Color(0xFFFDF0D5),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const Text(
                                  'Mau ke mana hari ini?',
                                  style: TextStyle(
                                    fontSize: 9, 
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF780000), Color(0xFF003049)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -10,
                                    top: 0,
                                    child: Icon(
                                      Icons.directions_bus_filled,
                                      size: 100, // Kecilkan dekorasi ikon
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
            
                        // Search Card (Minimalist)
                        SliverToBoxAdapter(
                          child: Transform.translate(
                            offset: const Offset(0, -30), // Kurangi offset agar tidak terlalu naik ke atas header // Jaga kartu tetap naik sedikit ke atas header
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Column(
                  children: [
                    _buildSelectionRow(
                      icon: Icons.location_on_rounded,
                      color: const Color(0xFF780000),
                      label: 'Dari',
                      value: _selectedOrigin ?? 'Pilih Kota Asal',
                      onTap: () => _showPicker('Pilih Kota Asal', _origins, (val) => setState(() => _selectedOrigin = val)),
                    ),
                    const Divider(height: 30),
                    _buildSelectionRow(
                      icon: Icons.navigation_rounded,
                      color: const Color(0xFF003049),
                      label: 'Tujuan',
                      value: _selectedDestination ?? 'Pilih Kota Tujuan',
                      onTap: () => _showPicker('Pilih Kota Tujuan', _destinations, (val) => setState(() => _selectedDestination = val)),
                    ),
                    const Divider(height: 30),
                    _buildSelectionRow(
                      icon: Icons.calendar_today_rounded,
                      color: const Color(0xFF669BBC),
                      label: 'Tanggal',
                      value: _selectedDate == null ? 'Pilih Tanggal' : DateFormat('dd MMMM yyyy').format(_selectedDate!),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003049),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _loadSchedules,
                        child: const Text('Cari Jadwal Bus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
            ),
          ),

          // Announcements Carousel
          SliverToBoxAdapter(
            child: FutureBuilder<List<Announcement>>(
              future: _announcementsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, bottom: 12),
                      child: Text('Info & Promo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003049))),
                    ),
                    SizedBox(
                      height: 120,
                      child: PageView.builder(
                        itemCount: snapshot.data!.length,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnnouncementDetailScreen(announcement: item))),
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: item.type == 'delay' 
                                    ? [const Color(0xFF780000), const Color(0xFFC1121F)]
                                    : [const Color(0xFF003049), const Color(0xFF669BBC)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Expanded(child: Text(item.content, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Schedules List
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 24, bottom: 12),
              child: Text('Jadwal Tersedia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003049))),
            ),
          ),

          FutureBuilder<List<Schedule>>(
            future: _schedulesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator())));
              if (!snapshot.hasData || snapshot.data!.isEmpty) return const SliverToBoxAdapter(child: Center(child: Text('Tidak ada jadwal hari ini.')));

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildModernScheduleCard(context, snapshot.data![index], index),
                    childCount: snapshot.data!.length,
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)), // Space for floating bottom nav
        ],
      ),
    ),
    );
  }

  Widget _buildSelectionRow({required IconData icon, required Color color, required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF003049))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernScheduleCard(BuildContext context, Schedule item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduleDetailScreen(schedule: item))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.bus?.name ?? 'Bus', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('Stock: ${item.stockAvailable}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.price),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC1121F), fontSize: 16),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
            Row(
              children: [
                Expanded(child: _buildTimePoint(DateFormat('HH:mm').format(item.departureTime), item.route?.origin ?? '')),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
                ),
                Expanded(child: _buildTimePoint(DateFormat('HH:mm').format(item.arrivalTime), item.route?.destination ?? '', alignEnd: true)),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).moveY(begin: 20, end: 0);
  }

  Widget _buildTimePoint(String time, String city, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003049))),
        Text(
          city, 
          style: const TextStyle(color: Colors.grey, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }

  void _showPicker(String title, List<String> items, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(items[index]),
                  onTap: () {
                    onSelected(items[index]);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
