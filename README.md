# Flutter AudiPlayers Pause/Stop error
This repository aims at reproducing an error that occurs when pausing/stopping an audioplayer and then resuming it.

It consists of the following two components:
* Backend API
  * Provides an asynchronous way of uploading an audio file
  * Serves uploaded audio files as streams
* Flutter Frontend
  * Provides a UI in order to upload audio files to the API
  * Consumes streams of uploaded audio files using the audioPlayers plugin

In order to run the project, run the backend API using the following command:
```bash
python -m backend.backend_api
```

Then run the Flutter Frontend as a web application either using an IDE or using the following command:
```bash
cd frontend # cd to the root of the frontend project
flutter run -d chrome
```


## Update
The error has been addressed in the meantime
