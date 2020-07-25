import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/songinfo.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  List<Widget> list;
  bool load = true;
  bool internet = true;
  @override
  void initState() {
    super.initState();
    list = [];
    getStatus();
  }

  void getStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      setState(() {
        internet = true;

        getList();
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      setState(() {
        internet = true;

        getList();
      });
    } else {
      setState(() {
        internet = false;
        load = true;
        getList();
      });
    }
  }

  Future<void> getList() async {
    Response response = await get(
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
    if (response.statusCode == 200) {
      String data = response.body;
      final Map<String, dynamic> responseJson = json.decode(response.body);
      for (int i = 0;
          i < responseJson["message"]["body"]["track_list"].length;
          i++) {
        list.add(Padding(
          padding: EdgeInsets.all(0.0),
          child: MaterialButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SongInfo(
                    trackid: responseJson["message"]["body"]["track_list"][i]
                        ["track"]["track_id"]);
              }));
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Icon(
                          Icons.library_music,
                          color: Colors.yellow.shade800,
                          size: 40.0,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "${responseJson["message"]["body"]["track_list"][i]["track"]["track_name"]}",
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                            Text(
                              "${responseJson["message"]["body"]["track_list"][i]["track"]["album_name"]}",
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          responseJson["message"]["body"]["track_list"][i]
                              ["track"]["artist_name"],
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.0,
                ),
              ],
            ),
          ),
        ));
        setState(() {
          load = false;
        });
      }
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    getStatus();
    return internet == true
        ? (load == true
            ? Scaffold(
                body: SafeArea(
                  child: Center(
                    child: Loading(
                        indicator: BallPulseIndicator(),
                        size: 100.0,
                        color: Colors.pink),
                  ),
                ),
              )
            : (list.length == 0
                ? Scaffold(
                    body: SafeArea(
                      child: Center(
                        child: Text("No songs"),
                      ),
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      title: Center(child: Text("Trending")),
                    ),
                    body: SafeArea(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: list,
                        ),
                      ),
                    ),
                  )))
        : Scaffold(
            appBar: AppBar(
              title: Center(child: Text("Trending")),
            ),
            body: SafeArea(
              child: Center(
                child: Text("No Internet Connection"),
              ),
            ),
          );
  }
}
