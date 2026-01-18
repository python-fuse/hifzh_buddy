import json
import sqlite3

conn = sqlite3.connect("ayahinfo.db")
cursor = conn.cursor()

cursor.execute("""
    SELECT page_number, line_number, sura_number, ayah_number, position, min_x, max_x, min_y, max_y
    FROM glyphs
    ORDER BY page_number, line_number, sura_number, ayah_number, position
    """)


pages = {}

for row in cursor.fetchall():
    page, line, surah, ayah, pos, minX, maxX, minY, maxY = row

    if (str(page)) not in pages:
        pages[str(page)] = {}

    verse_key = f"{surah}_{ayah}"

    if verse_key not in pages[str(page)]:
        pages[str(page)][verse_key] = []

    pages[str(page)][verse_key].append([pos, line, minX, maxX, minY, maxY])


with open("ayah_coords.json", "w") as f:
    json.dump(pages, f, separators=(",", ":"))
conn.close()
