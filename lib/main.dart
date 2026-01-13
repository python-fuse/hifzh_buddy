import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/audio_handler_provider.dart';
import 'package:hifzh_buddy/router/router.dart';
import 'package:hifzh_buddy/theme/theme.dart';
import 'package:quran_library/quran_library.dart';
import 'package:hifzh_buddy/service/audio_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await QuranLibrary.init();

  final audioHandler = await AudioService.init(
    builder: () => QuranAudioHandler(AudioPlayer()),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.hifzh_buddy.audio',
      androidNotificationChannelName: 'Quran Audio',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [audioHandlerProvider.overrideWithValue(audioHandler)],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Hifzh Buddy',
          theme: AppTheme(context: context).appTheme,
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
