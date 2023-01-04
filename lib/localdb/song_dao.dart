import "package:sqflite/sqflite.dart";
import 'package:try_stream_builder/localdb/database_helper.dart';
import 'package:try_stream_builder/model/song.dart';
import 'package:try_stream_builder/utils/singleton_dependency_injector.dart';


class SongDao {

  static const TABLE_SONG = "song";

  Future createTable(Database db)async{
    await db.execute("CREATE TABLE IF NOT EXISTS $TABLE_SONG (" +
        Song.SONG_ID+" INTEGER PRIMARY KEY," + //pk, int
        Song.SONG_TITLE+" TEXT," +
        Song.SONG_ALBUM+" TEXT," +
        Song.ALBUM_ART+" TEXT," +
        Song.STATUS_INT+" INTEGER);");//bool
  }

  ///always overwrite this data
  Future saveSongs(List<Song> songs) async {
    Database db = await getIt.get<DatabaseHelper>().database;
    for(int i=0;i<songs.length;i++) {
      Map<String, dynamic> rowA = {
        Song.SONG_ID: songs[i].songId,
        Song.SONG_TITLE: songs[i].songTitle,
        Song.SONG_ALBUM: songs[i].songAlbum,
        Song.ALBUM_ART: songs[i].albumArt,
        Song.STATUS_INT: songs[i].statusInt,
      };
      await db.insert(TABLE_SONG, rowA,conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Song>> loadSongs() async {
    Database db = await getIt.get<DatabaseHelper>().database;
    var songQResults = await db.query(TABLE_SONG,orderBy: Song.SONG_ID+" DESC");
    List<Song> songs = songQResults.isNotEmpty ? songQResults.map((r) => Song.fromJson(r)).toList() : [];
    return songs;
  }

  Future deleteSongs() async {
    Database db = await getIt.get<DatabaseHelper>().database;
    try{
      await db.delete(TABLE_SONG);
    }catch(e){
      print("deleteSongs: "+e.toString());
    }
    return;
  }
}