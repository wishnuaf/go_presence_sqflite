import 'package:flutter/material.dart';
import 'package:go_presence_sqflite/models/absensi_model.dart';
import 'package:go_presence_sqflite/services/absensi_db_helper.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
  Position? _currentPosition;
  bool _sudahAbsenMasuk = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _startClock();
  }

  void _startClock() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
        });
        _startClock();
      }
    });
  }

  Future<void> _getLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _absenMasuk() async {
    final now = DateTime.now();
    final hari = DateFormat('EEEE', 'id_ID').format(now);
    final tanggal = DateFormat('dd MMMM yyyy', 'id_ID').format(now);
    final jam = DateFormat('HH:mm:ss').format(now);

    final lat = _currentPosition?.latitude.toStringAsFixed(5) ?? 'Unknown';
    final lng = _currentPosition?.longitude.toStringAsFixed(5) ?? 'Unknown';

    final absensi = AbsensiModel(
      hari: hari,
      tanggal: tanggal,
      jamMasuk: jam,
      latitude: lat,
      longitude: lng,
      jamPulang: jam,
    );

    await AbsensiDbHelper().insertAbsensi(absensi);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Absen Berhasil'),
            content: Text(
              'Hari: $hari\nTanggal: $tanggal\nJam: $jam\nLat: $lat\nLng: $lng',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
    setState(() {
      _sudahAbsenMasuk = true;
    });
  }

  void _absenPulang() async {
    final now = DateTime.now();
    final jamPulang = DateFormat('HH:mm:ss').format(now);
    final tanggal = DateFormat('dd MMMM yyyy', 'id_ID').format(now);

    await AbsensiDbHelper().updateJamPulang(tanggal, jamPulang);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Absen Pulang'),
            content: Text('Waktu Pulang: $jamPulang'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Aktivitas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      'assets/images/profile.jpg',
                    ), // Ganti sesuai gambar kamu
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Charlier Herwitz",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "UI/UX Designer",
                        style: GoogleFonts.poppins(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Date & Time
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Text(_currentDate),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Text(_currentTime),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Map/Location
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    _currentPosition != null
                        ? Center(
                          child: Text(
                            "Lat: ${_currentPosition!.latitude.toStringAsFixed(5)}\nLng: ${_currentPosition!.longitude.toStringAsFixed(5)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                        : const Center(child: CircularProgressIndicator()),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (!_sudahAbsenMasuk) {
                      _absenMasuk();
                    } else {
                      _absenPulang();
                    }
                  },
                  icon: Icon(
                    _sudahAbsenMasuk ? Icons.logout : Icons.how_to_reg,
                  ),
                  label: Text(
                    _sudahAbsenMasuk ? "Absen Pulang" : "Absen Masuk",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
