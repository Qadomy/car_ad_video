import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;

import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inputdialog.dart';
import 'manger.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatefulWidget {
  @override
  State<VideoPlayerApp> createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  int? id;
  late bool isLoggedIn;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await checkId();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: isLoggedIn == false && id == null
          ? AlertDialogScreen()
          : VideoPlayerScreen(id: id!),
      debugShowCheckedModeBanner: false,
    );
  }

  Future checkId() async {
    isLoggedIn = await AppRepo.getInstance().isLoggedIn();
    id = await AppRepo.getInstance().getID();

    print(">>>>>>>>>>>> id id $id");
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final int id;

  const VideoPlayerScreen({Key? key, required this.id}) : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class Post {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  List<BetterPlayerDataSource> dataSourceList = <BetterPlayerDataSource>[];
  late BetterPlayerController _betterPlayerController;
  // late final AuthManager? authManager;

  // int? id;

  @override
  void initState() {
    // getId();
    // Future.delayed(Duration.zero, () async {
    //   id = await AppRepo.getInstance().getID();
    // });
    //
    // print(">>>>>>>>>>>> id id $id}");
    // setState(() {});
    List<String> vdlist = [];

    /* dataSourceList.add(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "http://blitzcoads.com/introvideo/video.mp4",
      ),
    );*/

    try {
      vdlist.add(
          "/data/data/com.example.car_ad_video/app_flutter/videos/video.mp4");
      dataSourceList.add(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          "/data/data/com.example.car_ad_video/app_flutter/videos/video.mp4",
        ),
      );
    } on io.IOException catch (_) {
      print("First Time Run");
    }

/*
    _controller = VideoPlayerController.file(File('/data/user/0/com.example.flutter_app/app_flutter/videos/Gn4KP0wPgE.mp4'));
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.play();
    _controller1 = VideoPlayerController.file(File('/data/user/0/com.example.flutter_app/app_flutter/videos/5Li3pIaiz0.mp4'));

    _initializeVideoPlayerFuture = _controller1.initialize();

    _controller.addListener(() {
      if(!_controller.value.isPlaying){
       // _controller.dispose();
       // _initializeVideoPlayerFuture = _controller1.initialize();
        _controller1.play();
      }
    });
*/

    /*   ..addListener(() {
        final bool isPlaying = _controller.value.position
            .inMilliseconds < _controller.value.duration.inMilliseconds;
        // Tested with the following print
        print(currentIndexPosition);
        print(vdlist.length);
        print("POSITION = " +
            _controller.value.position.inMilliseconds.toString() +
            "  DURATION = " +
            _controller.value.duration.inMilliseconds.toString());

        if (!isPlaying) {
          setState(() {

            getFile();
          });
        }
      })
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });*/

    Future<void> createdirectory() async {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      new Directory(appDocDirectory.path + '/' + 'videos')
          .create(recursive: true)
// The created directory is returned as a Future.
          .then((Directory directory) async {
        print('Path of New Dir: ' + directory.path);
        final Dio _dio = Dio();

        List file = [];
        file = io.Directory(appDocDirectory.path + "/videos/")
            .listSync(); //use your folder name insted of resume.

        print(file);
        dataSourceList.clear();
        List file123 = [];
        file123 = io.Directory(appDocDirectory.path + "/videos/")
            .listSync(); //use your folder name insted of resume.
        print("Filling array");
        print(file123);

        for (var filename in file123) {
          vdlist.add(filename.path);
          dataSourceList.add(
            BetterPlayerDataSource(
              BetterPlayerDataSourceType.file,
              filename.path,
            ),
          );
        }
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print("Internet connection found");

            print(">>>>>>>>>>>> widget.id ${widget.id}");
            final response = await http.get(Uri.parse(
                "http://blitzcoads.com:3000/api/get_ads?id=${widget.id}"));

            if (response.statusCode == 200) {
              // If the server returns an OK response, then parse the JSON.
              //ProcessDirectory();

              dynamic filesnames = jsonDecode(response.body);
              print(filesnames);

              print(file);
              for (var filename in file) {
                var found = false;
                print("filename.toString()");
                print(filename.path);

                for (var s in filesnames) {
                  print(appDocDirectory.path + "/videos/" + s["adpath"]);

                  if (appDocDirectory.path + "/videos/" + s["adpath"] ==
                      filename.path) {
                    found = true;
                  }
                }
                if (found == false) {
                  //Delete the file
                  print("file should be deleted");
                  print(filename);
                  await deleteFile(File(filename.path));
                }
              }

              // Initialize the controller and store the Future for later use.
              dataSourceList.clear();
              List file123 = [];
              file123 = io.Directory(appDocDirectory.path + "/videos/")
                  .listSync(); //use your folder name insted of resume.
              print("Filling array");
              print(file123);

              for (var filename in file123) {
                vdlist.add(filename.path);
                dataSourceList.add(
                  BetterPlayerDataSource(
                    BetterPlayerDataSourceType.file,
                    filename.path,
                  ),
                );
              }

              var dcounter = 0;

              for (var s in filesnames) {
                //if file does not exist
                //download file

                dcounter++;

                //  downloadFile('http://192.168.1.103:8080', s["adpath"], appDocDirectory.path+"/videos");
                //  _downloadFile('http://192.168.1.103:8080/'+s["adpath"],appDocDirectory.path+"/videos/"+s["adpath"]);
                if (await File(appDocDirectory.path + "/videos/" + s["adpath"])
                        .exists() ==
                    false) {
                  await download2(
                      _dio,
                      'http://blitzcoads.com/uploads/' + s["adpath"],
                      appDocDirectory.path + "/videos/" + s["adpath"]);

                  print("dcounter");
                  print(dcounter);
                  print(filesnames.length);
                  print(appDocDirectory.path + "/videos/" + s["adpath"]);
                  vdlist.add(appDocDirectory.path + "/videos/" + s["adpath"]);
                  dataSourceList.add(
                    BetterPlayerDataSource(
                      BetterPlayerDataSourceType.file,
                      appDocDirectory.path + "/videos/" + s["adpath"],
                    ),
                  );
                }

                //   await dio.download('http://192.168.1.103:8080/'+s["adpath"], appDocDirectory.path+"/videos/"+s["adpath"], onReceiveProgress: (rec, total) {
                //    setState(() {
                // download = (rec / total) * 100;

                //    });

                // } );
                /* await FlutterDownloader.enqueue(
              url: 'http://192.168.1.103:8080/'+s["adpath"],
              savedDir: appDocDirectory.path+"/videos",
              showNotification: true, // show download progress in status bar (for Android)
              openFileFromNotification: true, // click on notification to open downloaded file (for Android)
            );*/

              }
            } else {
              // If the response was umexpected, throw an error.
              throw Exception('Failed to load post');
            }
          }
        } on SocketException catch (_) {
          print('not connected');
        }
      });
    }

    createdirectory();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.

    //ProcessDirectory();
    super.initState();
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = url + '/' + fileName;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      } else {
        print("File not found");
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    //_controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayerPlaylist(
          betterPlayerConfiguration: BetterPlayerConfiguration(
            controlsConfiguration: BetterPlayerControlsConfiguration(
              showControls: false,
              showControlsOnInitialize: false,
            ),
            autoPlay: true,
            fullScreenByDefault: true,
          ),
          betterPlayerPlaylistConfiguration:
              const BetterPlayerPlaylistConfiguration(
            nextVideoDelay: Duration(milliseconds: 0),
            loopVideos: true,
          ),
          betterPlayerDataSourceList: dataSourceList),
    );
  }

  // void getId() async {
  //   id = await AppRepo.getInstance().getID();
  // }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: Container(
        child: Column(
          children: <Widget>[
            // your Content if there

            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),

    );
  }*/
}
