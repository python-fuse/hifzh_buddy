import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsProvider);

    return surahsAsync.when(
      data: (_) {
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          Future.microtask(() => context.go('/home'));
        }
        return LoadingScreen();
      },
      error: (err, stack) => Text(err.toString()),

      loading: () => LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          duration: Duration(seconds: 1),
          tween: Tween(begin: 12.0, end: 48.0),
          curve: Curves.easeInOut,
          builder: (context, size, child) {
            return Text(
              "Hifzh Buddy",
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
