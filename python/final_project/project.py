import db

import argparse
from tabulate import tabulate
from datetime import date
import csv
import re


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-a", "--add", action="store_true")
    parser.add_argument("-g", "--get", nargs="*")
    parser.add_argument("-m", "--modify")
    parser.add_argument("-d", "--delete")
    parser.add_argument("-e", "--export", nargs="*")
    args = parser.parse_args()

    if args.add:
        mood, tags, comment = prompt_entry()
        db.add(mood, tags, comment)

        print(f"Record has been successfully added.")

    elif args.get:
        try:
            rows = get_rows(args.get)

            table = create_table(rows)
            print(table)

        except ValueError as error:
            print(error)

    elif args.modify:
        dates = [args.modify]

        if validate_dates(dates):
            print(f"Updating record on {dates[0]}...")

            mood, tags, comment = prompt_entry()

            db.modify(dates, mood, tags, comment)

            print(f"Record on {dates[0]} has been successfully modified.")

        else:
            print("Invalid date format. Valid format: YYYY-MM-DD")

    elif args.delete:
        dates = [args.delete]

        if validate_dates(dates):
            db.delete(dates)
            print(f"Record on {dates[0]} has been successfully removed.")

        else:
            print("Invalid date format. Valid format: YYYY-MM-DD")

    elif args.export:
        try:
            rows = get_rows(args.export)

            with open("moods.csv", "w", newline="", encoding="utf-8") as file:
                writer = csv.writer(file)
                writer.writerow(["Date", "Mood", "Tags", "Comment"])
                writer.writerows(rows)

                print(f"Exported {len(rows)} rows to moods.csv")

        except ValueError as error:
            print(error)

    else:
        parser.print_help()


def prompt_entry():
    while True:
        try:
            mood = int(input("Your mood right now (1-10): "))

            if 1 <= mood <= 10:
                break

        except ValueError:
            print("Invalid input. You should input an integer between 1 and 10")

    while True:
        tags = input("Words that describe your feelings (optional): ")

        if validate_tags(tags):
            tags = set(tag.lower() for tag in tags.split(", "))
            break

        else:
            print(
                "Invalid input. You should input a single word or multiple words separated by comma and space."
            )

    comment = input("Free-text comment (optional): ")

    return mood, tags, comment


def get_rows(dates):
    if not 1 <= len(dates) <= 2:
        raise ValueError("Invalid number of command-line arguments. You should input 1 or 2 dates.")

    if not validate_dates(dates):
        raise ValueError("Invalid date format. Valid format: YYYY-MM-DD")

    else:
        return db.get(dates)


def validate_tags(text):
    if not text.strip():
        return True

    pattern = r"[A-Za-z]+(, [A-Za-z]+)*"

    return re.fullmatch(pattern, text)


def validate_dates(input_dates):
    try:
        for input_date in input_dates:
            date.fromisoformat(input_date)
        return True

    except ValueError:
        return False


def create_table(rows):
    return tabulate(rows, ["Date", "Mood", "Tags", "Comment"], tablefmt="psql")


if __name__ == "__main__":
    main()
