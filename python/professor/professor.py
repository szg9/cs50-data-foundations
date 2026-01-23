import random


def main():
    level = get_level()
    tasks = range(10)
    score = 0

    for _ in tasks:
        x, y = (generate_integer(level), generate_integer(level))
        solution = str(x + y)
        solved_task = f"{x} + {y} = {solution}"
        attempts = 0

        while attempts < 3:
            guess = input(f"{x} + {y} = ")

            if guess == solution:
                score += 1
                break

            elif attempts < 3:
                print("EEE")
                attempts += 1

            else:
                attempts += 1

        if attempts == 3:
            print(solved_task)

    print(f"Score: {score}")


def get_level():
    while True:
        try:
            level = int(input("Level: "))
            if level in [1, 2, 3]:
                return level
        except ValueError:
            pass


def generate_integer(level):
    if level == 1:
        return random.randint(0, 9)

    elif level == 2:
        return random.randint(10, 99)

    elif level == 3:
        return random.randint(100, 999)


if __name__ == "__main__":
    main()