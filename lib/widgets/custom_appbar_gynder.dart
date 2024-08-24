import 'package:flutter/material.dart';
import '../screens/account/community_profile_screen.dart';
import '../screens/temporizador/temporizador.dart';

class CustomAppBarGynder extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackButtonPressed;

  const CustomAppBarGynder({Key? key, this.onBackButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (onBackButtonPressed != null) {
              onBackButtonPressed!();
            } else {
              Navigator.pop(context);
            }
          },
          iconSize: 50,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CommunityProfileScreen(),
                ));
              },
            iconSize: 50,
          ),
        ],
        title: StopwatchWidget(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
