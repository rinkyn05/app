import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../backend/models/recipes_model.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/language_notifier.dart';
import '../../config/utils/appcolors.dart';
import '../../functions/recipes/front_recipes_firestore_services.dart';
import '../../widgets/custom_appbar_new.dart';
import 'recipes_detalle_screen.dart';

class FrontRecipesAniScreen extends StatefulWidget {
  const FrontRecipesAniScreen({Key? key}) : super(key: key);

  @override
  FrontRecipesAniScreenState createState() => FrontRecipesAniScreenState();
}

class FrontRecipesAniScreenState extends State<FrontRecipesAniScreen> {
  late Future<List<Recipes>> _recipesFuture;
  late String languageCode;

  @override
  void initState() {
    super.initState();
    languageCode = Provider.of<LanguageNotifier>(context, listen: false)
        .currentLocale
        .languageCode;
    _fetchRecipes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String newLanguageCode =
        Provider.of<LanguageNotifier>(context, listen: false)
            .currentLocale
            .languageCode;
    if (newLanguageCode != languageCode) {
      languageCode = newLanguageCode;
      _fetchRecipes();
    }
  }

  void _fetchRecipes() {
    _recipesFuture = FrontRecipesFirestoreServices()
        .getRecipes(languageCode)
        .then((recipesList) => recipesList.reversed.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate('Animal')}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
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
            SizedBox(height: 20),
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
            FutureBuilder<List<Recipes>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingFood'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate('noFoodFound'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final recipes = snapshot.data![index];
                        final isPremium = recipes.isPremium;

                        return InkWell(
                          onTap: isPremium
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipesDetalleScreen(
                                              recipes: recipes),
                                    ),
                                  );
                                },
                          child: Card(
                            margin: const EdgeInsets.all(2.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.network(
                                      recipes.imageUrl,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    recipes.nombre,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Icon(
                                    isPremium
                                        ? Icons.lock
                                        : Icons.arrow_forward_ios,
                                    color:
                                        isPremium ? Colors.red : Colors.green,
                                    size: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
            SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
