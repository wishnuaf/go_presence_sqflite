import 'package:flutter/material.dart';
import 'package:go_presence_sqflite/services/app_database.dart';
import 'package:go_presence_sqflite/utils/location_utils.dart';
import 'package:intl/intl.dart';
import '../models/absensi_model.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  List<AbsensiModel> _filteredReports = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromDate = now.subtract(const Duration(days: 7));
    _toDate = now;
    _loadReports();
  }

  Future<void> _loadReports() async {
    final allData = await AppDatabase().getAllAbsensi();
    setState(() {
      _filteredReports =
          allData.where((e) {
            final tgl = DateFormat('dd MMMM yyyy', 'id_ID').parse(e.tanggal);
            return tgl.isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
                tgl.isBefore(_toDate!.add(const Duration(days: 1)));
          }).toList();
    });
  }

  Future<void> _selectDate({required bool isFrom}) async {
    final result = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate! : _toDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      setState(() {
        if (isFrom) {
          _fromDate = result;
        } else {
          _toDate = result;
        }
      });
      _loadReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aktivitas"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Date Filters
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(isFrom: true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Dari"), Text(df.format(_fromDate!))],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(isFrom: false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Sampai"), Text(df.format(_toDate!))],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loadReports,
                child: const Text("Lihat Laporan"),
              ),
            ),
            const SizedBox(height: 16),
            // Laporan
            Expanded(
              child:
                  _filteredReports.isEmpty
                      ? const Center(child: Text("Tidak ada data"))
                      : ListView.builder(
                        itemCount: _filteredReports.length,
                        itemBuilder: (context, index) {
                          final data = _filteredReports[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.blue),
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text("${data.hari}, ${data.tanggal}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.login,
                                            size: 20,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(data.jamMasuk),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.logout,
                                            size: 20,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            data.jamPulang ?? '-',
                                            style: TextStyle(
                                              color:
                                                  data.jamPulang != null
                                                      ? Colors.black
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 20,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 4),
                                      FutureBuilder<String>(
                                        future: getAddressFromLatLng(
                                          data.latitude,
                                          data.longitude,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Text(
                                              "Sedang memuat alamat...",
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                              "Gagal memuat alamat",
                                            );
                                          } else {
                                            return Text(
                                              snapshot.data ?? "-",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
