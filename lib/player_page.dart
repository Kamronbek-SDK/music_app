import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/class.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.music});
  final Music music;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with SingleTickerProviderStateMixin {
 
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;

  int _currentMusic = 0;

  Duration maxDuration = const Duration(seconds: 0);

  // findDuration() {
  //   _audioPlayer.getDuration().then((v) {
  //     setState(() {
  //       maxDuration = v ?? const Duration(seconds: 0);
  //     });
  //   });
  // }

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1)
    )
    ..repeat();
    maxDuration = _audioPlayer.getDuration() as Duration;
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: AppBar(
            leading: Container(),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      // body: Stack(
      //   children: [
      //     Container(
      //       decoration: BoxDecoration(
      //         image: DecorationImage(
      //           fit: BoxFit.cover,
      //             image: AssetImage('assets/img/img${music.image}.jpg'),
      //         )
      //       ),
      //       child: BackdropFilter(
      //         filter: ImageFilter.blur(
      //           sigmaX: 4,
      //           sigmaY: 4,
      //         ),
      //         child: Container(),
      //       ),
      //     )
      //   ],
      // ),
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
          Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.grey, width: 2)
                  ),
                  elevation: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.height * .4,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset('assets/img/img${widget.music.image}.jpg', fit: BoxFit.fill,)
                    ),
                  ),
                ),
              ),
              const Gap(25),
              Text(widget.music.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              Text(widget.music.author, style: const TextStyle(color: Colors.grey, fontSize: 18),),
              const Gap(50),
               StreamBuilder(stream: _audioPlayer.onPositionChanged,
                   builder: (context, snapshot) => Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15),
                     child: ProgressBar(
                       progressBarColor: Colors.white,
                       thumbGlowRadius: 15,
                       thumbColor: Colors.indigo.shade300,
                       timeLabelPadding: 10,
                       timeLabelTextStyle: const TextStyle(color: Colors.white),
                       progress: snapshot.data ?? const Duration(seconds: 0),
                       total: maxDuration,
                       onSeek: (duration) {
                         setState(() {
                           _audioPlayer.seek(duration);
                         });
                       },
                     ),
                   )
               ),
               const Gap(50),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   IconButton(onPressed: (){
                     if(_currentMusic > 0) {
                       setState(() {
                         _currentMusic--;
                       });
                       _audioPlayer.stop();
                       _audioPlayer.play(AssetSource('music/music${widget.music.image}.mp3'));
                     }
                   }, icon: const Icon(CupertinoIcons.backward_end),
                   ),
                   Stack(
                     alignment: AlignmentDirectional.center,
                     children: [
                       ColorFiltered(
                       colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcATop),
                       child: Lottie.asset('assets/animation/anim.json',
                        height: 100,
                        width: 100,
                        animate: _audioPlayer.state == PlayerState.playing,
                      )
                      ),
                       IconButton(onPressed: () async {
                         if(_audioPlayer.state == PlayerState.playing){
                           await _audioPlayer.pause();
                         }
                         else {
                           await _audioPlayer.play(AssetSource('music/music${widget.music.image}.mp3'));
                         }
                         setState(() {});
                       }, icon: _audioPlayer.state == PlayerState.playing ? const Icon(CupertinoIcons.pause) : const Icon(CupertinoIcons.play),
                       ),
                     ]
                   ),
                   IconButton(onPressed: (){
                     if(_currentMusic < musics.length - 1) {
                       setState(() {
                         _currentMusic++;
                       });
                       _audioPlayer.stop();
                       _audioPlayer.play(AssetSource('music/music${widget.music.image}.mp3'));
                     } else {
                       setState(() {
                         _currentMusic = 0;
                       });
                     }
                   }, icon: const Icon(CupertinoIcons.forward_end)),
                 ],
               ),
            ],
          ),
        ),
       ]
      ),
    );
  }
  // _iconRotate(){
  //   return  RotationTransition(
  //     turns: _controller,
  //     child: const Icon(CupertinoIcons.car, size: 40,)
  //   );
  // }
}