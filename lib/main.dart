import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';

import 'Provider_Data/dark_mode.dart';
import 'Provider_Data/handle_ai.dart';
import 'Provider_Data/handle_local_data.dart';
import 'Provider_Data/provider_data.dart';
import 'Provider_Data/user_provider_count.dart';
import 'Routes/roots.dart';
import 'Routes/roots_name.dart';

void main() async {
  ChangeNotifierProvider<AppStateNotifier>(create: (_) => AppStateNotifier());
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  runApp(const ArtiFacts());
}

class ArtiFacts extends StatelessWidget {
  const ArtiFacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return UpgradeAlert(
          // upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => BottomBarProvider()),
              ChangeNotifierProvider(create: (_) => AppStateNotifier()),
              ChangeNotifierProvider(create: (_) => HandleLocal()),
              ChangeNotifierProvider(create: (_) => HandleAi()),
              ChangeNotifierProvider(create: (_) => UserProvider()),
            ],
            child: Consumer<AppStateNotifier>(
              builder: (context, appState, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  darkTheme: ThemeData.dark(),
                  onGenerateRoute: RouteGenerator.generateRoute,
                  initialRoute: RootsName.splashScreen,
                  themeMode:
                  appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
