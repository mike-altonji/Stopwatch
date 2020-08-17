import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Stopwatch'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String status = 'start';
  String timeText = '00:00.00';
  Stopwatch stopwatch = Stopwatch();

  void _startTimer() {
    Timer(Duration(milliseconds: 25), _keepRunning);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliSeconds =
        twoDigits(duration.inMilliseconds.remainder(1000)).substring(0, 2);
    if (duration.inHours < 1) {
      return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliSeconds";
    } else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  void _keepRunning() {
    if (stopwatch.isRunning) {
      _startTimer();
    }
    setState(() {
      timeText = _printDuration(stopwatch.elapsed);
    });
  }

  void _resetStopwatch() {
    stopwatch.reset();
    setState(() {
      timeText = _printDuration(stopwatch.elapsed);
    });
  }

  void _toggleStopwatch() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      setState(() {
        status = 'start';
      });
    } else {
      stopwatch.start();
      _startTimer();
      setState(() {
        status = 'stop';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _toggleStopwatch();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Press anywhere to $status.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
              ),
              Text(
                timeText,
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _resetStopwatch();
        },
        tooltip: 'Reset Stopwatch',
        child: Icon(Icons.delete_forever),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
