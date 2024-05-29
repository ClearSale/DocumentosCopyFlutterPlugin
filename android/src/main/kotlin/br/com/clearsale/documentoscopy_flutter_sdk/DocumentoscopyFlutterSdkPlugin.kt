package br.com.clearsale.documentoscopy_flutter_sdk

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.util.Log
import com.clear.studio.csdocs.entries.CSDocumentoscopy
import com.clear.studio.csdocs.entries.CSDocumentoscopySDK
import com.clear.studio.csdocs.entries.CSDocumentoscopySDKColorsConfig
import com.clear.studio.csdocs.entries.CSDocumentoscopySDKConfig
import com.clear.studio.csdocs.entries.CSDocumentoscopySDKError
import com.clear.studio.csdocs.entries.CSDocumentoscopySDKListener
import com.clear.studio.csdocs.entries.CSDocumentoscopySDKResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DocumentoscopyFlutterSdkPlugin */
class DocumentoscopyFlutterSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private var context: Context? = null

  private var logTag = "[CSDocumentosCopy]"

  var flutterResult: Result? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "documentoscopy_flutter_sdk")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "openCSDocumentosCopy") {
      openCSDocumentosCopy(call, result)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  private fun resetResult() {
    flutterResult = null;
  }

  private fun openCSDocumentosCopy(call: MethodCall, result: Result) {
    if (flutterResult !== null) {
      // Means that we are already running and somehow the button got triggered again.
      // In this case just return.

      return;
    }

    try {
      flutterResult = result;

      val clientId = call.argument<String>("clientId")
      val clientSecretId = call.argument<String>("clientSecretId")
      val identifierId = call.argument<String>("identifierId")
      val cpf = call.argument<String>("cpf")
      val primaryColor = call.argument<String>("primaryColor")
      val secondaryColor = call.argument<String>("secondaryColor")
      val tertiaryColor = call.argument<String>("tertiaryColor")
      val titleColor = call.argument<String>("titleColor")
      val paragraphColor = call.argument<String>("paragraphColor")

      // Now validate
      if (clientId.isNullOrBlank()) throw Exception("clientId is required")
      if (clientSecretId.isNullOrBlank()) throw Exception("clientSecretId is required")
      if (identifierId.isNullOrBlank()) throw Exception("identifierId is required")
      if (cpf.isNullOrBlank()) throw Exception("cpf is required")


      val sdkConfig = CSDocumentoscopySDKConfig(
        colors = CSDocumentoscopySDKColorsConfig(
          primaryColor = if (!primaryColor.isNullOrBlank()) Color.parseColor(primaryColor) else null,
          secondaryColor = if (!secondaryColor.isNullOrBlank()) Color.parseColor(secondaryColor) else null,
          tertiaryColor = if (!tertiaryColor.isNullOrBlank()) Color.parseColor(tertiaryColor) else null,
          titleColor = if (!titleColor.isNullOrBlank()) Color.parseColor(titleColor) else null,
          paragraphColor = if (!paragraphColor.isNullOrBlank()) Color.parseColor(paragraphColor) else null
        )
      )
      val csDocumentosCopyConfig = CSDocumentoscopy(clientId, clientSecretId, identifierId, cpf, sdkConfig)
      val listener = object: CSDocumentoscopySDKListener {
        override fun didFinishCapture(result: CSDocumentoscopySDKResult) {
          Log.d(logTag, "Called didFinishCapture");

          val responseMap = HashMap<String, String?>()
          responseMap["documentType"] = result.documentType?.toString()
          responseMap["sessionId"] = result.sessionId

          Log.d(logTag, "Result is $responseMap")

          flutterResult!!.success(responseMap)
          resetResult()
        }

        override fun didOpen() {
          // Nothing to do here.
          Log.d(logTag, "Called didOpen");
        }

        override fun didReceiveError(error: CSDocumentoscopySDKError) {
          Log.e(logTag, "Called didReceiveError", null);

          flutterResult!!.error(error.errorCode.toString(), error.text, null)
          resetResult()
        }

        override fun didTapClose() {
          Log.d(logTag, "Called didTapClose");

          result.error("UserCancel", "UserCancel", null)
          resetResult()
        }
      }

      if (activity?.application != null) {
        CSDocumentoscopySDK.initialize(activity!!.application, csDocumentosCopyConfig, listener)
      } else {
        throw Exception("Missing application from current activity")
      }
    } catch (t: Throwable) {
      Log.e(logTag, "Error starting CSDocumentosCopySDK", t)
      result.error("SDKError", "Failed to start CSDocumentosCopySDK", t)

      resetResult()
    }
  }
}
