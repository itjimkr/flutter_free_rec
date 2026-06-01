package com.example.rec

import android.Manifest
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.content.pm.PackageManager
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.Settings
import android.util.DisplayMetrics
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.math.max
import org.json.JSONArray

class MainActivity : FlutterActivity() {
    private companion object {
        private const val PERMISSIONS_PREFERENCES = "rec.permissions"
        private const val APP_PREFERENCES = "rec.app"
        private const val KEY_MICROPHONE_REQUESTED = "microphone_requested"
        private const val KEY_APP_LOCALE = "locale_key"
        private const val KEY_AUTO_REFRESH_ENABLED = "auto_refresh_enabled"
        private const val KEY_AUTO_REFRESH_SECONDS = "auto_refresh_seconds"
        private const val KEY_COUNTDOWN_SECONDS = "countdown_seconds"
        private const val KEY_RECENT_RECORDINGS_JSON = "recent_recordings_json"
        private const val KEY_SHORTCUT_RECORD_APPLICATION = "shortcut_record_application"
        private const val KEY_SHORTCUT_RECORD_FULL_SCREEN = "shortcut_record_full_screen"
        private const val KEY_SHORTCUT_RECORD_AREA = "shortcut_record_area"
        private const val KEY_SHORTCUT_PAUSE_RESUME = "shortcut_pause_resume"
        private const val KEY_SHORTCUT_STOP = "shortcut_stop"
        private const val KEY_SHORTCUT_OPEN_SETTINGS = "shortcut_open_settings"
        private const val KEY_SHORTCUT_OPEN_SAVED_FOLDER = "shortcut_open_saved_folder"
        private const val REQUEST_MICROPHONE_PERMISSION = 7_001
        private const val REQUEST_MEDIA_PROJECTION = 7_002
    }

    private enum class RecordingState(val rawValue: String) {
        IDLE("idle"),
        RECORDING("recording"),
        STOPPING("stopping"),
    }

    private enum class PendingAction {
        REQUEST_PERMISSIONS,
        START_RECORDING,
    }

    private data class RecorderSettings(
        var frameRate: Int = 30,
        var videoCodec: String = "H.264",
        var containerFormat: String = "mp4",
        var videoQuality: String = "High",
        var audioCodec: String = "AAC",
        var captureSystemAudio: Boolean = false,
        var captureMicrophone: Boolean = false,
        var captureAlphaChannel: Boolean = false,
        var captureHDR: Boolean = false,
        var captureNativeResolution: Boolean = true,
        var presenterOverlayEnabled: Boolean = false,
        var selectedMicrophoneID: String? = null,
        var selectedCameraID: String? = null,
        var showCursor: Boolean = true,
        var showWallpaper: Boolean = true,
        var showMenuBar: Boolean = true,
        var showDock: Boolean = true,
        var showRecorderUI: Boolean = false,
        var showWindowShadows: Boolean = true,
    ) {
        fun apply(arguments: Map<*, *>) {
            (arguments["frameRate"] as? Number)?.toInt()?.let { frameRate = it }
            (arguments["videoCodec"] as? String)?.let { videoCodec = it }
            (arguments["containerFormat"] as? String)?.let {
                containerFormat = if (it.equals("mov", ignoreCase = true)) "mp4" else it.lowercase(Locale.US)
            }
            (arguments["videoQuality"] as? String)?.let { videoQuality = it }
            (arguments["audioCodec"] as? String)?.let { audioCodec = it }
            (arguments["captureSystemAudio"] as? Boolean)?.let { captureSystemAudio = false }
            (arguments["captureMicrophone"] as? Boolean)?.let { captureMicrophone = it }
            (arguments["captureAlphaChannel"] as? Boolean)?.let { captureAlphaChannel = false }
            (arguments["captureHDR"] as? Boolean)?.let { captureHDR = false }
            (arguments["captureNativeResolution"] as? Boolean)?.let { captureNativeResolution = it }
            (arguments["presenterOverlayEnabled"] as? Boolean)?.let { presenterOverlayEnabled = false }
            if (arguments.containsKey("selectedMicrophoneID")) {
                selectedMicrophoneID = arguments["selectedMicrophoneID"] as? String
            }
            if (arguments.containsKey("selectedCameraID")) {
                selectedCameraID = arguments["selectedCameraID"] as? String
            }
            (arguments["showCursor"] as? Boolean)?.let { showCursor = it }
            (arguments["showWallpaper"] as? Boolean)?.let { showWallpaper = it }
            (arguments["showMenuBar"] as? Boolean)?.let { showMenuBar = it }
            (arguments["showDock"] as? Boolean)?.let { showDock = it }
            (arguments["showRecorderUI"] as? Boolean)?.let { showRecorderUI = false }
            (arguments["showWindowShadows"] as? Boolean)?.let { showWindowShadows = false }
        }

        fun toMap(outputDirectory: String): Map<String, Any?> = mapOf(
            "frameRate" to normalizedFrameRate(),
            "videoCodec" to "H.264",
            "containerFormat" to "mp4",
            "videoQuality" to videoQuality,
            "audioCodec" to "AAC",
            "captureSystemAudio" to false,
            "captureMicrophone" to captureMicrophone,
            "captureAlphaChannel" to false,
            "captureHDR" to false,
            "captureNativeResolution" to captureNativeResolution,
            "presenterOverlayEnabled" to false,
            "selectedMicrophoneID" to selectedMicrophoneID,
            "selectedCameraID" to null,
            "showCursor" to showCursor,
            "showWallpaper" to showWallpaper,
            "showMenuBar" to showMenuBar,
            "showDock" to showDock,
            "showRecorderUI" to false,
            "showWindowShadows" to false,
            "outputDirectory" to outputDirectory,
        )

        fun normalizedFrameRate(): Int = when {
            frameRate >= 60 -> 60
            frameRate >= 30 -> 30
            frameRate >= 24 -> 24
            else -> 30
        }
    }

