import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:try_stream_builder/api/song_api.dart';
import 'package:try_stream_builder/model/song.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}): super(key: key);

  // const MyApp({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<List<Song>> futureSongs;

  Future<List<Song>> _fetchSongs() async {
    List<Song> songs=[];
    songs = await SongApi.getSongs();
    return songs;
  }

  @override
  void initState() {
    super.initState();
    futureSongs = _fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("try_flutter_api")),
      body: FutureBuilder(
          future: futureSongs,
          builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => _buildLoadingSongCard()
              );
            }else if(snapshot.connectionState==ConnectionState.done&&snapshot.hasData){
              if(snapshot.data!.isEmpty){return _buildNoData("No Data");}
              else{
                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context,index)=> _buildSongCard(index,snapshot.data![index])
                  ),
                );
              }
            }else{return _buildNoData("No Data");}
          }
      ),
    );
  }

  Widget _buildSongCard(int index, Song song){
    return SizedBox(
      height: 80,
      child: InkWell(
        onTap: (){print("Song["+index.toString()+"]: "+song.songTitle+" tapped.");},
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Row(children: <Widget>[
            Container(
              width: 80,
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
                _buildStatusInt(song.statusInt)
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
    setState(() {futureSongs = _fetchSongs();});
    return;
  }

  Widget _buildStatusInt(int? statusInt){
    // return Container(
    //   padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 4.0),
    //   child: Text(statusInt.toString()),
    // );
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          statusInt==0?Text("0",style: TextStyle(color: Colors.green),):Text("0",style: TextStyle(color: Colors.black),),
          statusInt==1?Text("1",style: TextStyle(color: Colors.green),):Text("1",style: TextStyle(color: Colors.black),),
        ],
      ),
    );
  }
}