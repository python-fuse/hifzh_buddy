class SessionConfig {
  final int startSurah;
  final int startVerse;
  final int endSurah;
  final int endVerse;
  final double playbackSpeed;
  final int verseReps;
  final int rangeReps;

  const SessionConfig({
    required this.startSurah,
    required this.startVerse,
    required this.endSurah,
    required this.endVerse,
    required this.playbackSpeed,
    required this.verseReps,
    required this.rangeReps,
  });

  SessionConfig copyWith({
    int? startSurah,
    int? startVerse,
    int? endSurah,
    int? endVerse,
    double? playbackSpeed,
    int? verseReps,
    int? rangeReps,
  }) {
    return SessionConfig(
      startSurah: startSurah ?? this.startSurah,
      startVerse: startVerse ?? this.startVerse,
      endSurah: endSurah ?? this.endSurah,
      endVerse: endVerse ?? this.endVerse,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      verseReps: verseReps ?? this.verseReps,
      rangeReps: rangeReps ?? this.rangeReps,
    );
  }
}
