import json
import subprocess as sp
import time

with open("quran_with_audio.json", "r") as f:
    surahs = json.load(f)


fatiha = surahs[0]

for ayah in fatiha["ayahs"]:
    print("Playing: ", ayah["audio"])
    sp.call(
        [
            "ffplay",
            "-nodisp",
            "-autoexit",
            "-loglevel",
            "quiet",
            f"../assets/ayahs/{ayah['audio']}",
        ]
    )
    time.sleep(0.2)
