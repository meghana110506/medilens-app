package com.example.medilens

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.speech.tts.TextToSpeech
import android.util.Log
import java.util.*

class NotificationSpeaker : BroadcastReceiver() {
    companion object {
        const val ACTION_SPEAK = "com.example.medilens.SPEAK_NOTIFICATION"
        const val EXTRA_TEXT = "text"
        const val EXTRA_LANGUAGE = "language"
        
        private var tts: TextToSpeech? = null
        
        fun speak(context: Context, text: String, languageCode: String = "en-IN") {
            if (tts == null) {
                tts = TextToSpeech(context.applicationContext) { status ->
                    if (status == TextToSpeech.SUCCESS) {
                        val locale = when (languageCode) {
                            "te-IN" -> Locale("te", "IN")
                            "hi-IN" -> Locale("hi", "IN")
                            "ta-IN" -> Locale("ta", "IN")
                            else -> Locale("en", "IN")
                        }
                        tts?.language = locale
                        tts?.speak(text, TextToSpeech.QUEUE_ADD, null, null)
                    }
                }
            } else {
                val locale = when (languageCode) {
                    "te-IN" -> Locale("te", "IN")
                    "hi-IN" -> Locale("hi", "IN")
                    "ta-IN" -> Locale("ta", "IN")
                    else -> Locale("en", "IN")
                }
                tts?.language = locale
                tts?.speak(text, TextToSpeech.QUEUE_ADD, null, null)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_SPEAK) {
            val text = intent.getStringExtra(EXTRA_TEXT) ?: return
            val language = intent.getStringExtra(EXTRA_LANGUAGE) ?: "en-IN"
            speak(context, text, language)
            Log.d("NotificationSpeaker", "Speaking: $text in $language")
        }
    }
}
