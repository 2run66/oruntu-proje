class ApiConfig {
  // For iOS simulator, localhost doesn't work, so we need to use actual IP
  // For Android emulator, 10.0.2.2 maps to host's localhost:5000
  // For real devices, use your computer's IP address

  // static const String _androidEmulatorUrl = 'http://10.0.2.2:5000';
  static const String _realDeviceUrl =
      'https://dcdc-85-105-96-169.ngrok-free.app';

  static String get baseUrl {
    // Change this based on your testing device:
    // - Use 'http://10.0.2.2:5000' for Android emulator
    // - Use _realDeviceUrl for iOS simulator or real devices
    return _realDeviceUrl; // Using real IP for broader compatibility
  }

  static String get predictEndpoint => '$baseUrl/predict';
}
