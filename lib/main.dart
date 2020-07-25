import 'package:flutter/material.dart';
import 'package:flutterapp/songinfo.dart';
import 'package:flutterapp/songs.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool internet = false;

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  void getStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      internet = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      internet = true;
    } else {
      internet = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build main');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Color(0xFF62efff),
        fontFamily: 'Roboto',
      ),
      home: Songs(),
      routes: {
        "/songs": (BuildContext context) => Songs(),
        //"/song_info": (BuildContext context) => SongInfo(),
      },
    );
  }
}
