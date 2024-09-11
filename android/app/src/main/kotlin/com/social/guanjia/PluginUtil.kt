import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import com.social.guanjia.BuildConfig
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.io.File
import java.lang.ref.WeakReference
import android.util.Log
import android.os.Bundle


/**
 * 通用插件
 */
class PluginUtil : MethodCallHandler {
    private var activityRef: WeakReference<Activity?>? = null
    private var methodChannel: MethodChannel? = null

    /**
     * 注册插件
     * @param activity
     * @param flutterEngine
     */
    fun register(activity: Activity, flutterEngine: FlutterEngine) {
        if (activityRef == null) {
            activityRef = WeakReference(activity)
            methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
                setMethodCallHandler(this@PluginUtil)
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (activityRef!!.get() == null) {
            result.error("-1", "activity not found", null)
            return
        }
        if (call.method.equals("installApk")) {
            installApk(call, result)
        } else if (call.method.equals("getDeviceId")) {
            getDeviceId(call, result)
        } else if (call.method.equals("getAppLaunchOptions")) {
            getAppLaunchOptions(call, result)
        } else {
            result.notImplemented()
        }
    }

    private fun installApk(call: MethodCall, result: MethodChannel.Result) {
        try {
            val file = File(call.arguments as String)
            val intent = Intent(Intent.ACTION_VIEW)
            val apkUri: Uri
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                apkUri = FileProvider.getUriForFile(
                    activityRef!!.get()!!,
                    BuildConfig.APPLICATION_ID + ".cache.fileProvider",
                    file
                )
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            } else {
                apkUri = Uri.fromFile(file)
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent.setDataAndType(apkUri, "application/vnd.android.package-archive")
            activityRef!!.get()!!.startActivity(intent)
            result.success(true)
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("-1", ex.message, null)
        }
    }

    private fun getDeviceId(call: MethodCall, result: MethodChannel.Result){
        val applicationContext = activityRef?.get()?.applicationContext
        if(applicationContext != null){
            val androidId = Settings.Secure.getString(applicationContext.contentResolver, Settings.Secure.ANDROID_ID)
            result.success(androidId)
        }else{
            result.error("0","applicationContext is null, cannot get device id", null)
        }
    }

    private fun getAppLaunchOptions(call: MethodCall, result: MethodChannel.Result){
        val extras = activityRef?.get()?.intent?.extras
        val launchOptions = mutableMapOf<String, Any>()
        extras?.keySet()?.forEach { key ->
            try {
                val value = extras?.get(key)
                if(value != null){
                    launchOptions[key] = "$value"
                }
            }catch (ex: Exception) {
                Log.e("register", "activity.intent.extras exception.", ex)
            }
        }

        result.success(launchOptions)
    }

    companion object {
        private const val CHANNEL = "com.social.guanjia/plugin"
    }
}
