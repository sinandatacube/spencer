import 'package:permission_handler/permission_handler.dart';

Future requestCameraPermission() async {
  // final serviceStatus = await Permission.camera.isGranted;

  // bool isCameraOn = serviceStatus == ServiceStatus.enabled;

  final status = await Permission.camera.request();

  if (status == PermissionStatus.granted) {
    // print('Permission Granted');
    return "granted";
  } else if (status == PermissionStatus.denied) {
    // print('Permission denied');
    return "denied";
  } else if (status == PermissionStatus.permanentlyDenied) {
    // print('Permission Permanently Denied');
    // await openAppSettings();
    return "permanently denied";
  }
}
