import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetXState{
  BluetoothAdapterState flutterBlue = FlutterBluePlus.adapterStateNow;
  Future ScanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
        }
      }
    }
  }
  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
}