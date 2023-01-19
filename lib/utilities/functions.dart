import 'dart:io';

String isConnected = "false";
Future<String> checkNetwork() async {
  try {
    final result = await InternetAddress.lookup('www.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // print('connected');
      isConnected = "true";
    }
  } on SocketException catch (_) {
    // print('not connected');
    isConnected = "false";
  }
  return isConnected;
}