    private lateinit var methodChannel: MethodChannel
    private var settings = RecorderSettings()
    private var state = RecordingState.IDLE
    private var recordingStartedAtMs: Long? = null
    private var pendingAction: PendingAction? = null
    private var pendingResult: MethodChannel.Result? = null
    private var mediaProjectionManager: MediaProjectionManager? = null
    private var mediaProjection: MediaProjection? = null
    private var mediaRecorder: MediaRecorder? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var currentOutputFile: File? = null
    private var lastSavedRecordingPath: String? = null
    private var lastErrorMessage: String? = null

    private val mediaProjectionCallback = object : MediaProjection.Callback() {
        override fun onStop() {
            runOnUiThread {
                if (state == RecordingState.RECORDING) {
                    lastErrorMessage = getString(R.string.screen_capture_permission_revoked)
                    cleanupRecorder(stopProjection = false, deleteOutput = false)
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mediaProjectionManager =
            getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "rec/platform")
        methodChannel.setMethodCallHandler(::onMethodCall)
    }

    override fun onDestroy() {
        cleanupRecorder(stopProjection = true, deleteOutput = false)
        super.onDestroy()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != REQUEST_MICROPHONE_PERMISSION) {
            return
        }

        val action = pendingAction
        val result = pendingResult
        if (action == null || result == null) {
            clearPendingState()
            return
        }

        val granted =
            grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
        if (!granted && settings.captureMicrophone) {
            clearPendingState()
            if (action == PendingAction.REQUEST_PERMISSIONS) {
                result.success(buildSnapshot())
            } else {
                result.error(
                    "microphone_permission_denied",
                    getString(R.string.microphone_permission_required),
                    null,
                )
            }
            return
        }

        when (action) {
            PendingAction.REQUEST_PERMISSIONS -> {
                clearPendingState()
                result.success(buildSnapshot())
            }
            PendingAction.START_RECORDING -> launchProjectionConsent()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != REQUEST_MEDIA_PROJECTION) {
            return
        }

        val callback = pendingResult
        if (callback == null || pendingAction != PendingAction.START_RECORDING) {
            clearPendingState()
            return
        }

        if (resultCode != Activity.RESULT_OK || data == null) {
            clearPendingState()
            callback.error(
                "screen_capture_denied",
                getString(R.string.screen_capture_permission_denied),
                null,
            )
            return
        }

        try {
            startProjectionRecording(resultCode, data)
            clearPendingState()
            callback.success(buildSnapshot())
        } catch (error: Exception) {
            clearPendingState()
            callback.error(
                "recording_start_failed",
                error.message ?: getString(R.string.recording_start_failed),
                null,
            )
        }
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "snapshot" -> result.success(buildSnapshot())
            "loadAppPreferences" -> result.success(loadAppPreferences())
            "saveAppPreferences" -> {
                saveAppPreferences(call.arguments as? Map<*, *>)
                result.success(null)
            }
            "requestPermissions" -> handleRequestPermissions(result)
            "presentPicker" -> result.success(buildSnapshot())
            "clearSelection" -> result.success(buildSnapshot())
            "updateSettings" -> {
                (call.arguments as? Map<*, *>)?.let(settings::apply)
                result.success(buildSnapshot())
            }
            "startRecording" -> {
                (call.arguments as? Map<*, *>)?.let(settings::apply)
                handleStartRecording(result)
            }
            "stopRecording" -> handleStopRecording(result)
            "pauseRecording" -> result.success(buildSnapshot())
            "resumeRecording" -> result.success(buildSnapshot())
            "chooseOutputDirectory" -> result.success(buildSnapshot())
            "openOutputFolder" -> result.success(buildSnapshot())
            "revealRecording" -> result.success(buildSnapshot())
            "openScreenRecordingSettings" -> {
                openAppDetailsSettings()
                result.success(buildSnapshot())
            }
            "openMicrophoneSettings" -> {
                openAppDetailsSettings()
                result.success(buildSnapshot())
            }
            else -> result.notImplemented()
        }
    }

