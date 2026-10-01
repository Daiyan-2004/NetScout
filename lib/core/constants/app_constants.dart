class AppConstants {
  AppConstants._();

  static const String appName = 'NetScout';
  static const String apiBaseUrl = 'https://api.example.edu'; // TODO: real endpoint

  static const Duration httpTimeout = Duration(seconds: 10);
  static const Duration splashMinDuration = Duration(milliseconds: 2000);

  // Recommendation scoring thresholds
  static const int minRssiDbm = -100;
  static const int maxRssiDbm = -30;
  static const int maxAcceptableLatencyMs = 200;
  static const double maxExpectedThroughputMbps = 100;
}

class AuthConstants {
  AuthConstants._();

  static const String allowedEmailDomain = '@aust.edu';
  static const int minPasswordLength = 6;
  static const int resendCooldownSeconds = 60;
  static const int verifyCheckIntervalSeconds = 4;

  static const List<String> departments = [
    'CSE',
    'EEE',
    'ME',
    'IPE',
    'CE',
    'TE',
    'ARCH',
    'SoB',
  ];
}