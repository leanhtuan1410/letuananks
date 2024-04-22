import 'dart:async';

import 'package:music/data/model/song.dart';
import 'package:music/data/repossitory/repository.dart';

class MusicAppViewModel {
  StreamController<List<Song>> songStream = StreamController();
  void loadSong() {
    final responsitory = DefaultReponsitory();
    responsitory.loadData().then((value) => songStream.add(value!));
  }
}
