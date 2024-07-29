
import android.app.Activity
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference

/**
 * 个推扩展插件
 */
class GetuiPlugin : MethodChannel.MethodCallHandler {

    companion object{
        private const val CHANNEL = "com.aimiyou.jingxiu/getui"
    }

    private var activityRef: WeakReference<Activity>? = null
    private var methodChannel: MethodChannel? = null
    private var launchNotificationPayload = mutableMapOf<String, String>()

    /**
     * 注册插件
     * @param activity
     * @param flutterEngine
     */
    fun register(activity: Activity, flutterEngine: FlutterEngine) {
        if (activityRef == null) {
            activityRef = WeakReference(activity)
            methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
                setMethodCallHandler(this@GetuiPlugin)
            }
            onNewIntent(activity.intent)
        }
    }

    fun onNewIntent(intent: Intent) {
        val lc = intent.getStringExtra("lc") ?: ""
        val lt = intent.getStringExtra("lt") ?: ""
        if (lc.isNotEmpty() || lt.isNotEmpty()){
            //payload 携带数据: lc=yy;lt=1,MF-1,2433386;
            launchNotificationPayload["payload"] = "lc=${lc};lt=${lt}"
            methodChannel?.invokeMethod("onLaunchNotification", launchNotificationPayload)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if("getLaunchNotification" == call.method){
            result.success(launchNotificationPayload)
        }else{
            result.notImplemented()
        }
    }

}
