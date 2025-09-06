import 'package:artifact/Routes/roots_name.dart';
import 'package:flutter/material.dart';

import '../View/Home/BottomBarScreens/Bottom_Bar.dart';
import '../View/ImageGeneratorAI/detail_image_generated_view.dart';
import '../View/ImageGeneratorAI/image_generated_view.dart';
import '../View/Splash/splash_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RootsName.splashScreen:
        return buildRoute(const SplashScreen(), settings: settings);
    // case RootsName.singInWithGoogle:
    //   return buildRoute(SignInWithGoogle() , settings: settings);
      case RootsName.bottomBar:
        return buildRoute(BottomBar(), settings: settings);

    case RootsName.imageGeneratorScreen:
      return buildRoute(ImageGeneratorScreen(imgUrl: '', prompt: '',category: '',), settings: settings);
    case RootsName.detailImageGeneratedScreen:
       return buildRoute(const DetailImageGeneratedScreen(), settings: settings);

      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute(
        settings: settings, builder: (BuildContext context) => child);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'ERROR!!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Seems the route you\'ve navigated to doesn\'t exist!!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
