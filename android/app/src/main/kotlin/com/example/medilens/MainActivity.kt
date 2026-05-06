package com.example.medilens

import android.telephony.SmsManager
import android.os.Build
import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity : FlutterActivity() {

    private val SMS_CHANNEL = "com.example.medilens/sms"
    private val TTS_CHANNEL = "com.example.medilens/tts_notification"
    
    private var tts: TextToSpeech? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // SMS Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val phone = call.argument<String>("phone")
                val message = call.argument<String>("message")

                if (phone == null || message == null) {
                    result.error("INVALID_ARGS", "phone and message are required", null)
                    return@setMethodCallHandler
                }

                try {
                    val smsManager: SmsManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        applicationContext.getSystemService(SmsManager::class.java)
                    } else {
                        @Suppress("DEPRECATION")
                        SmsManager.getDefault()
                    }

                    val parts = smsManager.divideMessage(message)
                    if (parts.size == 1) {
                        smsManager.sendTextMessage(phone, null, message, null, null)
                    } else {
                        smsManager.sendMultipartTextMessage(phone, null, parts, null, null)
                    }

                    result.success("SMS sent")
                } catch (e: Exception) {
                    result.error("SMS_FAILED", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }

        // TTS Channel for notifications
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TTS_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "speak") {
                val text = call.argument<String>("text")
                val language = call.argument<String>("language") ?: "en-IN"

                if (text == null) {
                    result.error("INVALID_ARGS", "text is required", null)
                    return@setMethodCallHandler
                }

                if (tts == null) {
                    tts = TextToSpeech(applicationContext) { status ->
                        if (status == TextToSpeech.SUCCESS) {
                            speakText(text, language)
                            result.success("Speaking")
                        } else {
                            result.error("TTS_INIT_FAILED", "TTS initialization failed", null)
                        }
                    }
                } else {
                    speakText(text, language)
                    result.success("Speaking")
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun speakText(text: String, languageCode: String) {
        val locale = when (languageCode) {
            "te-IN" -> Locale("te", "IN")
            "hi-IN" -> Locale("hi", "IN")
            "ta-IN" -> Locale("ta", "IN")
            else -> Locale("en", "IN")
        }
        tts?.language = locale
        tts?.speak(text, TextToSpeech.QUEUE_ADD, null, null)
    }

    override fun onDestroy() {
        tts?.stop()
        tts?.shutdown()
        super.onDestroy()
    }
}
