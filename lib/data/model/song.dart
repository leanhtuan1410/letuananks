import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Song {
  String id;
  String title;
  String album;
  String artist;
  String source;
  String image;
  int duration;
  Song({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.source,
    required this.image,
    required this.duration,
  });

  Song copyWith({
    String? id,
    String? title,
    String? album,
    String? artist,
    String? source,
    String? image,
    int? duration,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      album: album ?? this.album,
      artist: artist ?? this.artist,
      source: source ?? this.source,
      image: image ?? this.image,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'album': album,
      'artist': artist,
      'source': source,
      'image': image,
      'duration': duration,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'] as String,
      title: map['title'] as String,
      album: map['album'] as String,
      artist: map['artist'] as String,
      source: map['source'] as String,
      image: map['image'] as String,
      duration: map['duration'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) =>
      Song.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Song(id: $id, title: $title, album: $album, artist: $artist, source: $source, image: $image, duration: $duration)';
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.album == album &&
        other.artist == artist &&
        other.source == source &&
        other.image == image &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        album.hashCode ^
        artist.hashCode ^
        source.hashCode ^
        image.hashCode ^
        duration.hashCode;
  }
}
