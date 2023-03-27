import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/common/widgets/video_configration/videdo_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  final preferences = await SharedPreferences.getInstance();
  final repository = PlaybackConfigRepository(preferences);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => PlaybackConfigViewModel(repository),
      ),
    ],
    child: const TikTokApp(),
  ));
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    S.load(const Locale("en")); //App 기본 국가설정강제
    return ValueListenableBuilder(
      valueListenable: darkMode,
      builder: (context, value, child) => MaterialApp.router(
        routerConfig: router, // router 사용, 따라서 home: 이 필요없다.
        debugShowCheckedModeBanner: false, //디버그모드 표시여부
        title: 'TikTok Clone',
        localizationsDelegates: const [
          S.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en"),
          Locale("ko"),
        ],
        themeMode: darkMode.value ? ThemeMode.dark : ThemeMode.system,
        theme: ThemeData(
            useMaterial3: true,
            textTheme: Typography.blackMountainView,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            bottomAppBarTheme: BottomAppBarTheme(
              color: Colors.grey.shade50,
            ),
            primaryColor: const Color(0xFFE9435A),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFFE9435A),
            ),
            splashColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Colors.black, //appbar foregroundcolor is black, but
                fontSize: Sizes.size16 + Sizes.size2,
                fontWeight: FontWeight.w600,
              ),
              centerTitle:
                  true, //android default left align, but apple default center align
            ),
            tabBarTheme: TabBarTheme(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
              indicatorColor: Colors.black,
            ),
            listTileTheme: const ListTileThemeData(iconColor: Colors.black)),

        darkTheme: ThemeData(
          useMaterial3: true,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          textTheme: Typography.whiteMountainView,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.grey.shade900,
            titleTextStyle: const TextStyle(
              color: Colors.white, //appbar foregroundcolor is black, but
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: true,
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
          ),
          tabBarTheme: TabBarTheme(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade700,
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade900,
          ),
          primaryColor: const Color(0xFFE9435A),
        ),

        // home: const SignUpScreen(), //default run
      ),
    );
  }
}
