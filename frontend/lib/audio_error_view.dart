import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioErrorView extends StatefulWidget {
  const AudioErrorView({Key? key}) : super(key: key);

  @override
  State<AudioErrorView> createState() => _AudioErrorViewState();
}

class _AudioErrorViewState extends State<AudioErrorView> {
  var audioPlayer = AudioPlayer();
  final audioSource = UrlSource("http://localhost:5000/api/audio");

  @override
  void initState() {
    audioPlayer.setSource(audioSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                audioPlayer.resume();

                setState(() {
                  audioPlayer = audioPlayer;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text("Resume Audio"),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            ElevatedButton(
              onPressed: () {
                audioPlayer.pause();
                setState(() {
                  audioPlayer = audioPlayer;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text("Pause Audio"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
