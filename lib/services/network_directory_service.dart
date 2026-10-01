import '../models/campus_network.dart';

class NetworkDirectoryService {
  Future<List<CampusNetwork>> fetchAuthorizedNetworks() async {
    // TODO: GET from AppConstants.apiBaseUrl
    return const [
      CampusNetwork(
        ssid: 'Campus-Secure',
        building: 'Library',
        band: '5GHz',
        authType: 'WPA2-Enterprise',
      ),
    ];
  }
}