import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class SongInfo extends StatefulWidget {
  SongInfo({this.trackid});
  final trackid;
  @override
  _SongInfoState createState() => _SongInfoState(trackid);
}

class _SongInfoState extends State<SongInfo> {
  _SongInfoState(this.trackid);
  final trackid;
  bool load = true;
  String track_name = "";
  String artist_name;
  String album_name;
  int explicit;
  int rating;
  String lyrics;
  bool internet = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatus();
    getinfo();
  }

  void getStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      setState(() {
        internet = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      setState(() {
        internet = true;
      });
    } else {
      setState(() {
        internet = false;
        load = true;
        getinfo();
      });
    }
  }

  Future<void> getinfo() async {
    Response response = await get(
        "https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackid&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
    print(response.statusCode);
    Response response2 = await get(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackid&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
    print(response2.body);
    final Map<dynamic, dynamic> responseJson = json.decode(response.body);
    final Map<dynamic, dynamic> responseJson2 = json.decode(response2.body);
    setState(() {
      track_name = responseJson["message"]["body"]["track"]["track_name"];
      artist_name = responseJson["message"]["body"]["track"]["artist_name"];
      album_name = responseJson["message"]["body"]["track"]["album_name"];
      explicit = responseJson2["message"]["body"]["lyrics"]["explicit"];
      rating = responseJson["message"]["body"]["track"]["track_rating"];
      lyrics = responseJson2["message"]["body"]["lyrics"]["lyrics_body"];

      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    getStatus();
    return internet == true
        ? load == true
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
            : Scaffold(
                appBar: AppBar(
                  title: Center(child: Text("Track Details")),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            track_name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Artist",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            artist_name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Album Name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            album_name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Explicit",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            "$explicit",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Rating",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            "$rating",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Lyrics",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            lyrics,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
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
