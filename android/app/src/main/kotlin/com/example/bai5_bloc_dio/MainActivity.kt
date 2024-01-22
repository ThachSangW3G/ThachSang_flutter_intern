package com.example.bai5_bloc_dio

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val BATTERY_CHANNEL = "battery_channel"
    private val BATTERY_STATUS_EVENT = "batteryStatusEvent"
    private val DEVICE_INFO_CHANNEL = "deviceInfoChannel"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL)
                .setMethodCallHandler{ call, result ->
                    if(call.method == "getBatteryLevel"){
                        val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1){
                        result.success(batteryLevel)
                    }else{
                        result.error("UNAVAILABLE", "Battery level not available.", null);
                    }
                }else{
                    result.notImplemented();
                }
                }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_INFO_CHANNEL)
                .setMethodCallHandler{ call, result ->
                    if(call.method == "getDeviceInfo"){
                        val deviceInfo = getDeviceInfo()
                        result.success(deviceInfo)
                    }else {
                        result.notImplemented()
                    }
                }


        EventChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_STATUS_EVENT).setStreamHandler(
                BatteryStatusHandler(applicationContext)
        )
    }

    private fun getDeviceInfo(): String {
        val deviceManufacturer = Build.MANUFACTURER
        val deviceModel = Build.MODEL
        val androidVersion = Build.VERSION.RELEASE

        return "$deviceManufacturer $deviceModel (Android $androidVersion)"
    }

    private fun getBatteryLevel(): Int {
        var batteryLevel = -1
        batteryLevel = if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }


    class BatteryStatusHandler(private val context: Context) : EventChannel.StreamHandler {
        private val handler = Handler(Looper.getMainLooper())

        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
            eventSink = sink

            // Listen for battery status updates
            val batteryStatusRunnable = object : Runnable {
                override fun run() {
                    val batteryStatus = getBatteryStatus()
                    eventSink?.success(batteryStatus)
                    handler.postDelayed(this, 1000)
                }
            }

            handler.postDelayed(batteryStatusRunnable, 1000)
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        private fun getBatteryStatus(): Map<String, Any> {
            val batteryStatus = HashMap<String, Any>()

            val batteryIntent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val level = batteryIntent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val scale = batteryIntent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1

            val batteryPct = level / scale.toFloat() * 100
            batteryStatus["batteryLevel"] = batteryPct

            val status = batteryIntent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
            batteryStatus["charging"] = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                    status == BatteryManager.BATTERY_STATUS_FULL

            return batteryStatus
        }
    }
}
