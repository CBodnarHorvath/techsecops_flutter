import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:techsecops_flutter/firebase_options.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const MyApp());
  }, (e, s) {
    debugPrint(e.toString());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TechSecOps exercise 4'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String memeImage =
      "https://i.kym-cdn.com/entries/icons/original/000/030/157/womanyellingcat.jpg";
  final String upgradeText = "Please upgrade";
  final String okText = "Ok";
  final String metMinVersion =
      "This version is equal or above minimum app version";
  final String checkNewVersion = "Check for new version";
  final double versionNumber = 1.0;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _remoteConfig = FirebaseRemoteConfig.instance;
  double _minVersion = 0;

  Future<void> _initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    _fetchConfig();
  }

  void _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
  }

  @override
  void initState() {
    _initConfig();
    super.initState();
  }

  checkAppVersion() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              _minVersion > widget.versionNumber
                  ? widget.upgradeText
                  : widget.metMinVersion,
              textAlign: TextAlign.center,
            ),
            content: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
                backgroundColor: Colors.grey,
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                widget.okText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            alignment: Alignment.center,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _minVersion = _remoteConfig.getDouble('min_version');
    // debugPrint(_minVersion.toString());
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.versionNumber >= _minVersion)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.network(widget.memeImage),
              ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
                backgroundColor: Colors.grey,
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              onPressed: (() => checkAppVersion()),
              child: Text(
                widget.checkNewVersion,
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
