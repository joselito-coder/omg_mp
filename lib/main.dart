import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:video_player/video_player.dart';
import './Navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  //we will need some variables
  bool playing = false; // at the begining we are not playing any song
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon

  late VideoPlayerController _controller;

  //Now let's start by creating our music player
  //first let's declare some object
  late AudioPlayer _player;
  late AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  //we will create a custom slider

  int rick = 0;

  var songs = ['rickRoll.mp3', 'omgAshish.mp3', 'iceCream.mp3'];
  var images = ['rick.png', 'omgAshish.png', 'iceCream.jpg'];
  var songcounter = 0;

  Widget slider() {
    return Container(
      // width: 300.0,
      width: MediaQuery.of(context).size.width - 128.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Now let's initialize our player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset('assets/vids/rickRoll.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    //now let's handle the audioplayer time

    //this function will allow you to get the music duration
    _player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };

    //this function will allow us to move the cursor of the slider while we are playing the song
    _player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        title: Text('Omg mp'),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 20, 103, 197),
                Color.fromARGB(255, 96, 162, 216),
              ]),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 28.0,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Let's add some text title
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    "Omg media player",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    "Watch your favorite Media",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                //Let's add the music cover
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30.0,
                    height: 280.0,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(50.5, 50.5)),
                        image: DecorationImage(
                          image: AssetImage("assets/${images[songcounter]}"),
                        )),
                  ),
                ),

                SizedBox(
                  height: 18.0,
                ),
                Center(
                  child: Text(
                    songNameFormatter(songs[songcounter]),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Let's start by adding the controller
                        //let's add the time indicator text

                        Container(
                          width: MediaQuery.of(context).size.width - 28.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              slider(),
                              Text(
                                "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 45.0,
                              color: Colors.blue,
                              onPressed: () {
                                seekToSec(0);
                              },
                              icon: Icon(
                                Icons.skip_previous,
                              ),
                            ),
                            IconButton(
                              iconSize: 62.0,
                              color: Colors.blue[800],
                              onPressed: () {
                                //here we will add the functionality of the play button
                                if (!playing) {
                                  //now let's play the song
                                  cache.play(songs[songcounter]);

                                  rick++;
                                  if (rick == 3) {
                                    openRickRoll();
                                  }

                                  setState(() {
                                    playBtn = Icons.pause;
                                    playing = true;
                                  });
                                } else {
                                  _player.pause();
                                  setState(() {
                                    playBtn = Icons.play_arrow;
                                    playing = false;
                                  });
                                }
                              },
                              icon: Icon(
                                playBtn,
                              ),
                            ),
                            IconButton(
                              iconSize: 45.0,
                              color: Colors.blue,
                              onPressed: () {
                                rick++;
                                if (rick > 5) {
                                  openRickRoll();
                                }

                                if (songcounter >= songs.length - 1) {
                                  songcounter = 0;
                                } else {
                                  songcounter++;
                                }

                                cache.play(songs[songcounter]);
                              },
                              icon: Icon(
                                Icons.skip_next,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void openRickRoll() async {
  // Randomly select links

  final _random = new Random();

  const urlList = [
    'https://www.youtube.com/shorts/seGKFOI3SE0',
    'https://www.youtube.com/watch?v=G1IbRujko-A',
    "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  ];

  var url = urlList[_random.nextInt(urlList.length)];

  if (await canLaunch(url)) {
    await launch(url);
  }
}

String songNameFormatter(String name) {
  name = name.split('.')[0];

  var position = [];

  for (int i = 0; i < name.length; i++) {
    // print(realname[i]);
    if (isUppercase(name[i])) {
      position.add(i);
    }
  }

  var fragments = [];
  for (int i = 0; i < position.length; i++) {
    var curPos = position[i];
    if (i == 0) {
      fragments.add(name.substring(0, curPos));
    } else {
      fragments.add(name.substring(position[i - 1], curPos));
    }
  }
  fragments.add(name.substring(position[position.length - 1], name.length));

  return fragments.join(" ");
}
