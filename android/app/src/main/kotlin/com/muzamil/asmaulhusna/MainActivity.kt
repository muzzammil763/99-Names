package com.muzamil.asmaulhusna

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.muzamil.asmaulhusna/app_actions")
            .setMethodCallHandler { call, result ->
                val url = "https://play.google.com/store/apps/details?id=com.muzamil.asmaulhusna"
                try {
                    when (call.method) {
                        "share" -> startActivity(Intent.createChooser(Intent(Intent.ACTION_SEND).apply {
                            type = "text/plain"
                            putExtra(Intent.EXTRA_TEXT, "99 Names - Asmaul Husna\n$url")
                        }, null))
                        "rate" -> {
                            try {
                                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=com.muzamil.asmaulhusna")).setPackage("com.android.vending"))
                            } catch (_: ActivityNotFoundException) {
                                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                            }
                        }
                        else -> { result.notImplemented(); return@setMethodCallHandler }
                    }
                    result.success(null)
                } catch (_: Exception) {
                    result.error("unavailable", "Could not open the requested app", null)
                }
            }
    }
}
