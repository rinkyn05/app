import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../widgets/grid_view/vegetal_grid.dart';

class VegetalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 4),
            CustomAppBarNew(
              onBackButtonPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate('Vegetal')}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0,
                    color: AppColors.adaptableColor(context),
                  ),
                ),
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: 'cTcTIBOgM9E',
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                  onReady: () {},
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0,
                    color: AppColors.adaptableColor(context),
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.translate('search'),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryRecipess(),
            ),
          ],
        ),
      ),
    );
  }
}
