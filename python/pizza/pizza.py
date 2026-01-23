import sys
import csv
from tabulate import tabulate


def main():
    if len(sys.argv) < 2:
        sys.exit("Too few command-line arguments")

    elif len(sys.argv) > 2:
        sys.exit("Too many command-line arguments")

    filename = sys.argv[1]

    if not filename.endswith(".csv"):
        sys.exit("Not a CSV file")

    try:
        print(tabulate(get_data(filename), headers="keys", tablefmt="grid"))

    except FileNotFoundError:
        sys.exit("File does not exist")


def get_data(filename):
    data = []

    with open(filename) as file:
        reader = csv.DictReader(file)

        for row in reader:
            data.append(row)

        return data


if __name__ == "__main__":
    main()