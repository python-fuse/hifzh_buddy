import 'package:go_router/go_router.dart';
import 'package:hifzh_buddy/pages/downloads_page.dart';
import 'package:hifzh_buddy/pages/home_page.dart';
import 'package:hifzh_buddy/pages/reciter_resources.dart';
import 'package:hifzh_buddy/pages/settings_page.dart';
import 'package:hifzh_buddy/pages/splash_screen.dart';
import 'package:hifzh_buddy/pages/surah_page.dart';
import 'package:hifzh_buddy/pages/surahs_list_page.dart';
import 'package:hifzh_buddy/uitls/constants.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (ctx, state) => SplashScreen()),
    GoRoute(path: '/home', builder: (ctx, state) => HomePage()),
    GoRoute(path: '/list', builder: (ctx, state) => SurahsListPage()),
    GoRoute(path: "/downloads", builder: (ctx, state) => DownloadManagerPage()),
    GoRoute(path: "/settings", builder: (ctx, state) => SettingsPage()),

    GoRoute(
      path: "/downloads/:reciterId",
      builder: (ctx, state) {
        final reciterId = state.pathParameters['reciterId'];
        final reciter = reciters.firstWhere((r) => r.id == reciterId);

        return ReciterResourcesPage(reciter: reciter);
      },
    ),
    GoRoute(
      path: '/surah/:number/:page',
      builder: (ctx, state) {
        final number = state.pathParameters['number'];
        final page = state.pathParameters['page'];

        return SurahPage(
          surahNumber: int.parse(number ?? "0"),
          page: int.parse(page ?? "0"),
        );
      },
    ),
  ],
);
