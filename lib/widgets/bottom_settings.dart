import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/providers/session_config_provider.dart';
import 'package:hifzh_buddy/theme/theme.dart';
import 'package:hifzh_buddy/uitls/constants.dart';
import 'package:wheel_picker/wheel_picker.dart';

class BottomSettings extends ConsumerStatefulWidget {
  const BottomSettings({super.key});

  @override
  ConsumerState<BottomSettings> createState() => _BottomSettingsState();
}

class _BottomSettingsState extends ConsumerState<BottomSettings> {
  late final WheelPickerController _startSurahController;
  late final WheelPickerController _startAyahController;

  // Track current selection ourselves
  int _currentSurahIndex = 0;
  int _currentAyahIndex = 0;

  @override
  void initState() {
    super.initState();

    final config = ref.read(sessionConfigProvider);

    _currentSurahIndex = config.startSurah - 1;
    _currentAyahIndex = config.startVerse - 1;

    _startSurahController = WheelPickerController(
      itemCount: 114,
      initialIndex: _currentSurahIndex,
    );

    _startAyahController = WheelPickerController(
      itemCount: 7,
      initialIndex: _currentAyahIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final surahs = ref.watch(surahsProvider).value;
    final config = ref.watch(sessionConfigProvider);
    final configNotifier = ref.watch(sessionConfigProvider.notifier);

    if (surahs == null) return const CircularProgressIndicator();

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
            Column(
              children: [
                Text("Reciter", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: WheelPicker(
                    looping: false,
                    selectedIndexColor: Theme.of(context).primaryColor,
                    builder: (context, index) {
                      return Text(
                        reciters[index].englishName,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                      );
                    },
                    itemCount: reciters.length,
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

            _buildStartRange(surahs, configNotifier),

            const SizedBox(height: 20),
            Text("End", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),

            _buildEndRange(surahs, configNotifier),
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
              spacing: 3,
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
              spacing: 3,
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
          ],
        ),
      ),
    );
  }

  Row _buildStartRange(
    List<Surah> surahs,
    SessionConfigNotifier configNotifier,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text("Surah"),
            SizedBox(
              height: 120,
              width: 150,
              child: WheelPicker(
                looping: false,
                controller: _startSurahController,
                selectedIndexColor: primaryColorValue,
                style: const WheelPickerStyle(surroundingOpacity: 0.6),
                onIndexChanged: (index, type) {
                  final surah = surahs[index];
                  final maxVerses = surah.ayahs.length;

                  // Update our tracked index
                  setState(() {
                    _currentSurahIndex = index;
                    _currentAyahIndex = 0;
                  });

                  // Update state
                  configNotifier.updateStartSurah(
                    surah.number,
                    // maxVerses,
                  );

                  // Reset ayah picker
                  _startAyahController.itemCount = maxVerses;
                  // _startAyahController.selected = 0;
                },
                builder: (context, index) {
                  return Text(
                    surahs[index].englishName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ],
        ),

        Column(
          children: [
            const Text("Verse"),
            SizedBox(
              height: 120,
              width: 100,
              child: WheelPicker(
                key: ValueKey('ayah_$_currentSurahIndex'),
                controller: _startAyahController,
                selectedIndexColor: primaryColorValue,
                style: const WheelPickerStyle(surroundingOpacity: 0.6),
                looping: false,
                onIndexChanged: (index, type) {
                  setState(() {
                    _currentAyahIndex = index;
                  });
                  configNotifier.updateStartVerse(index + 1);
                },
                builder: (context, index) {
                  return Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _buildEndRange(List<Surah> surahs, SessionConfigNotifier configNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text("Surah"),
            SizedBox(
              height: 120,
              width: 150,
              child: WheelPicker(
                looping: false,
                controller: _startSurahController,
                selectedIndexColor: primaryColorValue,
                style: const WheelPickerStyle(surroundingOpacity: 0.6),
                onIndexChanged: (index, type) {
                  final surah = surahs[index];
                  final maxVerses = surah.ayahs.length;

                  // Update our tracked index
                  setState(() {
                    _currentSurahIndex = index;
                    _currentAyahIndex = 0;
                  });

                  // Update state
                  configNotifier.updateStartSurah(
                    surah.number,
                    // maxVerses,
                  );

                  // Reset ayah picker
                  _startAyahController.itemCount = maxVerses;
                  // _startAyahController.selected = 0;
                },
                builder: (context, index) {
                  return Text(
                    surahs[index].englishName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ],
        ),

        Column(
          children: [
            const Text("Verse"),
            SizedBox(
              height: 120,
              width: 100,
              child: WheelPicker(
                key: ValueKey('ayah_$_currentSurahIndex'),
                controller: _startAyahController,
                selectedIndexColor: primaryColorValue,
                style: const WheelPickerStyle(surroundingOpacity: 0.6),
                looping: false,
                onIndexChanged: (index, type) {
                  setState(() {
                    _currentAyahIndex = index;
                  });
                  configNotifier.updateStartVerse(index + 1);
                },
                builder: (context, index) {
                  return Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _startSurahController.dispose();
    _startAyahController.dispose();
    super.dispose();
  }
}
