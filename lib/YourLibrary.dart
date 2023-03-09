// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:testingapp/util.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/svg.dart';

class YourLibrary extends StatefulWidget {
  const YourLibrary({Key? key}) : super(key: key);
  @override
  State<YourLibrary> createState() => _YourLibraryState();
}

class _YourLibraryState extends State<YourLibrary> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight).
          withGradient(LinearGradient(colors: [MyColors.primaryColor1,MyColors.primaryColor2
          ],begin: Alignment.topLeft, end: Alignment.bottomRight),
          ).make(),
          AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: SvgPicture.asset("assets/icons/menu.svg"),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: "Melodyyy".text.xl4.bold.white.make().shimmer(
                primaryColor: Vx.purple300, secondaryColor: Colors.white
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(100).p16(),
        ],
      );
  }
}
