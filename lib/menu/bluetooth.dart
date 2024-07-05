import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../main.dart';

class BluetoothPage extends StatefulWidget {
  final ValueNotifier<bool> isConnectedNotifier;
  BluetoothPage({required this.isConnectedNotifier});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  List<BluetoothDevice> devices = [];
  StreamSubscription<BluetoothAdapterState>? _stateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  BluetoothDevice? connectedDevice;
  bool _isScanning = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _isConnected = widget.isConnectedNotifier.value;
    loadConnectedDevice();
    initializeBluetooth();
  }

  Future<void> initializeBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    if (await Permission.bluetooth.isDenied || await Permission.location.isDenied) {
      var status = await [
        Permission.bluetooth,
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

      if (status[Permission.bluetooth] != PermissionStatus.granted ||
          status[Permission.location] != PermissionStatus.granted ||
          status[Permission.bluetoothScan] != PermissionStatus.granted ||
          status[Permission.bluetoothConnect] != PermissionStatus.granted) {
        print("Permissions not granted");
        return;
      }
    }

    _stateSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state != BluetoothAdapterState.on) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Bluetooth Error"),
            content: Text("Bluetooth is not enabled. Please enable Bluetooth."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    });

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  void startScanning() async {
    setState(() {
      devices.clear();
      _isScanning = true;
    });

    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

    await FlutterBluePlus.startScan(
      withServices: [Guid("180D")],
      withNames: ["Transsibi"],
      timeout: Duration(seconds: 2), // Kurangi durasi pemindaian
    );

    _scanResultsSubscription = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        ScanResult r = results.last;
        print('${r.device.remoteId}: "${r.advertisementData.localName}" found!');
        if (!devices.contains(r.device)) {
          setState(() {
            devices.add(r.device);
          });
        }
      }
    }, onError: (e) => print(e));

    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    setState(() {
      _isScanning = false;
    });

    FlutterBluePlus.cancelWhenScanComplete(_scanResultsSubscription!);
  }

  void connectToDevice(BluetoothDevice device) async {
    _connectionSubscription = device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        print("Device disconnected");
        setState(() {
          _isConnected = false;
          connectedDevice = null;
          widget.isConnectedNotifier.value = false;
        });
        await saveConnectedDevice(null);
      }
    });

    device.cancelWhenDisconnected(_connectionSubscription!, delayed: true, next: true);

    await device.connect();
    setState(() {
      _isConnected = true;
      connectedDevice = device;
      widget.isConnectedNotifier.value = true;
    });
    await saveConnectedDevice(device);
  }

  void disconnectFromDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      setState(() {
        _isConnected = false;
        connectedDevice = null;
        widget.isConnectedNotifier.value = false;
      });
      _connectionSubscription?.cancel();
      await saveConnectedDevice(null);
    }
  }

  Future<void> saveConnectedDevice(BluetoothDevice? device) async {
    final prefs = await SharedPreferences.getInstance();
    if (device == null) {
      await prefs.remove('connectedDeviceId');
      await prefs.remove('connectedDeviceName');
    } else {
      await prefs.setString('connectedDeviceId', device.remoteId.toString());
      await prefs.setString('connectedDeviceName', device.name ?? device.localName ?? 'Unknown Device');
    }
  }

  Future<void> loadConnectedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('connectedDeviceId');
    final deviceName = prefs.getString('connectedDeviceName');

    if (deviceId != null && deviceName != null) {
      setState(() {
        connectedDevice = BluetoothDevice(
          remoteId: DeviceIdentifier(deviceId),
        );
        _isConnected = true;
        widget.isConnectedNotifier.value = true;
      });
    }
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    _stateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("isConnected: $_isConnected");
    return BasePage(
      isConnectedNotifier: widget.isConnectedNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Devices'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                startScanning();
              },
            ),
          ],
        ),
        body: Center(
          child: _isConnected && connectedDevice != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth_connected, size: 80, color: Colors.blue),
                    SizedBox(height: 16),
                    Text("Terhubung dengan"),
                    SizedBox(height: 8),
                    Text(connectedDevice!.localName ?? 'Unknown Device', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        disconnectFromDevice();
                      },
                      child: Text(
                        'Putuskan',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                )
              : _isScanning
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Mencari perangkat terdekat ..."),
                      ],
                    )
                  : devices.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bluetooth_disabled, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text("Tidak ada perangkat ditemukan"),
                          ],
                        )
                      : ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.bluetooth, color: Color.fromRGBO(5, 10, 48, 1)),
                              title: Text(devices[index].name ?? devices[index].localName ?? 'Unknown Device'),
                              subtitle: Text(devices[index].remoteId.toString()),
                              trailing: TextButton(
                                onPressed: () {
                                  if (_isConnected && connectedDevice == devices[index]) {
                                    disconnectFromDevice();
                                  } else {
                                    connectToDevice(devices[index]);
                                  }
                                },
                                child: Text(
                                  _isConnected && connectedDevice == devices[index] ? 'Putuskan' : 'Hubungkan',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: _isConnected && connectedDevice == devices[index] ? Colors.red : Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
