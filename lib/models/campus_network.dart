class CampusNetwork {
  final String ssid;
  final String building;
  final String band; // '2.4GHz' | '5GHz' | '6GHz'
  final String authType; // 'WPA2-Enterprise', etc.

  const CampusNetwork({
    required this.ssid,
    required this.building,
    required this.band,
    required this.authType,
  });

  bool servesBuilding(String targetBuilding) => building == targetBuilding;
}