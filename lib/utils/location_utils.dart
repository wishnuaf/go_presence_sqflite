import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromLatLng(String lat, String lng) async {
  try {
    final latitude = double.tryParse(lat);
    final longitude = double.tryParse(lng);
    if (latitude == null || longitude == null) return 'Lokasi tidak valid';

    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    final place = placemarks.first;

    return '${place.street}, ${place.locality}, ${place.administrativeArea}';
  } catch (e) {
    return 'Alamat tidak ditemukan';
  }
}
