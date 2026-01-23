import sys
import csv


def main():
    if len(sys.argv) < 3:
        sys.exit("Too few command-line arguments")

    elif len(sys.argv) > 3:
        sys.exit("Too many command-line arguments")

    input = sys.argv[1]
    output = sys.argv[2]

    if not input.endswith(".csv"):
        sys.exit("Not a CSV file")

    try:
        scourgify(input, output)

    except FileNotFoundError:
        sys.exit(f"Could not read {filename}")


def scourgify(input, output):
    with open(input) as before_file, open(output, "w") as after_file:
        writer = csv.DictWriter(after_file, fieldnames=["first", "last", "house"])
        writer.writeheader()

        reader = csv.DictReader(before_file)

        for row in reader:
            last, first = row["name"].split(", ")

            writer.writerow({
                "first": first,
                "last": last,
                "house": row["house"]
            })


if __name__ == "__main__":
    main()