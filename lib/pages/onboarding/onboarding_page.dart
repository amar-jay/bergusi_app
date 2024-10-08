import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/dot_indicators.dart';
import '../../constants.dart';
import '../../routes.dart';

import 'components/onboarding_content.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController _pageController;
  int _pageIndex = 0;
  final List<Onboard> _onboardData = [
    // Onboard(
    //   image: "assets/Illustration/Illustration-1.png",
    //   imageDarkTheme: "assets/Illustration/Illustration_darkTheme_1.png",
    //   title: "Get those shopping \nbags filled",
    //   description:
    //       "Add any item you want to your cart, or save it on your wishlist, so you don’t miss it in your future purchases.",
    // ),
    // Onboard(
    //   image: "assets/Illustration/Illustration-2.png",
    //   imageDarkTheme: "assets/Illustration/Illustration_darkTheme_2.png",
    //   title: "Fast & secure \npayment",
    //   description: "There are many payment options available for your ease.",
    // ),
    Onboard(
      image: "assets/Illustration/Illustration-3.png",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_3.png",
      title: "Drone tracking",
      description:
          "Evaluate, monitor, and control your autonous drone without needing to directly be in contact.",
    ),
    Onboard(
      image: "assets/Illustration/Illustration-4.png",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_0.png",
      title: "Find your drone on the map",
      description:
          "Easily find the best estimated locatation of your unmanned nonGPS drone on the map.",
    ),
    Onboard(
      image: "assets/Illustration/Illustration-0.png",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_0.png",
      title: "A friendly UI Experience",
      description:
          "An easy to use application to control and monitor your autonomous drone.",
    ),
  ];

  @override
  void initState() {
    // if user is logged in to firebase then navigate to home page
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, ipAddressPageRoute, ModalRoute.withName(logInPageRoute));
      }
    });
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, logInPageRoute);
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardData.length,
                  onPageChanged: (value) {
                    setState(() {
                      _pageIndex = value;
                    });
                  },
                  itemBuilder: (context, index) => OnboardingContent(
                    title: _onboardData[index].title,
                    description: _onboardData[index].description,
                    image: (Theme.of(context).brightness == Brightness.dark &&
                            _onboardData[index].imageDarkTheme != null)
                        ? _onboardData[index].imageDarkTheme!
                        : _onboardData[index].image,
                    isTextOnTop: index.isOdd,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    _onboardData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: defaultPadding / 4),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageIndex < _onboardData.length - 1) {
                          _pageController.nextPage(
                              curve: Curves.ease, duration: defaultDuration);
                        } else {
                          Navigator.pushNamed(context, logInPageRoute);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Arrow - Right.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;
  final String? imageDarkTheme;

  Onboard({
    required this.image,
    required this.title,
    this.description = "",
    this.imageDarkTheme,
  });
}
