// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:testingapp/util.dart';
import 'package:velocity_x/velocity_x.dart';

import 'abc.dart';


class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Vx.purple400,
        child: Container(
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
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Title(color: Colors.black, child: Text(" About...", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),))

              ),
              Divider(
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Image(image: AssetImage('assets/images/playstore.png',), width: 200, height: 200,),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(top: 5.0,
                      bottom: 5.0,left: 5.0),
                  //color: Colors.white,
                  child: Text("Developed By", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
              ),
              Text(" Ranveer Rathour", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(" University no.: 201550113",style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
              showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(Icons.search,size: 40,)
          )
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset("assets/icons/menu.svg"),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: "Melody".text.xl4.bold.white.make().shimmer(
            primaryColor: Vx.purple300, secondaryColor: Colors.white
        ),
        flexibleSpace: Container(
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
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
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
        child: MyHomePage(),
    ),
    );
  }
}

















