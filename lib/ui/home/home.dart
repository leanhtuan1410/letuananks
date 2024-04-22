import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/data/model/song.dart';
import 'package:music/ui/Playing.dart';
import 'package:music/ui/discovery/discovery.dart';
import 'package:music/ui/home/newmodel.dart';
import 'package:music/ui/setting/Setting.dart';
import 'package:music/ui/user/user.dart';

class Music extends StatelessWidget {
  const Music({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 98, 35, 208)),
        useMaterial3: true,
      ),
      home: const MusicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final List<Widget> _tabs = [
    const HomeTab(),
    const Discovery(),
    const settingTab(),
    const accoutnTab()
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('music'),
      ),
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.album), label: 'Discovery'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'account'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'setting')
            ],
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          ),
          tabBuilder: (context, index) {
            return _tabs[index];
          }),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSong();
    observeData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  ListView getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.red,
          thickness: 1,
          indent: 30,
          endIndent: 30,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(parent: this, song: songs[index]);
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  void nagivate(Song song) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NowPlaying(
        songs: songs,
        playingSong: song,
      );
    }));
  }

  void showBottomSheet() {}
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({
    required this.parent,
    required this.song,
  });

  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: FadeInImage.assetNetwork(
            placeholder: 'assets/itune.jpg',
            image: song.image,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/itune.jpg',
                width: 50,
                height: 50,
              );
            }),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {
          parent.showBottomSheet();
        },
      ),
      onTap: () {
        parent.nagivate(song);
      },
    );
  }
}
