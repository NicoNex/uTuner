import 'package:flutter/material.dart';
import './mic.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
	return MaterialApp(
	  title: 'Flutter Demo',
	  theme: ThemeData(
		primarySwatch: Colors.blue,
	  ),
	  home: MyHomePage(title: 'uTuner'),
	);
	}
}

class MyHomePage extends StatefulWidget {
	MyHomePage({Key key, this.title}) : super(key: key);

	final String title;

	@override
	_MyHomePageState createState() => _MyHomePageState();
}

// The main basically
class _MyHomePageState extends State<MyHomePage> {
	Stream<List<int>> stream;
	StreamSubscription<List<int>> listener;
	List<int> currentSamples;

	// Refreshes the Widget for every possible tick to force a rebuild of the sound wave (probably useless in my case)
	AnimationController controller;

	// TODO: rename this into pitch.
	int _counter = 0;
	// String note;

	void _incrementCounter() {
	// var mstr = new MicStream();
	// mstr.startRecording();


	setState(() {
	  _counter++;
	});
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
							'$_counter',
							style: TextStyle(
							color: Colors.white,
							fontSize: 90,
							fontWeight: FontWeight.bold,
						  )
						),

						Text(
							'Some useful info here...',
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
				onPressed: _incrementCounter,
				tooltip: 'Increment',
				label: Text("Settings"),
				icon: Icon(Icons.settings),
			), // This trailing comma makes auto-formatting nicer for build methods.
		);
	}
}
