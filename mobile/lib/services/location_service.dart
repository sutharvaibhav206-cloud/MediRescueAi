import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthFacility {
  final String name;
  final String type;
  final String address;
  final double distanceKm;
  final String phone;
  final double latitude;
  final double longitude;

  HealthFacility({
    required this.name,
    required this.type,
    required this.address,
    required this.distanceKm,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return null;
    } 

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      return null;
    }
  }

  static List<HealthFacility> getNearbyFacilities(Position? currentPos) {
    // Default reference coordinates if position not available (City Center)
    final double userLat = currentPos?.latitude ?? 28.6139;
    final double userLng = currentPos?.longitude ?? 77.2090;

    final rawFacilities = [
      {
        'name': 'City General Hospital & Emergency Trauma Center',
        'type': 'Hospital & Emergency Room',
        'address': '102 Medical Enclave, Main Arterial Road',
        'lat': userLat + 0.008,
        'lng': userLng + 0.005,
        'phone': '108',
      },
      {
        'name': 'LifeCare Emergency & Critical Care Hospital',
        'type': '24x7 Emergency Hospital',
        'address': '45 Healthcare Boulevard',
        'lat': userLat - 0.012,
        'lng': userLng + 0.010,
        'phone': '112',
      },
      {
        'name': 'Red Cross Community Health Clinic',
        'type': 'Public Clinic & Urgent Care',
        'address': 'Sector 4 Community Center',
        'lat': userLat + 0.015,
        'lng': userLng - 0.007,
        'phone': '+91 11 2371 6441',
      },
      {
        'name': 'Apollo 24x7 Pharmacy & First-Aid Center',
        'type': '24x7 Pharmacy',
        'address': 'Shop 12, Central Market Complex',
        'lat': userLat - 0.005,
        'lng': userLng - 0.004,
        'phone': '+91 1800 102 0304',
      },
      {
        'name': 'St. Jude Children & General Care Hospital',
        'type': 'Specialty Emergency Hospital',
        'address': '89 Ring Road, Parkview Area',
        'lat': userLat + 0.022,
        'lng': userLng + 0.018,
        'phone': '+91 11 4000 5000',
      },
    ];

    return rawFacilities.map((fac) {
      final double facLat = fac['lat'] as double;
      final double facLng = fac['lng'] as double;
      
      double distanceInMeters = Geolocator.distanceBetween(
        userLat, userLng, facLat, facLng
      );
      double distKm = double.parse((distanceInMeters / 1000).toStringAsFixed(1));

      return HealthFacility(
        name: fac['name'] as String,
        type: fac['type'] as String,
        address: fac['address'] as String,
        distanceKm: distKm > 0 ? distKm : 1.2,
        phone: fac['phone'] as String,
        latitude: facLat,
        longitude: facLng,
      );
    }).toList()..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  static Future<void> openMapDirections(double lat, double lng, String label) async {
    final Uri url = Uri.parse("geo:$lat,$lng?q=$lat,$lng($label)");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      final Uri webUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
