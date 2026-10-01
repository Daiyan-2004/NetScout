class CampusLocation {
  final String building;
  final String? floor;
  final double? latitude;
  final double? longitude;

  const CampusLocation({
    required this.building,
    this.floor,
    this.latitude,
    this.longitude,
  });
}