import sqlite3
from datetime import date
import sys


def add(mood, tags, comment):
    with sqlite3.connect("moods.db") as conn:
        cursor = conn.cursor()

        try:
            cursor.execute(
                "INSERT INTO moods (date, mood, comment) VALUES (?, ?, ?)",
                (date.today().isoformat(), mood, comment),
            )
            mood_id = cursor.lastrowid

        except sqlite3.IntegrityError:
            print(
                "You can only record one mood entry per day. Please try to modify your entry."
            )
            sys.exit()

        for tag in tags:
            add_tag(cursor, tag)

            tag_id = get_tag_id(cursor, tag)

            add_mood_tag(cursor, mood_id, tag_id)


def get(dates):
    with sqlite3.connect("moods.db") as conn:
        cursor = conn.cursor()

        sql = """
            SELECT date, mood, GROUP_CONCAT(name), comment FROM moods m
            LEFT JOIN mood_tags mt ON mt.mood_id = m.id
            LEFT JOIN tags t ON mt.tag_id = t.id
        """

        params = ()

        if len(dates) == 1:
            sql += " WHERE m.date = ?"
            params = (dates[0],)

        elif len(dates) == 2:
            sql += " WHERE m.date BETWEEN ? AND ?"
            params = tuple(dates)

        sql += " GROUP BY m.id ORDER BY m.date"
        cursor.execute(sql, params)

        return cursor.fetchall()


def modify(date, mood, tags, comment):
    with sqlite3.connect("moods.db") as conn:
        cursor = conn.cursor()

        cursor.execute(
            """
                UPDATE moods
                SET mood = ?, comment = ?
                WHERE date = ?
            """,
            (
                mood,
                comment,
                date[0],
            ),
        )

        mood_id = get_mood_id(cursor, date[0])

        cursor.execute("DELETE FROM mood_tags WHERE mood_id = ?", (mood_id,))

        for tag in tags:
            add_tag(cursor, tag)
            tag_id = get_tag_id(cursor, tag)
            add_mood_tag(cursor, mood_id, tag_id)


def delete(date):
    with sqlite3.connect("moods.db") as conn:
        cursor = conn.cursor()
        mood_id = get_mood_id(cursor, date[0])

        cursor.execute("DELETE FROM mood_tags WHERE mood_id = ?", (mood_id,))

        cursor.execute("DELETE FROM moods WHERE id = ?", (mood_id,))


def get_mood_id(cursor, date):
    cursor.execute("SELECT id FROM moods WHERE date = ?", (date,))

    row = cursor.fetchone()

    if row is None:
        raise ValueError("No mood entry for this date")

    mood_id = row[0]

    return mood_id


def get_tag_id(cursor, tag):
    cursor.execute("SELECT id FROM tags WHERE name = ?", (tag,))

    tag_row = cursor.fetchone()

    if tag_row is None:
        raise RuntimeError(f"Failed to retrieve tag id for {tag}")
    tag_id = tag_row[0]

    return tag_id


def add_tag(cursor, tag):
    cursor.execute("INSERT OR IGNORE INTO tags (name) VALUES (?)", (tag,))


def add_mood_tag(cursor, mood_id, tag_id):
    cursor.execute(
        "INSERT OR IGNORE INTO mood_tags (mood_id, tag_id) VALUES (?, ?)",
        (mood_id, tag_id),
    )