    private fun loadAppPreferences(): Map<String, Any> {
        val preferences = getSharedPreferences(APP_PREFERENCES, Context.MODE_PRIVATE)
        val values = mutableMapOf<String, Any>()

        if (preferences.contains(KEY_APP_LOCALE)) {
            values["localeKey"] = preferences.getString(KEY_APP_LOCALE, null) ?: "system"
        }
        if (preferences.contains(KEY_AUTO_REFRESH_ENABLED)) {
            values["autoRefreshEnabled"] = preferences.getBoolean(KEY_AUTO_REFRESH_ENABLED, true)
        }
        if (preferences.contains(KEY_AUTO_REFRESH_SECONDS)) {
            values["autoRefreshSeconds"] = preferences.getInt(KEY_AUTO_REFRESH_SECONDS, 1)
        }
        if (preferences.contains(KEY_COUNTDOWN_SECONDS)) {
            values["countdownSeconds"] = preferences.getInt(KEY_COUNTDOWN_SECONDS, 3)
        }
        preferences.getString(KEY_RECENT_RECORDINGS_JSON, null)?.let {
            val items = mutableListOf<String>()
            val array = JSONArray(it)
            for (index in 0 until array.length()) {
                items += array.optString(index)
            }
            values["recentRecordingPaths"] = items
        }
        preferences.getString(KEY_SHORTCUT_RECORD_APPLICATION, null)?.let {
            values["shortcutRecordApplication"] = it
        }
        preferences.getString(KEY_SHORTCUT_RECORD_FULL_SCREEN, null)?.let {
            values["shortcutRecordFullScreen"] = it
        }
        preferences.getString(KEY_SHORTCUT_RECORD_AREA, null)?.let {
            values["shortcutRecordArea"] = it
        }
        preferences.getString(KEY_SHORTCUT_PAUSE_RESUME, null)?.let {
            values["shortcutPauseResume"] = it
        }
        preferences.getString(KEY_SHORTCUT_STOP, null)?.let {
            values["shortcutStop"] = it
        }
        preferences.getString(KEY_SHORTCUT_OPEN_SETTINGS, null)?.let {
            values["shortcutOpenSettings"] = it
        }
        preferences.getString(KEY_SHORTCUT_OPEN_SAVED_FOLDER, null)?.let {
            values["shortcutOpenSavedFolder"] = it
        }

        return values
    }

