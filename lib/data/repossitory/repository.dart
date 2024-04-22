import 'package:music/data/source/source.dart';

import '../model/song.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData();
}

class DefaultReponsitory implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  @override
  Future<List<Song>?> loadData() async {
    List<Song> songs = [];
    await _remoteDataSource.loadData().then((remoteSongs) {
      if (remoteSongs == null) {
        _localDataSource.loadData().then((localSongs) {
          // ignore: unnecessary_null_comparison
          if (localSongs! == null) {
            print(songs);
            songs.addAll(localSongs);
          }
        });
      } else {
        songs.addAll(remoteSongs);
      }
    });
    return songs;
  }
}
