import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const deviceInfoChannel = MethodChannel('deviceInfoChannel');
  static const batteryStatusChannel = EventChannel('batteryStatusEvent');

  String levelString = 'Unknown';
  bool isCharging = false;
  double batteryLevel = 0;
  String deviceInfo = 'Unknown';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    batteryStatusChannel.receiveBroadcastStream().listen((dynamic event) {
      Map<String, dynamic> batteryStatus = Map.from(event);
      setState(() {
        levelString = batteryStatus['batteryLevel'].toStringAsFixed(1) + '%';
        isCharging = batteryStatus['charging'];
        batteryLevel = batteryStatus['batteryLevel'];
      });
    });

    fetchDeviceInfo();
  }

  Future<void> fetchDeviceInfo() async {
    try {
      final String result =
          await deviceInfoChannel.invokeMethod('getDeviceInfo');
      setState(() {
        deviceInfo = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        deviceInfo = 'Error: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Device Info: $deviceInfo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Charging: ${isCharging ? 'Yes' : 'No'}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                width: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: ExactAssetImage(isCharging
                            ? 'assets/images/battery_changing.png'
                            : batteryLevel >= 0 && batteryLevel < 25
                                ? 'assets/images/battery_level_1.png'
                                : batteryLevel >= 25 && batteryLevel < 50
                                    ? 'assets/images/battery_level_2.png'
                                    : batteryLevel >= 50 && batteryLevel < 75
                                        ? 'assets/images/battery_level_3.png'
                                        : 'assets/images/battery_level_4.png'))),
              ),
              SizedBox(height: 20),
              Text(
                'Battery Level: $levelString',
                style: TextStyle(fontSize: 20),
              ),
            ]),
      ),
    );
  }
}
