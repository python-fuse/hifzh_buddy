# Hifzh Buddy

Hifzh Buddy is a Flutter application designed to assist with Quran memorization (Hifzh). It provides tools for reading, listening, and tracking your progress.

## ⚠️ Important Note: Audio Files

**Please note that the Quran audio files are NOT included in this repository** due to size constraints.

To enable audio playback features:

1.  You must obtain the necessary Quran audio files (MP3 format).
2.  Place them in the `assets/quranAudio/` directory.
3.  Ensure the file naming convention matches what the application expects (typically mapped by Surah and Ayah, e.g., `assets/quranAudio/001001.mp3` for Surah Al-Fatiha, Verse 1).

If these files are missing, the audio player functionality will throw errors or fail to load.

**Audio Source:**
You can download structured verse-by-verse audio files from [EveryAyah](https://everyayah.com/recitations_ayat.html).

## Getting Started

This project is a Flutter application.

### Prerequisites

- Flutter SDK (version 3.10.1 or higher recommended)
- Dart SDK

### Installation

1.  **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd hifzh_buddy
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Setup Audio Assets:**

    - Create the directory `assets/quranAudio/` if it doesn't exist.
    - Add your Quran audio files into this folder.

4.  **Run the app:**
    ```bash
    flutter run
    ```

## Resources

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
