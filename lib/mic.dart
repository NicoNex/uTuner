import 'dart:async';
import 'package:mic_stream/mic_stream.dart';

class MicStream {
	static const AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
	static const SAMPLE_RATE = 48000;

	Stream<List<int>> stream;
	StreamSubscription<List<int>> listener;
	List<int> currentSamples;

	bool isRecording = false;

	startRecording() {
		if (!isRecording) {
			isRecording = true;
			stream = microphone(
				audioSource: AudioSource.DEFAULT,
				sampleRate: SAMPLE_RATE,
				channelConfig: ChannelConfig.CHANNEL_IN_MONO,
				audioFormat: AUDIO_FORMAT
			);

			listener = stream.listen((samples) => currentSamples = samples);
		}
	}

	stopRecording() {
		if (isRecording) {
			isRecording = false;
			listener.cancel();
		}
	}
}
