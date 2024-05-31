import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/class.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:music_app/player.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.music});
  final Music music;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  Duration maxDuration  =  const Duration(seconds: 0);
  Duration currentDuration = Duration.zero;

  int _currentMusic = 0;

  @override
  void initState() {
    super.initState();
    _currentMusic = int.parse(widget.music.image);
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1)
    )..repeat();

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        maxDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((duration) {
      setState(() {
        currentDuration = duration;
      });
    });

    _audioPlayer.setReleaseMode(ReleaseMode.stop);
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
                            child: Image.asset('assets/img/img$_currentMusic.jpg', fit: BoxFit.fill,)
                        ),
                      ),
                    ),
                  ),
                  const Gap(25),
                  Text(musics[_currentMusic].title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  Text(musics[_currentMusic].author, style: const TextStyle(color: Colors.grey, fontSize: 18),),
                  const Gap(50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ProgressBar(
                      progressBarColor: Colors.white,
                      thumbGlowRadius: 15,
                      thumbColor: Colors.indigo.shade300,
                      timeLabelPadding: 10,
                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                      progress: currentDuration,
                      total: maxDuration,
                      onSeek: (duration) {
                        _audioPlayer.seek(duration);
                      },
                    ),
                  ),
                  const Gap(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () async {
                        if (_currentMusic > 0) {
                          _currentMusic--;
                          await _audioPlayer.stop();
                          await _audioPlayer.play(AssetSource('music/music$_currentMusic.mp3'));
                        }
                      }, icon: const Icon(CupertinoIcons.backward_end)),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          ColorFiltered(
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcATop),
                            child: Lottie.asset('assets/animation/anim.json',
                              height: 100,
                              width: 100,
                              animate: _audioPlayer.state == PlayerState.playing,
                            ),
                          ),
                          IconButton(onPressed: () async {
                            if (_audioPlayer.state == PlayerState.playing) {
                              await _audioPlayer.pause();
                            } else {
                              await _audioPlayer.play(AssetSource('music/music$_currentMusic.mp3'));
                            }
                          }, icon: _audioPlayer.state == PlayerState.playing ? const Icon(CupertinoIcons.pause) : const Icon(CupertinoIcons.play)),
                        ],
                      ),
                      IconButton(onPressed: () async {
                        if (_currentMusic < musics.length - 1) {
                          _currentMusic++;
                        } else {
                          _currentMusic = 0;
                        }
                        await _audioPlayer.stop();
                        await _audioPlayer.play(AssetSource('music/music$_currentMusic.mp3'));
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
}
