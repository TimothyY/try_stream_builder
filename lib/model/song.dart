class Song {

  late int songId;
  late String songTitle;
  late String songAlbum;
  late String albumArt;
  int? statusInt;

  static const SONG_ID = "trackId";
  static const SONG_TITLE = "trackName";
  static const SONG_ALBUM = "collectionName";
  static const ALBUM_ART= "artworkUrl100";
  static const STATUS_INT="statusInt";

  Song(int songId, String songTitle, String songAlbum, String albumArt, int? statusInt) {
    this.songId = songId;
    this.songTitle = songTitle;
    this.songAlbum = songAlbum;
    this.albumArt = albumArt;
    this.statusInt = statusInt;
  }

  Song.fromJson(Map jsonMap)
      : songId = jsonMap[SONG_ID],
        songTitle = jsonMap[SONG_TITLE],
        songAlbum = jsonMap[SONG_ALBUM],
        albumArt = jsonMap[ALBUM_ART],
        statusInt = jsonMap[STATUS_INT]??0;
}