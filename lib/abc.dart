import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testingapp/util.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  runApp(const MyApp());
}

List<SongModel> songs=[];
String currentSongTitle='Please Select a song...';
int currentIndex=-1;
bool isPlayerViewVisible=false;
final OnAudioQuery _audioQuery = OnAudioQuery();
final AudioPlayer _player= AudioPlayer();
// int currentId=0;

void searchId(String title){
  String t=title.toLowerCase();
  int i=0;
  String s="";
  for(i=0;i<songs.length;i++)
  {
    String res=songs[i].toString().toLowerCase();
    int n=(res.indexOf('title:'))+6;
    int m=res.indexOf(RegExp(r','),n);
    s= res.substring(n, m).trim();
    int re=s.compareTo(t);
    if(re==0) {
      currentIndex=i;
      currentSongTitle=t;
      //currentId=songs[i].id;
      break;
    }
  }

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  // final OnAudioQuery _audioQuery = OnAudioQuery();
  // final AudioPlayer _player= AudioPlayer();

  //bool _isPlaying= false;
  // bool isPlayerViewVisible=false;


  void _changePlayerViewVisibility(){
    setState((){
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          _player.positionStream, _player.durationStream,(position, duration) => DurationState(
          position: position, total: duration?? Duration.zero
      ));
  @override
  void initState() {
    requestStoragePermission();
    super.initState();
    _player.currentIndexStream.listen((index){
      if(index!=null){
        _updateCurrentPlayingSongDetails(index);
      }
    });
  }

  @override
  void dispose(){
    super.dispose();

    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(isPlayerViewVisible){
      return Scaffold(
          backgroundColor: MyColors.primaryColor2,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 56.0, right: 20, left:20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    MyColors.primaryColor1,
                    MyColors.primaryColor2,
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Center(
                          child: Text(
                            currentSongTitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: _changePlayerViewVisibility,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: getDecoration(BoxShape.circle, const Offset(2,2),2.0,0.0),
                            child: const Icon(Icons.expand_more_rounded,size: 40, color: Colors.white70,),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                    margin: const EdgeInsets.only(top: 30,bottom: 30),
                    child: currentIndex==-1?const Icon(Icons.music_note,size: 200,):QueryArtworkWidget(
                      id: songs[currentIndex].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(30.0),

                    ),
                  ),

                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.only(bottom: 4.0),
                        decoration: getRectDecoration(BorderRadius.circular(20.0), const Offset(2, 2),2,0),
                        child: StreamBuilder<DurationState>(
                          stream: _durationStateStream,
                          builder: (context, snapshot){
                            final durationState = snapshot.data;
                            final progress = durationState?.position?? Duration.zero;
                            final total = durationState?.total?? Duration.zero;

                            return ProgressBar(
                              progress: progress,
                              total: total,
                              barHeight: 20.0,
                              baseBarColor: MyColors.primaryColor2,
                              progressBarColor: const Color(0xD2C8C8EE),
                              thumbColor: Colors.white60.withBlue(99),
                              timeLabelTextStyle: const TextStyle(
                                fontSize: 0,
                              ),
                              onSeek: (duration){
                                _player.seek(duration);
                              },
                            );
                          },
                        ),
                      ),

                      StreamBuilder<DurationState>(
                        stream: _durationStateStream,
                        builder: (context, snapshot){
                          final durationState = snapshot.data;
                          final progress = durationState?.position?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Text(
                                  progress.toString().split(".")[0],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  total.toString().split(".")[0],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),




                  //prev, play/pause & seek next control buttons
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      mainAxisSize:  MainAxisSize.max,
                      children: [
                        //skip to previous
                        Flexible(
                          child: InkWell(
                            onTap: (){
                              if(_player.hasPrevious){
                                _player.seekToPrevious();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                              child: const Icon(Icons.skip_previous, color: Colors.white70,),
                            ),
                          ),
                        ),

                        //play pause
                        Flexible(
                          child: InkWell(
                            onTap: (){
                              if(_player.playing){
                                //_isPlaying=false;
                                _player.pause();
                              }
                              else{
                                if(_player.currentIndex != null){
                                  //_isPlaying=true;
                                  _player.play();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                              decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                              child: StreamBuilder<bool>(
                                stream: _player.playingStream,
                                builder: (context, snapshot){
                                  bool? playingState = snapshot.data;
                                  if(playingState != null && playingState){
                                    return const Icon(Icons.pause, size: 30, color: Colors.white70,);
                                  }
                                  return const Icon(Icons.play_arrow, size: 30, color: Colors.white70,);
                                },
                              ),
                            ),
                          ),
                        ),

                        //skip to next
                        Flexible(
                          child: InkWell(
                            onTap: (){
                              if(_player.hasNext){
                                _player.seekToNext();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                              child: const Icon(Icons.skip_next, color: Colors.white70,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  //go to playlist, shuffle , repeat all and repeat one control buttons
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //go to playlist btn
                        Flexible(
                          child: InkWell(
                            onTap: (){_changePlayerViewVisibility();},
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration:  getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                              child: const Icon(Icons.list_alt, color: Colors.white70,),
                            ),
                          ),
                        ),

                        //shuffle playlist
                        Flexible(
                          child: InkWell(
                            onTap: (){
                              _player.setShuffleModeEnabled(true);
                              toast(context, "Shuffling enabled");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              margin:  const EdgeInsets.only(right: 30.0, left: 30.0),
                              decoration:  getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                              child: const Icon(Icons.shuffle, color: Colors.white70,),
                            ),
                          ),
                        ),

                        //repeat mode
                        Flexible(
                          child: InkWell(
                            onTap: (){
                              _player.loopMode == LoopMode.one ? _player.setLoopMode(LoopMode.all) : _player.setLoopMode(LoopMode.one);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration:  getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                              child: StreamBuilder<LoopMode>(
                                stream: _player.loopModeStream,
                                builder: (context, snapshot){
                                  final loopMode = snapshot.data;
                                  if(LoopMode.one == loopMode){
                                    return const Icon(Icons.repeat_one, color: Colors.white70,);
                                  }
                                  return const Icon(Icons.repeat, color: Colors.white70,);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          )
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                sortType: SongSortType.TITLE,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),

              builder: (context, item) {
                if (item.data == null) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                if (item.data!.isEmpty) {
                  return const Center(child: Text("No Songs Found"),);
                }

                songs.clear();
                songs = item.data!;
                //songsTitle= (item.data![currentIndex].title as List<String>);

                return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {

                      return Container(
                        margin: const EdgeInsets.only(top: 15.0,
                          left: 12.0,
                          right: 12.0,),
                        padding: const EdgeInsets.only(top: 5.0,
                            bottom: 5.0),
                        decoration: BoxDecoration(
                          // color: MyColors.primaryColor2,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              MyColors.primaryColor1,
                              MyColors.primaryColor2,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: const[
                            BoxShadow(
                              blurRadius: 4.0,
                              offset: Offset(-4, -4),
                              color: Colors.white24,
                            ),
                            BoxShadow(
                              blurRadius: 4.0,
                              offset: Offset(4, 4),
                              color: Colors.black,
                            ),
                          ], //Icon(more_vert)
                        ),

                        child: ListTile(
                          title: Text(item.data![index].displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                          ),
                          subtitle: Text(item.data![index].title),
                          trailing: const Icon(Icons.more_vert),
                          leading: QueryArtworkWidget(
                            id: item.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(Icons.music_note, size: 40,),
                          ),
                          onTap: () async {
                            currentIndex=index;
                            _changePlayerViewVisibility();
                            // String? uri=item.data![index].uri;
                            currentSongTitle=item.data![index].title;
                            toast(context,"playing: ${item.data![index].title}");
                            //await _player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
                            await _player.setAudioSource(
                              createPlaylist(item.data!),
                              initialIndex: index,
                            );
                            await _player.play();
                          },
                        ),

                      );
                    }
                );
              }
          ),


          if(currentIndex!=-1)
          Positioned(
            bottom: 0.0,
            child: Container(
              //alignment: Alignment.bottomCenter,
              height: 70.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Vx.orange400, //MyColors.primaryColor1,
                    Vx.purple600, //MyColors.primaryColor2,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:currentIndex==-1?const Icon(Icons.music_note,size: 50,):QueryArtworkWidget(
                      id: songs[currentIndex].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(30.0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              currentSongTitle,
                              overflow:
                              TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'DancingScript',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      if(_player.playing){
                        //_isPlaying=false;
                        _player.pause();
                      }
                      else{
                        if(_player.currentIndex != null){
                          //_isPlaying=true;
                          _player.play();
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.only(right: 0.0, left: 20.0),
                      // decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                      child: StreamBuilder<bool>(
                        stream: _player.playingStream,
                        builder: (context, snapshot){
                          bool? playingState = snapshot.data;
                          if(playingState != null && playingState){
                            return const Icon(Icons.pause, color: Colors.black,);// size: 10,
                          }
                          return const Icon(Icons.play_arrow, size: 35 , color: Colors.black,);// size: 30,
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      _changePlayerViewVisibility();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      margin:  const EdgeInsets.only(right: 10, left: 30.0),
                      child: const Icon(Icons.keyboard_arrow_up,  size: 35 , color: Colors.black,),
                    ),
                  )

                ],
              ),
            ),
          ),

          const SizedBox(
            height: 5.0,
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void requestStoragePermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if(!permissionStatus){
      await _audioQuery.permissionsRequest();
    }
    setState((){});
  }



  void _updateCurrentPlayingSongDetails(int index) {
    setState((){
      if(songs.isNotEmpty){
        currentSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }
  void toast(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }

  BoxDecoration getDecoration(BoxShape shape , Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: MyColors.primaryColor1,
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }

  BoxDecoration getRectDecoration(BorderRadius borderRadius, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      borderRadius: borderRadius,
      color: MyColors.primaryColor2,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }
}
ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {

  List<AudioSource> sources=[];
  for (var song in songs){
    sources.add(AudioSource.uri(Uri.parse(song.uri!)));
  }
  return ConcatenatingAudioSource(children: sources);
}

class DurationState{
  DurationState({this.position = Duration.zero, this.total=Duration.zero});
  Duration position, total;
}

class DataSearch extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){
            query="";
          },
          icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList= query.isEmpty ? ["title:No song found,"]: songs.where((p) => p.title.toLowerCase().startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index)=>ListTile(
        onTap: ()async{
          searchId(t(suggestionList,index));

          String? uri=getUri(suggestionList, index);
          Navigator.pop(context);
          await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
          await _player.play();
        },
        leading: const Icon(Icons.music_note),
        title: RichText(
          text: TextSpan(
            text: t(suggestionList,index).toString().substring(0,query.length),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold
            ),
            children: [
              TextSpan(
                  text: t(suggestionList,index).toString().substring(query.length),
                  style: const TextStyle(color: Colors.grey)
              )
            ],
          ),
        ),
      ),

      itemCount: suggestionList.length,
    );
  }
  String getUri(List l,int index){
    int n=(l[index].toString().indexOf('uri:'))+4;
    int m=l[index].toString().indexOf(RegExp(r','));
    return l[index].toString().substring(n, m).trim();
  }
  String t(List l,int index){
    int n=(l[index].toString().indexOf('title:'))+6;
    int m=l[index].toString().indexOf(RegExp(r','),n);
    return l[index].toString().substring(n, m).trim();
  }
}