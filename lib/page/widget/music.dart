import 'dart:developer';
import 'dart:io';


// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/ScreensMusic/nowPlaying.dart';
import 'package:flutter_news_app/provider/song_model_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    ChangeNotifierProvider(create: (context)=>SongModelProvider(),child: const Music(),)
  );
}
class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  final OnAudioQuery _audioQuery=  OnAudioQuery();
  final AudioPlayer  _audioPlayer =  AudioPlayer();

  List<SongModel> allSongs=[];

  playSong(String? uri){
    try{
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    }on Exception{
      log("Error parsing song");
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }
  void requestPermission() async{
    if(Platform.isAndroid){
      bool permissionStatus= await _audioQuery.permissionsStatus();
      if(!permissionStatus){
        await _audioQuery.permissionsRequest();
      }
      setState(() {

      });
    }
    // Permission.storage.request();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nhạc 2023"),
      actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.search),),
      ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true
        ),
        builder: (context,item){
          if(item.data==null){
            return Center(
              child: Column(
                children: const[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("Loading")
                ],
              ),
            );
          }
          if(item.data!.isEmpty){
            return const Center(
                child: Text("Nothing found!"));
          }
          return ListView.builder(
             itemCount: item.data!.length,
            padding: const EdgeInsets.fromLTRB(0,0,0,60),
            itemBuilder: (context,index){
               allSongs.addAll(item.data!);
               // return GestureDetector(
               //   onTap: (){
               //     context.read<SongModelProvider>().setId(item.data![index].id);
               //     Navigator.push(
               //       context,
               //       MaterialPageRoute(
               //           builder: (context)=>NowPlaying(
               //               songModel: item.data![index],
               //               audioPlayer: _audioPlayer)));
               //   },
               //   // child: MusicTile(
               //   //   songModel: item.data![index],
               //   // ),
               // );
                return ListTile(
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No artist"),
                  trailing: const Icon(Icons.more_horiz),
                  leading: const CircleAvatar(
                    child: Icon(Icons.music_note),
                  ),
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context)=>
                                NowPlaying(songModel: item.data![index],audioPlayer: _audioPlayer,),
                        ),
                    );
                  },
                );
        },
      );
    },
    ),
    );
}
}
