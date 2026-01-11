import 'package:go_router/go_router.dart';
import 'package:hifzh_buddy/pages/home_page.dart';
import 'package:hifzh_buddy/pages/surahs_list_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/list', builder: (context, state) => SurahsListPage()),
  ],
);
