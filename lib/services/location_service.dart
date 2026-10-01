import '../models/campus_location.dart';

class LocationService {
  Future<CampusLocation> getCurrentLocation() async {
    // TODO: use geolocator + a building-boundary lookup
    return const CampusLocation(building: 'Library');
  }
}