import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with TickerProviderStateMixin {
  final audioPlayer = AudioPlayer(playerId: "player");
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // setLoop();

    // listen for play, pause, stop
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    // listen for duration changge
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // listen for audio position change
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    //audioPlayer.dispose();
    super.dispose();
  }

  Future setLoop() async {
    // play recording on loop
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 10.0, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(
                        -7, 7), // controls the position of the shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/mic.jpg',
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  height: 350,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Recording 1',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              'Ammar Essajee',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  IconButton(
                    icon: Icon(isPlaying
                        ? FontAwesomeIcons.pause
                        : FontAwesomeIcons.solidCirclePlay),
                    iconSize: 60,
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        var tempDir = await getTemporaryDirectory();
                        String path = '${tempDir.path}/audio1.aac';
                        // change DeviceFileSource to AssetSource if trying to play audio from Assets folder
                        await audioPlayer.play(DeviceFileSource(path));
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    color: isDark
                        ? const Color.fromARGB(149, 196, 202, 196)
                        : const Color.fromARGB(97, 110, 110, 107),
                  ),
                  Text(formatTime(duration - position))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }
}
