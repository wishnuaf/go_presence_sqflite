class AbsensiModel {
  final int? id;
  final String hari;
  final String tanggal;
  final String jamMasuk;
  final String latitude;
  final String longitude;
  final String? jamPulang;

  AbsensiModel({
    this.id,
    required this.hari,
    required this.tanggal,
    required this.jamMasuk,
    required this.latitude,
    required this.longitude,
    this.jamPulang,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hari': hari,
      'tanggal': tanggal,
      'jamMasuk': jamMasuk,
      'latitude': latitude,
      'longitude': longitude,
      'jamPulang': jamPulang,
    };
  }

  factory AbsensiModel.fromMap(Map<String, dynamic> map) {
    return AbsensiModel(
      id: map['id'],
      hari: map['hari'],
      tanggal: map['tanggal'],
      jamMasuk: map['jamMasuk'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      jamPulang: map['jamPulang'],
    );
  }
}
