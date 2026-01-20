import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/audio_player_provider.dart';
import 'package:hifzh_buddy/providers/quran_audio_service_provider.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/providers/session_config_provider.dart';
import 'package:hifzh_buddy/uitls/constants.dart';
import 'package:hifzh_buddy/widgets/button.dart';

class BottomSettings extends ConsumerStatefulWidget {
  final VoidCallback onApply;
  final int? initialStartSurah;
  final int? initialStartVerse;
  final int? initialEndSurah;
  final int? initialEndVerse;
  const BottomSettings({
    super.key,
    required this.onApply,
    this.initialStartSurah,
    this.initialStartVerse,
    this.initialEndSurah,
    this.initialEndVerse,
  });

  @override
  ConsumerState<BottomSettings> createState() => _BottomSettingsState();
}

class _BottomSettingsState extends ConsumerState<BottomSettings> {
  late FixedExtentScrollController _startSurahController;
  late FixedExtentScrollController _startAyahController;
  late FixedExtentScrollController _endSurahController;
  late FixedExtentScrollController _endAyahController;

  late FixedExtentScrollController _reciterController;

  int _currentSurahIndex = 0;
  int _currentAyahIndex = 0;
  int _currentEndSurahIndex = 0;
  int _currentEndAyahIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with default values
    _startSurahController = FixedExtentScrollController(initialItem: 0);
    _startAyahController = FixedExtentScrollController(initialItem: 0);
    _endSurahController = FixedExtentScrollController(initialItem: 0);
    _endAyahController = FixedExtentScrollController(initialItem: 0);
    _reciterController = FixedExtentScrollController(initialItem: 0);
  }

  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitialized) {
      _hasInitialized = true;

      final config = ref.read(sessionConfigProvider);

      // Calculate initial positions (READ only, no WRITE)
      _currentSurahIndex = (widget.initialStartSurah ?? config.startSurah) - 1;
      _currentAyahIndex = (widget.initialStartVerse ?? config.startVerse) - 1;
      _currentEndSurahIndex = (widget.initialEndSurah ?? config.endSurah) - 1;
      _currentEndAyahIndex = (widget.initialEndVerse ?? config.endVerse) - 1;

      // Jump controllers to correct positions
      _startSurahController.jumpToItem(_currentSurahIndex);
      _startAyahController.jumpToItem(_currentAyahIndex);
      _endSurahController.jumpToItem(_currentEndSurahIndex);
      _endAyahController.jumpToItem(_currentEndAyahIndex);

      final reciterIndex = reciters.indexWhere(
        (r) => r.id == ref.read(selectedReciterProvider).id,
      );
      if (reciterIndex >= 0) {
        _reciterController.jumpToItem(reciterIndex);
      }

      // DO NOT update the provider here - just read from it
      // The provider already has the correct state, we're just syncing the UI to it
    }
  }

  @override
  Widget build(BuildContext context) {
    final surahs = ref.watch(surahsProvider).value;
    final config = ref.watch(sessionConfigProvider);
    final configNotifier = ref.watch(sessionConfigProvider.notifier);

    if (surahs == null) return const CircularProgressIndicator();

    final maxStartAyahs = surahs[_currentSurahIndex].ayahs.length;
    final maxEndAyahs = surahs[_currentEndSurahIndex].ayahs.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Session Settings",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Reciter Picker
            Column(
              children: [
                Text("Reciter", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListWheelScrollView.useDelegate(
                    controller: _reciterController,
                    itemExtent: 40,
                    magnification: 1.1,
                    useMagnifier: true,
                    onSelectedItemChanged: (index) {
                      ref.read(selectedReciterProvider.notifier).state =
                          reciters[index];
                      log(ref.read(selectedReciterProvider.notifier).state.id);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Text(
                          reciters[index].englishName,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                        );
                      },
                      childCount: reciters.length,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              "Recitation Range",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text("Start", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),

            // Start Range Pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Start Surah
                Column(
                  children: [
                    const Text("Surah"),
                    SizedBox(
                      height: 120,
                      width: 150,
                      child: ListWheelScrollView.useDelegate(
                        controller: _startSurahController,
                        itemExtent: 40,
                        magnification: 1.1,
                        useMagnifier: true,
                        onSelectedItemChanged: (index) {
                          final surah = surahs[index];
                          final maxVerses = surah.ayahs.length;
                          setState(() {
                            _currentSurahIndex = index;
                            _currentAyahIndex = 0;
                            _startAyahController.jumpToItem(0);

                            // When start surah changes, update end surah and end ayah to match this surah's end
                            _currentEndSurahIndex = index;
                            _currentEndAyahIndex = maxVerses - 1;
                            _endSurahController.jumpToItem(index);
                            _endAyahController.jumpToItem(maxVerses - 1);
                          });

                          configNotifier.updateStartSurah(index + 1);
                          configNotifier.updateStartVerse(1);
                          configNotifier.updateEndSurah(index + 1, maxVerses);
                          configNotifier.updateEndVerse(maxVerses);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Text(
                              surahs[index].englishName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            );
                          },
                          childCount: surahs.length,
                        ),
                      ),
                    ),
                  ],
                ),
                // Start Ayah
                Column(
                  children: [
                    const Text("Verse"),
                    SizedBox(
                      height: 120,
                      width: 100,
                      child: ListWheelScrollView.useDelegate(
                        controller: _startAyahController,
                        itemExtent: 40,
                        magnification: 1.1,
                        useMagnifier: true,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _currentAyahIndex = index;
                          });
                          configNotifier.updateStartVerse(index + 1);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            );
                          },
                          childCount: maxStartAyahs,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text("End", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),

            // End Range Pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // End Surah
                Column(
                  children: [
                    const Text("Surah"),
                    SizedBox(
                      height: 120,
                      width: 150,
                      child: ListWheelScrollView.useDelegate(
                        controller: _endSurahController,
                        itemExtent: 40,
                        magnification: 1.1,
                        useMagnifier: true,
                        onSelectedItemChanged: (index) {
                          final surah = surahs[index];
                          final maxVerses = surah.ayahs.length;
                          setState(() {
                            _currentEndSurahIndex = index;
                            _currentEndAyahIndex = maxVerses - 1;
                            _endAyahController.jumpToItem(maxVerses - 1);
                          });
                          configNotifier.updateEndSurah(index + 1, maxVerses);
                          configNotifier.updateEndVerse(maxVerses);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Text(
                              surahs[index].englishName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            );
                          },
                          childCount: surahs.length,
                        ),
                      ),
                    ),
                  ],
                ),
                // End Ayah
                Column(
                  children: [
                    const Text("Verse"),
                    SizedBox(
                      height: 120,
                      width: 100,
                      child: ListWheelScrollView.useDelegate(
                        controller: _endAyahController,
                        itemExtent: 40,
                        magnification: 1.1,
                        useMagnifier: true,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _currentEndAyahIndex = index;
                          });
                          configNotifier.updateEndVerse(index + 1);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            );
                          },
                          childCount: maxEndAyahs,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Speed Section
            Text("Speed", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [0.5, 0.75, 1.0, 1.25, 1.5, 1.75].map((speed) {
                final isSelected = config.playbackSpeed == speed;
                return ChoiceChip(
                  label: Text('${speed}x', style: TextStyle(fontSize: 14)),
                  selected: isSelected,
                  onSelected: (_) => configNotifier.updatePlaybackSpeed(speed),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Verse Repetition
            Text("Per verse", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                for (int i in [1, 2, 3, -1]) // -1 for loop
                  Expanded(
                    child: ChoiceChip(
                      label: SizedBox(
                        width: double.infinity,
                        child: Text(
                          i == -1 ? 'Loop' : '$i time${i > 1 ? 's' : ''}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      selected: config.verseReps == i,
                      onSelected: (_) => configNotifier.updateVerseReps(i),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Range Repetition
            Text("Per range", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                for (int i in [1, 2, 3, -1])
                  Expanded(
                    child: ChoiceChip(
                      label: SizedBox(
                        width: double.infinity,
                        child: Text(
                          i == -1 ? 'Loop' : '$i time${i > 1 ? 's' : ''}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      selected: config.rangeReps == i,
                      onSelected: (_) => configNotifier.updateRangeReps(i),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: Button(
                text: "Play",
                onPressed: () async {
                  try {
                    await ref.read(audioPlayerProvider.notifier).loadAudio();

                    final audioState = ref.read(audioPlayerProvider);

                    if (audioState.hasError) {
                      return;
                    }

                    final player = ref
                        .read(audioPlayerProvider.notifier)
                        .player;

                    player.play();

                    widget.onApply();
                  } catch (e, stack) {
                    log(' Error in play button', error: e, stackTrace: stack);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _startSurahController.dispose();
    _startAyahController.dispose();
    _endSurahController.dispose();
    _endAyahController.dispose();
    _reciterController.dispose();
    super.dispose();
  }
}
