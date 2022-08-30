package com.example.newmusicplayer

import android.content.*
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val AUDIO_CHANNEL = "audio"
    private lateinit var channel: MethodChannel
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUDIO_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "getAudios") {
                val allAudios = getAudios()
                result.success(allAudios)
            }
        }
    }

    fun getAudios(): MutableList<MutableMap<String, String>> {
        var allAudios: MutableList<MutableMap<String, String>> = ArrayList()
        val selection = MediaStore.Audio.Media.IS_MUSIC + " != 0"
        val projection =
            arrayOf(
                MediaStore.Audio.Media._ID,
                MediaStore.Audio.Media.TITLE,
                MediaStore.Audio.Media.DATA,
                MediaStore.Audio.Media.ARTIST,
            )
        applicationContext.contentResolver.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            null,
            null
        )
            ?.use { cursor ->
                while (cursor.moveToNext()) {
                    var song: MutableMap<String, String> = HashMap()
                    song.putAll(setOf("id" to cursor.getString(0),"title" to cursor.getString(1),"path" to cursor.getString(2),"artist" to cursor.getString(3),))
                    allAudios.add(song)

                }

            }
        return allAudios
    }
}