import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../config/lang/app_localization.dart';
import '../screens/temporizador/temporizador.dart';

class CustomAppBarNewAdapt extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBackButtonPressed;

  const CustomAppBarNewAdapt({Key? key, this.onBackButtonPressed})
      : super(key: key);

  @override
  _CustomAppBarNewAdaptState createState() => _CustomAppBarNewAdaptState();

  @override
  Size get preferredSize =>
      Size.fromHeight(170);
}

class _CustomAppBarNewAdaptState extends State<CustomAppBarNewAdapt> {
  late YoutubePlayerController _controller;
  bool _firstVisit = true;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'nPt8bK2gbaU',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstVisit = prefs.getBool('firstVisitAdaptacionAnatomica');
    if (firstVisit == null || firstVisit) {
      await prefs.setBool('firstVisitAdaptacionAnatomica', false);
      setState(() {
        _firstVisit = true;
      });
      _showVideoDialog();
    } else {
      setState(() {
        _firstVisit = false;
      });
    }
  }

  void _showVideoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {},
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleVideoVisibility() {
    _showVideoDialog();
  }

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
            if (widget.onBackButtonPressed != null) {
              widget.onBackButtonPressed!();
            } else {
              Navigator.pop(context);
            }
          },
          iconSize: 50,
        ),
        title: StopwatchWidget(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate('adaptacionAnatomica'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: _toggleVideoVisibility,
                    child: Text('Mostrar Video Explicativo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
