import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';

class AudioErrorView extends StatefulWidget {
  const AudioErrorView({Key? key}) : super(key: key);

  @override
  State<AudioErrorView> createState() => _AudioErrorViewState();
}

class _AudioErrorViewState extends State<AudioErrorView> {
  final String audioURL = "http://localhost:5000/api/audio";

  AudioPlayer audioPlayer = AudioPlayer();
  String? latestFileName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

                if (result != null) {
                  PlatformFile file = result.files.single;
                  await uploadAudio(file);
                } else {
                  debugPrint("Media Upload Canceled");
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text("Upload Audio"),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              height: 200,
              width: 300,
              color: latestFileName == null ? Colors.grey.shade400 : Theme.of(context).secondaryHeaderColor,
              child: Center(
                child: latestFileName != null
                    ? Text(
                        "Audio file name: \n$latestFileName",
                        style: const TextStyle(color: Colors.white),
                      )
                    : const Text("Upload audio file", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: "Resume Audio",
                  child: IconButton(
                    color: Theme.of(context).primaryColor,
                    iconSize: 50,
                    onPressed: () {
                      // audioPlayer.setSourceUrl("$audioURL/$latestFileName");  // This does not solve the issue
                      audioPlayer.resume();

                      setState(() {
                        audioPlayer = audioPlayer;
                      });
                    },
                    icon: const Icon(Icons.play_circle_outline),
                  ),
                ),
                const SizedBox(width: 60),
                Tooltip(
                  message: "Pause Audio",
                  child: IconButton(
                    color: Theme.of(context).primaryColor,
                    iconSize: 50,
                    onPressed: () {
                      // Both pause & stop result in the same issue
                      audioPlayer.pause();
                      // audioPlayer.stop();
                      setState(() {
                        audioPlayer = audioPlayer;
                      });
                    },
                    icon: const Icon(Icons.pause_circle_filled_outlined),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<StreamedResponse> uploadAudio(PlatformFile file) async {
    final audioURI = Uri.parse(audioURL);

    final multiPartFile = MultipartFile.fromBytes(
      "file",
      file.bytes ?? [],
      filename: file.name, // Filename is required
      contentType: MediaType(FileType.audio.name, file.extension!),
    );

    final request = MultipartRequest('POST', audioURI)..files.add(multiPartFile);

    final response = await request.send();

    audioPlayer.setSourceUrl("$audioURL/${file.name}");

    setState(() {
      audioPlayer = audioPlayer;
      latestFileName = file.name;
    });

    return response;
  }
}
