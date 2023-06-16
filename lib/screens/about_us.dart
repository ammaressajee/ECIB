import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sound_stream/sound_stream.dart';

class SoundStream extends StatefulWidget {
  const SoundStream({super.key});

  @override
  State<SoundStream> createState() => _SoundStreamState();
}

class _SoundStreamState extends State<SoundStream> {
  final RecorderStream _recorder = RecorderStream();
  final PlayerStream _player = PlayerStream();

  final List<Uint8List> _micChunks = [];
  bool _isRecording = false;
  bool _isPlaying = false;

  late StreamSubscription _recorderStatus;
  late StreamSubscription _playerStatus;
  late StreamSubscription _audioStream;

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    _playerStatus.cancel();
    _audioStream.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted) {
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
      }
    });

    _audioStream = _recorder.audioStream.listen((data) {
      if (_isPlaying) {
        _player.writeChunk(data);
      } else {
        // uncomment below to load data from recorder while stream is off
        //_micChunks.add(data);
      }
    });

    _playerStatus = _player.status.listen((status) {
      if (mounted) {
        setState(() {
          _isPlaying = status == SoundStreamStatus.Playing;
        });
      }
    });

    await Future.wait([
      _recorder.initialize(),
      _player.initialize(),
    ]);
  }

  void _play() async {
    await _player.start();

    if (_micChunks.isNotEmpty) {
      for (var chunk in _micChunks) {
        await _player.writeChunk(chunk);
      }
      _micChunks.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: 96.0,
            icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
            onPressed: _isRecording ? _recorder.stop : _recorder.start,
          ),
          IconButton(
            iconSize: 96.0,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _isPlaying ? _player.stop : _play,
          ),
        ],
      ),
    );
  }
}