    private fun saveAppPreferences(arguments: Map<*, *>?) {
        if (arguments == null) {
            return
        }

        val editor = getSharedPreferences(APP_PREFERENCES, Context.MODE_PRIVATE).edit()
        (arguments["localeKey"] as? String)?.let { editor.putString(KEY_APP_LOCALE, it) }
        (arguments["autoRefreshEnabled"] as? Boolean)?.let {
            editor.putBoolean(KEY_AUTO_REFRESH_ENABLED, it)
        }
        (arguments["autoRefreshSeconds"] as? Number)?.toInt()?.let {
            editor.putInt(KEY_AUTO_REFRESH_SECONDS, it)
        }
        (arguments["countdownSeconds"] as? Number)?.toInt()?.let {
            editor.putInt(KEY_COUNTDOWN_SECONDS, it)
        }
        (arguments["recentRecordingPaths"] as? List<*>)?.let { paths ->
            val array = JSONArray()
            paths.filterIsInstance<String>().forEach(array::put)
            editor.putString(KEY_RECENT_RECORDINGS_JSON, array.toString())
        }
        (arguments["shortcutRecordApplication"] as? String)?.let {
            editor.putString(KEY_SHORTCUT_RECORD_APPLICATION, it)
        }
        (arguments["shortcutRecordFullScreen"] as? String)?.let {
            editor.putString(KEY_SHORTCUT_RECORD_FULL_SCREEN, it)
        }
        (arguments["shortcutRecordArea"] as? String)?.let {
            editor.putString(KEY_SHORTCUT_RECORD_AREA, it)
        }
        (arguments["shortcutPauseResume"] as? String)?.let {
            editor.putString(KEY_SHORTCUT_PAUSE_RESUME, it)
        }
        (arguments["shortcutStop"] as? String)?.let {
            editor.putString(KEY_SHORTCUT_STOP, it)
        }
        (arguments["shortcutOpenSettings"] as? String)?.let {
            editor.putString(KEY_SHORTCUT_OPEN_SETTINGS, it)
        }
        (arguments["shortcutOpenSavedFolder"] as? String)?.let {
            editor.putString(KEY_SHORTCUT_OPEN_SAVED_FOLDER, it)
        }
        editor.apply()
    }

    private fun handleRequestPermissions(result: MethodChannel.Result) {
        if (settings.captureMicrophone && !hasMicrophonePermission()) {
            markMicrophonePermissionRequested()
            pendingAction = PendingAction.REQUEST_PERMISSIONS
            pendingResult = result
            requestPermissions(arrayOf(Manifest.permission.RECORD_AUDIO), REQUEST_MICROPHONE_PERMISSION)
            return
        }
        result.success(buildSnapshot())
    }

    private fun handleStartRecording(result: MethodChannel.Result) {
        if (state != RecordingState.IDLE) {
            result.error(
                "capture_already_running",
                getString(R.string.recording_already_running),
                null,
            )
            return
        }

        lastErrorMessage = null
        lastSavedRecordingPath = null

        if (settings.captureMicrophone && !hasMicrophonePermission()) {
            markMicrophonePermissionRequested()
            pendingAction = PendingAction.START_RECORDING
            pendingResult = result
            requestPermissions(arrayOf(Manifest.permission.RECORD_AUDIO), REQUEST_MICROPHONE_PERMISSION)
            return
        }

        pendingAction = PendingAction.START_RECORDING
        pendingResult = result
        launchProjectionConsent()
    }

    private fun handleStopRecording(result: MethodChannel.Result) {
        if (state != RecordingState.RECORDING) {
            result.error("not_recording", getString(R.string.not_recording), null)
            return
        }

        state = RecordingState.STOPPING
        val outputFile = currentOutputFile
        var deleteOutput = false

        try {
            mediaRecorder?.stop()
        } catch (error: RuntimeException) {
            deleteOutput = true
            lastErrorMessage = error.message ?: getString(R.string.recording_finalize_failed)
        }

        cleanupRecorder(stopProjection = true, deleteOutput = deleteOutput)

        if (deleteOutput || outputFile == null) {
            result.error(
                "recording_stop_failed",
                lastErrorMessage ?: getString(R.string.recording_finalize_failed),
                null,
            )
            return
        }

        lastSavedRecordingPath = outputFile.absolutePath
        val snapshot = HashMap(buildSnapshot())
        snapshot["stoppedRecordingPath"] = outputFile.absolutePath
        result.success(snapshot)
    }

