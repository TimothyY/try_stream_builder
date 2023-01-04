import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:try_stream_builder/api/song_api.dart';
import 'package:try_stream_builder/model/song.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}): super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Song> _songs = [];
  List<Song> _latestSongsOnStream = [];
  List<Song> _latestSongsOnApi = [];
  // final StreamController<List<Song>> songsStreamController = StreamController<List<Song>>.broadcast();
  // Stream<List<Song>> get stream => songsStreamController.stream;
  late Stream<List<Song>> _stream;

  late Future<List<Song>> futureSongs;
  Future<List<Song>> _fetchSongs() async {
    //this will overwrite local data with latest from api
    _latestSongsOnApi = await SongApi.getSongs();
    _songs = _latestSongsOnApi;
    // songsStreamController.add(_songs);
    return _songs;
  }

  Future<List<Song>> _updateLocalSongs(List<Song> localSongs) async {
    //this will overwrite local data with latest from api
    _latestSongsOnStream = localSongs;
    _songs = _latestSongsOnStream;
    // songsStreamController.add(_songs);
    return _songs;
  }

  @override
  void initState() {
    super.initState();
    // futureSongs = _fetchSongs();
    _stream = _fetchSongs().asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("try_flutter_api")),
      body: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => _buildLoadingSongCard()
              );
            }
            else if(snapshot.connectionState==ConnectionState.done){
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context,index)=> _buildSongCard(index,snapshot.data![index])
                ),
              );
            }else{return _buildNoData("No Data2");}

            // else if(snapshot.connectionState==ConnectionState.done&&snapshot.hasData){
            //   if(snapshot.data!.isEmpty){return _buildNoData("No Data1");}
            //   else{
            //     return RefreshIndicator(
            //       onRefresh: _handleRefresh,
            //       child: ListView.builder(
            //           physics: const AlwaysScrollableScrollPhysics(),
            //           scrollDirection: Axis.vertical,
            //           itemCount: snapshot.data!.length,
            //           itemBuilder: (context,index)=> _buildSongCard(index,snapshot.data![index])
            //       ),
            //     );
            //   }
            // }else{return _buildNoData("No Data2");}
          }
      ),
    );
  }

  Widget _buildSongCard(int index, Song song){
    return SizedBox(
      height: 108,
      child: InkWell(
        onTap: (){print("Song["+index.toString()+"]: "+song.songTitle+" tapped.");},
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Row(children: <Widget>[
            Container(
              width: 108,
              child: Image.network(song.albumArt),
            ),
            Expanded(
              flex: 1,
              child: Column(mainAxisAlignment:MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 1.0),
                  child: Text(song.songTitle),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 4.0),
                  child: Text(song.songAlbum),
                ),
                _buildStatusInt(index)
              ],),
            )],),
        ),
      ),
    );

  }

  Widget _buildLoadingSongCard()=> SizedBox(
      height: 80,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(children: <Widget>[
              Container(
                width: 80,
                color: Colors.white,
              ),
              Expanded(
                flex: 1,
                child: Column(mainAxisAlignment:MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 1.0),
                    child: Container(height: 16.0, width: 200.0, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 4.0),
                    child: Container(height: 14.0,width:100.0, color: Colors.white,),
                  ),
                ],),
              )],)),
      )
  );

  Widget _buildNoData(String explanation)=>RefreshIndicator(onRefresh: _handleRefresh,child: SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(),child: Container(height: MediaQuery.of(context).size.height*.7,child: Center(child: new Text(explanation, textAlign: TextAlign.center,),))));

  Future _handleRefresh() async {
    print("refreshing data ...");
    setState(() {_stream = _fetchSongs().asStream();});
    return;
  }

  Widget _buildStatusInt(int songIndex){
    // return Container(
    //   padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 4.0),
    //   child: Text(statusInt.toString()),
    // );
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            child: Text("0",style: _songs[songIndex].statusInt==0?TextStyle(color: Colors.white):TextStyle(color: Colors.black)),
            onPressed: () {
              _songs[songIndex].statusInt=0;
              setState(() {
                _stream = _updateLocalSongs(_songs).asStream();
              });
            }),
          ElevatedButton(
              child: Text("1",style: _songs[songIndex].statusInt==1?TextStyle(color: Colors.white):TextStyle(color: Colors.black)),
              onPressed: () {
                _songs[songIndex].statusInt=1;
                setState(() {
                  _stream = _updateLocalSongs(_songs).asStream();
                });
              },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // songsStreamController.close();
    super.dispose();
  }
}