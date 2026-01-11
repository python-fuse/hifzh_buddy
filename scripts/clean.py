import json

with open("quran.json", "r") as buffer:
    surahs = json.load(buffer)


def addAudioTag(surahs):
    tagged = []

    # 023001
    for i, surah in enumerate(surahs):
        for ayah in surah["ayahs"]:
            ayah["audio"] = (
                f"{str(surah['number']).rjust(3, '0')}{str(ayah['numberInSurah']).rjust(3, '0')}.mp3"
            )
        tagged.append(surah)

    return tagged


if __name__ == "__main__":
    tagged = addAudioTag(surahs)
    with open("quran_with_audio.json", "w+") as b:
        json.dump(tagged, b, indent=2)