    private fun launchProjectionConsent() {
        val manager = mediaProjectionManager
        val callback = pendingResult
        if (manager == null || callback == null) {
            clearPendingState()
            callback?.error(
                "projection_manager_unavailable",
                getString(R.string.projection_manager_unavailable),
                null,
            )
            return
        }

        startActivityForResult(manager.createScreenCaptureIntent(), REQUEST_MEDIA_PROJECTION)
    }

    private fun startProjectionRecording(resultCode: Int, data: Intent) {
        val manager = mediaProjectionManager
            ?: throw IllegalStateException(getString(R.string.projection_manager_unavailable))
        val metrics = currentDisplayMetrics()
        val outputFile = createOutputFile()
        val recorder = createMediaRecorder(metrics, outputFile)
        RecorderForegroundService.start(this, settings.captureMicrophone)
        val projection =
            manager.getMediaProjection(resultCode, data)
                ?: throw IllegalStateException(getString(R.string.projection_acquire_failed))

        try {
            projection.registerCallback(mediaProjectionCallback, null)
            val display =
                projection.createVirtualDisplay(
                    "RecCapture",
                    metrics.widthPixels,
                    metrics.heightPixels,
                    metrics.densityDpi,
                    DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                    recorder.surface,
                    null,
                    null,
                ) ?: throw IllegalStateException(getString(R.string.virtual_display_failed))

            recorder.start()
            mediaProjection = projection
            mediaRecorder = recorder
            virtualDisplay = display
            currentOutputFile = outputFile
            recordingStartedAtMs = System.currentTimeMillis()
            state = RecordingState.RECORDING
        } catch (error: Exception) {
            try {
                recorder.reset()
            } catch (_: Exception) {
            }
            recorder.release()
            projection.unregisterCallback(mediaProjectionCallback)
            projection.stop()
            RecorderForegroundService.stop(this)
            outputFile.delete()
            lastErrorMessage = error.message ?: getString(R.string.recording_start_failed)
            state = RecordingState.IDLE
            throw error
        }
    }

    private fun createMediaRecorder(metrics: DisplayMetrics, outputFile: File): MediaRecorder {
        val recorder =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                MediaRecorder(this)
            } else {
                @Suppress("DEPRECATION")
                MediaRecorder()
            }

        val width = max(2, metrics.widthPixels and 1.inv())
        val height = max(2, metrics.heightPixels and 1.inv())
        val frameRate = settings.normalizedFrameRate()

