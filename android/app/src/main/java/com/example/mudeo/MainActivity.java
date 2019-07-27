package app.mudeo.mudeo;

import android.os.Bundle;
import android.os.Build;
import android.content.Context;
import android.media.AudioFormat;
import android.media.AudioTrack;
import android.media.AudioManager;
import android.media.AudioTimestamp;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.lang.reflect.Method;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "mudeo.app/calibrate";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("getDelay")) {
                            long delay = getDelay();

                            if (delay != -1) {
                                result.success(delay);
                            } else {
                                result.error("UNAVAILABLE", "Delay not available.", null);
                            }
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }

    /**
     * The audio latency has not been estimated yet
     */
    private static long AUDIO_LATENCY_NOT_ESTIMATED = Long.MIN_VALUE + 1;

    /**
     * The audio latency default value if we cannot estimate it
     */
    private static long DEFAULT_AUDIO_LATENCY = 100L * 1000L * 1000L; // 100ms

    private static long _framesToNanoSeconds(long frames) {
        return frames * 1000000000L / 16000;
    }

    private long getDelay() {
        long estimatedAudioLatency = AUDIO_LATENCY_NOT_ESTIMATED;
        long audioFramesWritten = 0;

        int outputBufferSize = AudioTrack.getMinBufferSize(16000,
                AudioFormat.CHANNEL_IN_STEREO,
                AudioFormat.ENCODING_PCM_16BIT);

        AudioTrack track = new AudioTrack(AudioManager.USE_DEFAULT_STREAM_TYPE, 16000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT, outputBufferSize, AudioTrack.MODE_STREAM);

        // First method. SDK >= 19.
        if (Build.VERSION.SDK_INT >= 19 && track != null) {

            AudioTimestamp audioTimestamp = new AudioTimestamp();
            if (track.getTimestamp(audioTimestamp)) {

                // Calculate the number of frames between our known frame and the write index
                long frameIndexDelta = audioFramesWritten - audioTimestamp.framePosition;

                // Calculate the time which the next frame will be presented
                long frameTimeDelta = _framesToNanoSeconds(frameIndexDelta);
                long nextFramePresentationTime = audioTimestamp.nanoTime + frameTimeDelta;

                // Assume that the next frame will be written at the current time
                long nextFrameWriteTime = System.nanoTime();

                // Calculate the latency
                estimatedAudioLatency = nextFramePresentationTime - nextFrameWriteTime;

            }
        }

        // Second method. SDK >= 18.
        if (estimatedAudioLatency == AUDIO_LATENCY_NOT_ESTIMATED && Build.VERSION.SDK_INT >= 18) {
            Method getLatencyMethod;
            try {
                getLatencyMethod = AudioTrack.class.getMethod("getLatency", (Class<?>[]) null);
                estimatedAudioLatency = (Integer) getLatencyMethod.invoke(track, (Object[]) null) * 1000000L;
            } catch (Exception ignored) {}
        }

        // If no method has successfully gave us a value, let's try a third method
        if (estimatedAudioLatency == AUDIO_LATENCY_NOT_ESTIMATED) {
            AudioManager audioManager = (AudioManager)getSystemService(Context.AUDIO_SERVICE);
            try {
                Method getOutputLatencyMethod = audioManager.getClass().getMethod("getOutputLatency", int.class);
                estimatedAudioLatency = (Integer) getOutputLatencyMethod.invoke(audioManager, AudioManager.STREAM_MUSIC) * 1000000L;
            } catch (Exception ignored) {
            }
        }

        // No method gave us a value. Let's use a default value. Better than nothing.
        if (estimatedAudioLatency == AUDIO_LATENCY_NOT_ESTIMATED) {
            estimatedAudioLatency = DEFAULT_AUDIO_LATENCY;
        }

        return estimatedAudioLatency;
    }
}
