import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(const listsong());
}
class listsong extends StatefulWidget {
  const listsong({Key? key}) : super(key: key);

  @override
  State<listsong> createState() => _listsongState();
}

class _listsongState extends State<listsong> {

  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    requestStoragePermission();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),

          builder:(context, item){

            if(item.data==null){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(item.data!.isEmpty){
              return const Center(child: Text("No Songs Found"),);
            }
            return ListView.builder(
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(item.data![index].title),
                    subtitle: Text(item.data![index].displayName),
                    trailing: const Icon(Icons.more_vert),
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                    ),
                  );
                },
                itemCount: item.data!.length
            );
          }
      ),
    );
  }

  void requestStoragePermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if(!permissionStatus){
      await _audioQuery.permissionsRequest();
    }
  }
}