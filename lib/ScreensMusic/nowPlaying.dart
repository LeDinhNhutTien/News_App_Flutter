import "dart:developer";

import "package:flutter_news_app/provider/song_model_provider.dart";
import 'package:just_audio/just_audio.dart';
import "package:flutter/material.dart";
import "package:just_audio_background/just_audio_background.dart";
import "package:on_audio_query/on_audio_query.dart";
import "package:provider/provider.dart";
import 'package:flutter_news_app/page/widget/music.dart';

class NowPlaying extends StatefulWidget {
    const NowPlaying({Key? key, required this.songModel, required this.audioPlayer, required this.allSongs}):super(key: key);
    final SongModel songModel;
    // final List<SongModel> songModel;
    final  AudioPlayer audioPlayer;
    final List<SongModel> allSongs;
    @override
    State<NowPlaying> createState() => _NowPlayingState();
  }

  class _NowPlayingState extends State<NowPlaying> {
    Duration _duration=const Duration();
    Duration _position=const Duration();
    int currentSongIndex=0;


    bool _isPlaying = false;


    void popBack(){
      Navigator.pop(context);
    }
    void seekToSeconds(int seconds){
      Duration duration=Duration(seconds: seconds);
      widget.audioPlayer.seek(duration);
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      currentSongIndex = widget.allSongs.indexOf(widget.songModel); // Cập nhật chỉ số bài hát hiện tại

      playSong(currentSongIndex);
    }

    void playSong(int index){
      try{
        currentSongIndex = index;
        var song = widget.allSongs[index];
        if(song.uri!=null){
          widget.audioPlayer
              .setAudioSource(
              AudioSource.uri(
                Uri.parse(song.uri!),
                tag: MediaItem(
                  id: '${song.id}',
                  album: "${song.album}",
                  title: song.displayNameWOExt,
                  artUri: Uri.parse('https://example.com/albumart.jpg'),
                ),
              )
          );
          widget.audioPlayer.play();
          _isPlaying=true;
        }else{
          log("Song URI is null");
        }
      } on Exception{
        log("Cannot parse song");
      }
      widget.audioPlayer.durationStream.listen((d) {
        setState(() {
          _duration=d!;
        });
      });
      widget.audioPlayer.positionStream.listen((p) {
        setState(() {
          _position=p;
        });
      });
    }

    void playPreviousSong() {
      if (currentSongIndex > 0) {
        playSong(currentSongIndex - 1);
      }
    }

    void playNextSong() {
      if (currentSongIndex < widget.allSongs.length - 1) {
        playSong(currentSongIndex + 1);
      }
    }
  @override
  Widget build(BuildContext context) {
      double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body:SafeArea(
        child: Container(
          width: double.infinity,
          padding:const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Column(
                  children:  [
                     const Center(
                      child: CircleAvatar(
                        radius: 100.0,
                        child: Icon(Icons.music_note),
                      ),
                     ),

                    const SizedBox(
                      height: 30.0,
                    ),
                      Text(
                        widget.allSongs[currentSongIndex].displayNameWOExt,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.allSongs[currentSongIndex].artist.toString() == "<unknown>"?"<Unknown Artist>":widget.songModel.artist.toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(_position.toString().split(".")[0]),
                        Expanded(
                            child: Slider(
                                min:0.0 ,
                                value: _position.inSeconds.toDouble(),
                                max:_duration.inSeconds.toDouble(),
                                onChanged: (value){
                              setState(() {
                                seekToSeconds(value.toInt());
                                value =value;
                              });
                            })),
                        Text(_duration.toString().split(".")[0]),
                      ],
                    ),

                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[
                        IconButton(onPressed: playPreviousSong,
                          icon: const Icon(
                          Icons.skip_previous,
                          size: 24.0,)
                          ,),
                        IconButton(onPressed: (){
                          setState(() {
                            if(_isPlaying){
                              widget.audioPlayer.pause();
                            }else{
                              if(_position>=_duration){
                                seekToSeconds(0);
                              } else{
                                widget.audioPlayer.play();
                              }
                            }
                            _isPlaying= !_isPlaying;

                          });
                        }, icon:  Icon(
                          _isPlaying ? Icons.pause: Icons.play_arrow,
                          size: 40,
                          color: Colors.orangeAccent,),),
                        IconButton(onPressed: playNextSong
                          , icon: const Icon(Icons.skip_next,size: 24.0,),),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
  void changeToSeconds(int seconds){
    Duration duration=Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }


}



    