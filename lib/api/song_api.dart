import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:try_stream_builder/localdb/song_dao.dart';
import 'package:try_stream_builder/model/song.dart';

class SongApi{

  static Future<List<Song>> getSongs() async {

    String completeUrl = "https://itunes.apple.com/search?term=chrisye";
    print("getSongs "+completeUrl);

    List<Song> songs=[];
    SongDao songDao = SongDao();

    try{ //try to pull new data from internet and save it to db. if offline/timeout, just load the existing sqlite data
      var responseFromServer = await http.get(Uri.parse(completeUrl)).timeout(const Duration(seconds:30));
      print("getSongs res: "+responseFromServer.body.toString());
      Iterable list = json.decode(utf8.decode(responseFromServer.bodyBytes))['results'];
      songs = list.map((model) => Song.fromJson(model)).toList();
      await songDao.deleteSongs();//for fresh clean data
      await songDao.saveSongs(songs);//for fresh clean data
    }catch(e){ //do nothing on error.
      print("getSongs error1: "+e.toString());
    }

    try{//03: always load last available data from db even in error. might return empty .
      songs = await songDao.loadSongs();
    }catch(e){print("getSongs error2: "+e.toString());}

    return songs;
  }

}