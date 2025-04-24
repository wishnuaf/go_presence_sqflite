import 'package:flutter/material.dart';
import 'package:go_presence_sqflite/models/absensi_model.dart';
import 'package:go_presence_sqflite/services/app_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _fullName = '...';

  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadUserData();
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

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId != null) {
      final user = await AppDatabase().getUserById(userId);
      if (user != null) {
        setState(() {
          _fullName = user.fullName;
        });
      }
    }
  }

  void _absenMasuk() async {
    try {
      final now = DateTime.now();
      final hari = DateFormat('EEEE', 'id_ID').format(now);
      final tanggal = DateFormat('dd MMMM yyyy', 'id_ID').format(now);
      final jam = DateFormat('HH:mm:ss').format(now);

      final lat = _currentPosition?.latitude.toStringAsFixed(5) ?? 'Unknown';
      final lng = _currentPosition?.longitude.toStringAsFixed(5) ?? 'Unknown';

      print("Absen Masuk:\nTanggal: $tanggal\nJam: $jam\nLatLng: $lat, $lng");

      final absensi = AbsensiModel(
        hari: hari,
        tanggal: tanggal,
        jamMasuk: jam,
        latitude: lat,
        longitude: lng,
        jamPulang: '', // atau null jika nullable
      );

      await AppDatabase().insertAbsensi(absensi);

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
    } catch (e, stack) {
      debugPrint("❌ Error saat absen masuk: $e");
      debugPrint("🔍 Stack trace: $stack");
    }
  }

  void _absenPulang() async {
    final now = DateTime.now();
    final jamPulang = DateFormat('HH:mm:ss').format(now);
    final tanggal = DateFormat('dd MMMM yyyy', 'id_ID').format(now);

    await AppDatabase().updateJamPulang(tanggal, jamPulang);

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

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // hapus session login dan user_id
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    // backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fullName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: false,
                        ),
                        Text(
                          "UI/UX Designer",
                          style: GoogleFonts.poppins(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    tooltip: 'Logout',
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    _currentPosition != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              zoom: 16,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId("lokasi_saya"),
                                position: LatLng(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                ),
                              ),
                            },
                            zoomControlsEnabled: false,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            onMapCreated: (controller) {},
                          ),
                        )
                        : const Center(child: CircularProgressIndicator()),
              ),

              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                            !_sudahAbsenMasuk
                                ? () {
                                  _absenMasuk();
                                  setState(() {
                                    _sudahAbsenMasuk = true;
                                  });
                                }
                                : null,
                        icon: const Icon(Icons.login),
                        label: const Text("Absen Masuk"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                            _sudahAbsenMasuk
                                ? () {
                                  _absenPulang();
                                  setState(() {
                                    _sudahAbsenMasuk = false;
                                  });
                                }
                                : null,
                        icon: const Icon(Icons.logout),
                        label: const Text("Absen Pulang"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
