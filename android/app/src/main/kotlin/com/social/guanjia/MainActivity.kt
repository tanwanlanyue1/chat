package com.social.guanjia
import PluginUtil
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.io.File
import java.util.Date
import android.os.Bundle

class MainActivity: FlutterActivity(){

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        PluginUtil().register(this, flutterEngine)
    }
}
