import 'package:app/screens/login_and_register/login_or_register.dart';
import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController pageController = PageController();

  final List<String> imagesUrl = [
    "assets/images/onboarding1.png",
    "assets/images/onboarding2.png",
    "assets/images/onboarding3.png",
  ];

  final List<String> descriptionKeys = [
    'onboardingDesc1',
    'onboardingDesc2',
    'onboardingDesc3',
  ];

  final List<String> titlesKeys = [
    'onboardingTitle1',
    'onboardingTitle2',
    'onboardingTitle3',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.scaffoldBackgroundColor,
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: imagesUrl.length,
        itemBuilder: (context, index) {
          final AppLocalizations? appLocalizations =
              AppLocalizations.of(context);
          final String description =
              appLocalizations?.translate(descriptionKeys[index]) ?? '';
          final String title =
              appLocalizations?.translate(titlesKeys[index]) ?? '';

          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 50),
                  Image.asset(imagesUrl[index]),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 420,
                  decoration: BoxDecoration(
                    color: themeData.cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          title,
                          style: themeData.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          description,
                          style: themeData.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: BottomOnboarding(
                          currentPage: _currentPage,
                          pageController: pageController,
                          pageCount: imagesUrl.length,
                          onFinish: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginOrRegister(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BottomOnboarding extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final int pageCount;
  final VoidCallback onFinish;

  const BottomOnboarding({
    Key? key,
    required this.currentPage,
    required this.pageController,
    required this.pageCount,
    required this.onFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final AppLocalizations? localizations = AppLocalizations.of(context);

    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                pageCount, (index) => _buildPageIndicator(index, themeData)),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (currentPage != 0)
              _buildStyledButton(
                localizations?.translate('back') ?? "Atrás",
                () => pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
                context,
              ),
            if (currentPage != pageCount - 1)
              _buildStyledButton(
                localizations?.translate('next') ?? "Siguiente",
                () => pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
                context,
              ),
            if (currentPage == pageCount - 1)
              _buildStyledButton(
                localizations?.translate('finish') ?? "Finalizar",
                onFinish,
                context,
              ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStyledButton(
      String text, VoidCallback onPressed, BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.gdarkblue2,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        textStyle: Theme.of(context).textTheme.titleMedium,
      ),
      child: Text(text),
    );
  }

  Widget _buildPageIndicator(int index, ThemeData themeData) {
    return Container(
      width: currentPage == index ? 25 : 10,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: currentPage == index
            ? themeData.bottomNavigationBarTheme.selectedItemColor
            : themeData.bottomNavigationBarTheme.unselectedItemColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
