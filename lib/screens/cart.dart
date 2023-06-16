import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ScaleFinderScreen extends StatefulWidget {
  const ScaleFinderScreen({super.key});

  @override
  State<ScaleFinderScreen> createState() => _ScaleFinderScreenState();
}

class _ScaleFinderScreenState extends State<ScaleFinderScreen> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<RecordingDisposition>(
            stream: recorder.onProgress,
            builder: (context, snapshot) {
              final duration =
                  snapshot.hasData ? snapshot.data!.duration : Duration.zero;

              String twoDigits(int n) {
                if (n >= 10) {
                  return n.toString();
                } else {
                  return '0$n';
                }
              }

              final twoDigitMinutes = twoDigits(
                duration.inMinutes.remainder(60),
              );
              final twoDigitSeconds = twoDigits(
                duration.inSeconds.remainder(60),
              );
              return Text(
                '$twoDigitMinutes:$twoDigitSeconds',
                style:
                    const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (recorder.isRecording) {
                await stopRecording();
              } else {
                await startRecording();
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Icon(
                recorder.isRecording
                    ? FontAwesomeIcons.stop
                    : FontAwesomeIcons.microphone,
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future stopRecording() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    // get path of recorded audio
    final audioFile = File(path!);
    print('Recording saved to ${audioFile}');
  }

  Future startRecording() async {
    if (!isRecorderReady) return;
    var tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/audio1.aac';
    await recorder.startRecorder(toFile: path, codec: Codec.aacADTS);
  }

  Future initRecorder() async {
    var status = await Permission.microphone.request();

    if (status.isDenied) {
      status = await Permission.microphone.request();
    } else if (status.isPermanentlyDenied) {
      // Permission has been permanently denied.
      // You can open the app settings to prompt the user to grant the permission manually.
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Microphone Permission'),
          content: const Text(
              'Microphone permission is required to use this feature. Please enable it in the app settings.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }
}
