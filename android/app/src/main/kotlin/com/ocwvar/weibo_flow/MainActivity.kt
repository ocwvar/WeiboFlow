package com.ocwvar.weibo_flow

import com.ocwvar.weibo_flow.json.Converter
import com.ocwvar.weibo_flow.json.Keys
import com.ocwvar.weibo_flow.weibo.WBApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL: String = "native_code_weibo_auth_api"

private const val METHOD_INIT_SDK: String = "METHOD_INIT_SDK"
private const val METHOD_AUTH_SDK: String = "METHOD_AUTH_SDK"

class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {

    // convert everything to json that flutter needed !
    private val converter: Converter = Converter()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(this)
    }

    /**
     * Handles the specified method call received from Flutter.
     *
     *
     * Handler implementations must submit a result for all incoming calls, by making a single
     * call on the given [Result] callback. Failure to do so will result in lingering Flutter
     * result handlers. The result may be submitted asynchronously and on any thread. Calls to
     * unknown or unimplemented methods should be handled using [Result.notImplemented].
     *
     *
     * Any uncaught exception thrown by this method will be caught by the channel implementation
     * and logged, and an error result will be sent back to Flutter.
     *
     *
     * The handler is called on the platform thread (Android main thread). For more details see
     * [Threading in
     * the Flutter Engine](https://github.com/flutter/engine/wiki/Threading-in-the-Flutter-Engine).
     *
     * @param call A [MethodCall].
     * @param result A [Result] used for submitting the result of the call.
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            // init weibo sdk api
            METHOD_INIT_SDK -> {
                WBApi.initWBApi(this) { success: Boolean ->
                    if (success) {
                        result.success(null);
                    } else {
                        result.error(null, null, null);
                    }
                }
            }

            // auth by user
            METHOD_AUTH_SDK -> {
                WBApi.authWEBApi(this) { success: Boolean, isCanceled: Boolean, errorMessage: String?, errorCode: Int->
                    if (success) {
                        result.success(this.converter.toTokenObject(
                            accessToken = WBApi.Status.tokenOfAccess,
                            refreshToken = WBApi.Status.tokenOfRefresh,
                            uid = WBApi.Status.uid
                        ));
                        return@authWEBApi
                    }

                    result.error(
                        "0",
                        this.converter.toObject(
                            Pair(Keys.Error.KEY_STRING_MSG, errorMessage ?: ""),
                            Pair(Keys.Error.KEY_STRING_CODE, errorCode.toString()),
                            Pair(Keys.Json.KEY_BOOL_IS_CANCELED, isCanceled),
                        ),
                        null
                    )
                }
            }
        }
    }

}
