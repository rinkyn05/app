import 'package:flutter/material.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../widgets/grid_view/mansory_sports.dart';

class SportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonrySports(),
      ),
    );
  }
}
