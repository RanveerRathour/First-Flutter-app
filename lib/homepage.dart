// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:testingapp/util.dart';
import 'home.dart';
import 'YourLibrary.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _selectedItem = 0;
  // final _pagesData = [home(), Search(), YourLibrary()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       ListTile(
      //         leading: Icon(Icons.person),
      //         title: Text("Pankaj Kumar"),
      //         subtitle: Text("Developer"),
      //         trailing: Icon(Icons.arrow_forward_ios),
      //         onTap: () {
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
      //             return ListTileNavigation(title: "pankaj ");
      //           }));
      //         },
      //       ),
      //
      //     ],
      //   ),
      // ),
          body: home(),//_pagesData[_selectedItem],

      // bottomNavigationBar: BottomNavigationBar(
      //   // ignore: prefer_const_literals_to_create_immutables
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
      //     BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Your Library"),
      //   ],
      //   currentIndex: _selectedItem,
      //   onTap: (setValue) {
      //     setState(() {
      //       _selectedItem = setValue;
      //     });
      //   },
      //   //type: BottomNavigationBarType.fixed,
      //   fixedColor: Colors.white,
      //   backgroundColor: MyColors.primaryColor2,
      // ),
    );
  }
}




















