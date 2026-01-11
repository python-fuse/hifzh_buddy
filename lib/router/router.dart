import 'package:go_router/go_router.dart';
import 'package:hifzh_buddy/pages/home_page.dart';
import 'package:hifzh_buddy/pages/surah_page.dart';
import 'package:hifzh_buddy/pages/surahs_list_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (ctx, state) => HomePage()),
    GoRoute(path: '/list', builder: (ctx, state) => SurahsListPage()),
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
