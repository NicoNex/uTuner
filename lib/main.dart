import 'dart:ffi';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';

typedef init_pitch = void Function(Int32 sampleRate, Int32 bufSize, Int32 gate);
typedef InitPitchFunc = void Function(int sampleRate, int bufSize, bool gate);

typedef get_pitch = Float Function(Int16 input, Int32 size);
typedef GetPitchFunc = double Function(List<int> input, int size);

typedef get_note_index = Int32 Function(Float pitch, Int32 referencePitch);
typedef GetNoteIndexFunc = int Function(double pitch, int referencePitch);

typedef dispose_pitch = Void Function();
typedef DisposePitchFunc = void Function();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'µTuner',
			theme: ThemeData(primarySwatch: Colors.blue),
			home: MyHomePage(title: 'µTuner'),
		);
	}
}

class MyHomePage extends StatefulWidget {
	MyHomePage({Key key, this.title}) : super(key: key);

	final String title;

	@override
	_TunerState createState() => _TunerState();
}

// The main basically
class _TunerState extends State<MyHomePage> {
	static const AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
	static const SAMPLE_RATE = 48000;
	final notes = ["...", "A", "A#", "B", "C", "D", "D#", "E", "F", "F#", "G", "G#"];
	final dylib = DynamicLibrary.open('pitch.dylib');

	Stream<List<int>> stream;
	StreamSubscription<List<int>> listener;
	List<int> currentSamples;

	int referencePitch = 440;
	bool isRecording = false;
	double _freq;
	String _note;

	GetPitchFunc getPitch;
	GetNoteIndexFunc getNoteIndex;

	_TunerState() {
		// TODO: fix this native functions calling
		final initPitchPointer = dylib.lookup<NativeFunction<init_pitch>>('init_pitch');
		final InitPitchFunc initPitch = initPitchPointer.asFunction<InitPitchFunc>();

		final getPitchPointer = dylib.lookup<NativeFunction<get_pitch>>('get_pitch');
		getPitch = getPitchPointer.asFunction<GetPitchFunc>();

		final getNoteIndexFuncPointer = dylib.lookup<NativeFunction<get_note_index>>('get_node_index');
		getNoteIndex = getNoteIndexFuncPointer.asFunction<GetNoteIndexFunc>();

//		initPitch(SAMPLE_RATE, 1024, false);
		startRecording();
	}

	_updateData(List<int> samples) {
		var pitch = getPitch(currentSamples, 1024);
		var noteIdx = getNoteIndex(pitch, referencePitch);

		setState(() {
			_note = notes[noteIdx];
			_freq = pitch;
		});
	}


	startRecording() {
		if (!isRecording) {
			isRecording = true;
			stream = microphone(
				audioSource: AudioSource.DEFAULT,
				sampleRate: SAMPLE_RATE,
				channelConfig: ChannelConfig.CHANNEL_IN_MONO,
				audioFormat: AUDIO_FORMAT
			);

			listener = stream.listen(_updateData);
		}
	}

	stopRecording() {
		if (isRecording) {
			isRecording = false;
			listener.cancel();
		}
	}


	@override
	Widget build(BuildContext context) {
		final mainTextTheme = Theme.of(context).textTheme.apply(
			bodyColor: Colors.white,
			displayColor: Colors.white,
		);

		// This method is rerun every time setState is called, for instance as done
		// by the _incrementCounter method above.
		return Scaffold(
			backgroundColor: Colors.black,
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text(
							'$_note',
							style: TextStyle(
								color: Colors.white,
								fontSize: 90,
								fontWeight: FontWeight.bold,
							)
						),

						Text(
							'$_freq Hz',
							style: TextStyle(
								color: Colors.white,
								fontSize: 18
							)
						),
					],
				),
			),

			floatingActionButton: FloatingActionButton.extended(
				// TODO: change this with the proper function.
				onPressed: () => {},
				tooltip: 'Increment',
				label: Text("Settings"),
				icon: Icon(Icons.settings),
			), // This trailing comma makes auto-formatting nicer for build methods.
		);
	}
}
