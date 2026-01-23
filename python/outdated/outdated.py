months = {
    "January": "01",
    "February": "02",
    "March": "03",
    "April": "04",
    "May": "05",
    "June": "06",
    "July": "07",
    "August": "08",
    "September": "09",
    "October": "10",
    "November": "11",
    "December": "12"
}

def main():
    while True:
        try:
            date = input("Date: ").strip()
            convert(date)
            break
        except ValueError:
            pass


def convert(date):
    date_type = ""
    if "/" in date:
        date_type = "short"
        month, day, year = date.split("/")
    else:
        date_type = "long"
        month, day, year = date.split(" ")

    validate(date_type, month, day)

    if date_type == "short":
        month = add_zero(month)
    elif date_type == "long":
        month = add_zero(months[month])

    day = add_zero(pop_comma(day))

    print(f"{year}-{month}-{day}")


def validate(type, month, day):
    if type == "long" and not day.endswith(","):
        raise ValueError
    else:
        day = pop_comma(day)

    if type == "short" and (int(month) > 12 or int(day) > 31):
        raise ValueError
    elif type == "long" and (not is_month(month) or int(day) > 31):
        raise ValueError


def is_month(s):
    return s.capitalize() in months


def pop_comma(s):
    return s.replace(",", "")


def add_zero(s):
    return f"{int(s):02d}"


main()