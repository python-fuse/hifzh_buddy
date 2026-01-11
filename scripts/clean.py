import json
import os

with open("quran.json", "r") as buffer:
    surahs = json.load(buffer)


def addAudioTag(surahs):
    pass


if __name__ == "__main__":
    tagged = addAudioTag(surahs)
