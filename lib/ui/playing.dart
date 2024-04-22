import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/data/model/song.dart';
import 'package:music/ui/playing/audio_player_manager.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});
  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(
      songs: songs,
      playingSong: playingSong,
    );
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage(
      {super.key, required this.songs, required this.playingSong});

  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;

  @override
  void initState() {
    super.initState();
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120000),
    );
    _audioPlayerManager =
        AudioPlayerManager(songUrl: widget.playingSong.source);
    _audioPlayerManager.init();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 70;
    final radius = (screenWidth - delta) / 2;
    // return Scaffold(
    //body: Center(
    //child: Text('Now Playing'),
    //),
    // );
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Now Playing',
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
        ),
      ),
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.playingSong.album),
            const SizedBox(height: 30),
            const Text('Le Tuan Anh'),
            const SizedBox(height: 20),
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/1.png',
                  image: widget.playingSong.image,
                  width: screenWidth - delta,
                  height: screenWidth - delta,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/1.png',
                      width: screenWidth - delta,
                      height: screenWidth - delta,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 12),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Column(
                      children: [
                        Text(
                          widget.playingSong.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.playingSong.artist,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color),
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_outlined),
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 24, right: 24, bottom: 20),
              child: _progressBar(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 24, right: 24, bottom: 20),
              child: _mediaButtons(),
            )
          ],
        )),
      ),
    );
  }

  Widget _mediaButtons() {
    return const SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
              function: null,
              icon: Icons.shuffle,
              color: Colors.deepOrange,
              size: 25),
          MediaButtonControl(
              function: null,
              icon: Icons.skip_previous,
              color: Colors.deepOrange,
              size: 25),
          MediaButtonControl(
              function: null,
              icon: Icons.play_arrow,
              color: Colors.deepOrange,
              size: 25),
          MediaButtonControl(
              function: null,
              icon: Icons.skip_next,
              color: Colors.deepOrange,
              size: 25),
          MediaButtonControl(
              function: null,
              icon: Icons.repeat,
              color: Colors.deepOrange,
              size: 25),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(
              progress: progress, total: total, buffered: buffered);
        });
  }
}

class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });
  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
