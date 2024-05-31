import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:music_app/class.dart';
import 'package:music_app/player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late AudioPlayer _audioPlayer;

  int _currentMusic = -1;
  bool a = false;

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        //scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Grizzly'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/img/background2.jpg'),
                )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4,
                sigmaY: 4,
              ),
              child: Container(),
            ),
          ),
          ListView.separated(
          itemCount: musics.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) => ListTile(
            onTap: (){
              if(_audioPlayer.state == PlayerState.playing){
                _audioPlayer.stop();
                _audioPlayer.state = PlayerState.stopped;
              }
              showModalBottomSheet(context: context,
                  isScrollControlled: true,
                  builder: (context){
                  return PlayerPage(music: musics[index],);
                  });
              setState(() {
                _currentMusic = index;
                a = _currentMusic == index;
              });
            },
            title: Text(musics[index].title),
            subtitle: Text(musics[index].author, style: const TextStyle(color: Colors.grey),),
            leading: CircleAvatar(
              radius: 35,
              foregroundImage: AssetImage('assets/img/img${musics[index].image}.jpg')
            ),
            trailing: Icon(Icons.equalizer, color: _currentMusic == index ? Colors.white : Colors.grey),
          ),
        ),
      ]
      ),
      bottomNavigationBar: a ? BottomAppBar(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Center(
            child: GestureDetector(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    foregroundImage: AssetImage('assets/img/img${musics[_currentMusic].image}.jpg'),
                  ),
                  title: Text(musics[_currentMusic].title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                  subtitle: Text(musics[_currentMusic].author,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        if(_audioPlayer.state == PlayerState.playing){
                          _audioPlayer.pause();
                          _audioPlayer.state = PlayerState.paused;
                        }
                        else {
                          _audioPlayer.state = PlayerState.playing;
                          _audioPlayer.play(AssetSource("music/music$_currentMusic.mp3"));
                        }
                        setState(() {});
                      }, icon: _audioPlayer.state == PlayerState.playing ? const Icon(CupertinoIcons.pause) : const Icon(CupertinoIcons.play)
                      ),
                      IconButton(onPressed: (){
                        print(_currentMusic);
                        _audioPlayer.state = PlayerState.playing;
                          _currentMusic = _currentMusic == musics.length -1 ? 0 : _currentMusic + 1;
                        _audioPlayer.play(AssetSource('music/music$_currentMusic.mp3'));
                        setState(() {});
                      }, icon: const Icon(CupertinoIcons.forward_end)),
                    ],
                  ),
                )
            )
        ),
      ) : null
    );
  }
}
