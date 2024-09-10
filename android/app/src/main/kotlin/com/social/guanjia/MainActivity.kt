package com.social.guanjia
import PluginUtil
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.io.File
import java.util.Date
import android.os.Bundle

class MainActivity: FlutterActivity(){

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val payload = intent.getStringExtra("payload")
        val file = File(cacheDir, "log0910.txt")
        file.appendText("${Date().toLocaleString()}  payload=$payload\n")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        PluginUtil().register(this, flutterEngine)
    }
}