        if (settings.captureMicrophone) {
            recorder.setAudioSource(MediaRecorder.AudioSource.MIC)
        }
        recorder.setVideoSource(MediaRecorder.VideoSource.SURFACE)
        recorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        recorder.setOutputFile(outputFile.absolutePath)
        recorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264)
        recorder.setVideoSize(width, height)
        recorder.setVideoFrameRate(frameRate)
        recorder.setVideoEncodingBitRate(estimatedBitRate(width, height, frameRate))

        if (settings.captureMicrophone) {
            recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            recorder.setAudioEncodingBitRate(128_000)
            recorder.setAudioSamplingRate(44_100)
        }

        recorder.prepare()
        return recorder
    }

    @Suppress("DEPRECATION")
    private fun currentDisplayMetrics(): DisplayMetrics {
        val metrics = DisplayMetrics()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val bounds = windowManager.currentWindowMetrics.bounds
            metrics.widthPixels = bounds.width()
            metrics.heightPixels = bounds.height()
            metrics.densityDpi = resources.displayMetrics.densityDpi
        } else {
            windowManager.defaultDisplay.getRealMetrics(metrics)
        }
        return metrics
    }

    private fun estimatedBitRate(width: Int, height: Int, frameRate: Int): Int {
        val multiplier =
            when (settings.videoQuality.lowercase(Locale.US)) {
                "low" -> 3
                "medium" -> 5
                else -> 8
            }
        return max(4_000_000, width * height * frameRate * multiplier / 8)
    }

    private fun createOutputFile(): File {
        val directory =
            getExternalFilesDir(Environment.DIRECTORY_MOVIES)
                ?: File(filesDir, "recordings")
        if (!directory.exists()) {
            directory.mkdirs()
        }
        val formatter = SimpleDateFormat("yyyy-MM-dd-HHmmss", Locale.US)
        return File(directory, "Rec-${formatter.format(Date())}.mp4")
    }

    private fun cleanupRecorder(stopProjection: Boolean, deleteOutput: Boolean) {
        RecorderForegroundService.stop(this)

        try {
            virtualDisplay?.release()
        } catch (_: Exception) {
        }
        virtualDisplay = null

        try {
            mediaRecorder?.reset()
        } catch (_: Exception) {
        }
        try {
            mediaRecorder?.release()
        } catch (_: Exception) {
        }
        mediaRecorder = null

        if (stopProjection) {
            try {
                mediaProjection?.unregisterCallback(mediaProjectionCallback)
            } catch (_: Exception) {
            }
            try {
                mediaProjection?.stop()
            } catch (_: Exception) {
            }
        }
        mediaProjection = null

        if (deleteOutput) {
            currentOutputFile?.delete()
        }

        currentOutputFile = null
        recordingStartedAtMs = null
        state = RecordingState.IDLE
    }

    private fun clearPendingState() {
        pendingAction = null
        pendingResult = null
    }

    private fun hasMicrophonePermission(): Boolean =
        ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.RECORD_AUDIO,
        ) == PackageManager.PERMISSION_GRANTED

    private fun markMicrophonePermissionRequested() {
        getSharedPreferences(PERMISSIONS_PREFERENCES, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(KEY_MICROPHONE_REQUESTED, true)
            .apply()
    }

    private fun hasRequestedMicrophonePermission(): Boolean =
        getSharedPreferences(PERMISSIONS_PREFERENCES, Context.MODE_PRIVATE)
            .getBoolean(KEY_MICROPHONE_REQUESTED, false)

    private fun microphonePermissionState(): String {
        if (hasMicrophonePermission()) {
            return "granted"
        }

        val requestedBefore = hasRequestedMicrophonePermission()
        val shouldShowRationale =
            ActivityCompat.shouldShowRequestPermissionRationale(
                this,
                Manifest.permission.RECORD_AUDIO,
            )
        return if (requestedBefore && !shouldShowRationale) "denied" else "prompt"
    }

    private fun openAppDetailsSettings() {
        val intent =
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.fromParts("package", packageName, null)
            }
        try {
            startActivity(intent)
        } catch (_: ActivityNotFoundException) {
        }
    }

    private fun buildSnapshot(): Map<String, Any?> {
        val outputDirectory =
            (getExternalFilesDir(Environment.DIRECTORY_MOVIES) ?: File(filesDir, "recordings"))
                .absolutePath
        return mapOf(
            "platform" to "android",
            "state" to state.rawValue,
            "canStartRecording" to (state == RecordingState.IDLE && pendingAction == null),
            "hasContentSelected" to true,
            "isRecording" to (state == RecordingState.RECORDING),
            "formattedDuration" to formattedDuration(),
            "recordingDuration" to recordingDurationSeconds(),
            "presenterOverlayActive" to false,
            "permissions" to mapOf(
                "screenRecording" to "prompt-on-start",
                "microphone" to microphonePermissionState(),
            ),
            "settings" to settings.toMap(outputDirectory),
            "capabilities" to mapOf(
                "contentPicker" to false,
                "areaSelection" to false,
                "presenterOverlay" to false,
                "systemAudio" to false,
                "microphone" to true,
                "pauseResume" to false,
                "hdr" to false,
                "alpha" to false,
                "windowFiltering" to false,
            ),
            "audioDevices" to emptyList<Map<String, Any?>>(),
            "cameraDevices" to emptyList<Map<String, Any?>>(),
            "note" to getString(R.string.android_note),
            "lastSavedRecordingPath" to lastSavedRecordingPath,
            "lastErrorMessage" to lastErrorMessage,
        )
    }

    private fun recordingDurationSeconds(): Double {
        val startedAt = recordingStartedAtMs ?: return 0.0
        return max(0L, System.currentTimeMillis() - startedAt).toDouble() / 1000.0
    }

    private fun formattedDuration(): String {
        val totalSeconds = recordingDurationSeconds().toInt()
        val minutes = totalSeconds / 60
        val seconds = totalSeconds % 60
        return String.format(Locale.US, "%02d:%02d", minutes, seconds)
    }
}
