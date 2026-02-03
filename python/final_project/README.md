# MOOD DIARY

#### Video Demo:  https://youtu.be/_2dFVjeGVyg

#### Description:
This Python program allows users to track their mood day by day.

The program operates through command-line arguments. Users should choose their action based on the following:
- **"-a", "--add":**
No additional arguments are needed. After starting the program with this command-line argument, the program prompts the user for a mood score, feeling tags, and a free-text comment. Only the mood score is required.
Feeling tags may contain only alphabetic characters, one word per tag, separated by ", " or by ",". The program reprompts the user until valid input is provided. After valid input, the data is saved to the database.

- **"-g", "--get":**
Works with 1 or 2 arguments, both dates in the format YYYY-MM-DD.
    - With one date argument, the user will receive the entry for that specific date.
    - With two date arguments, the user will receive all entries between the given dates (inclusive).
The output is displayed as a command-line table using the tabulate library.
In case of an incorrect number of arguments, the following error messages appear:
*“Invalid number of command-line arguments. You should input 1 or 2 dates.”*

- **"-m", "--modify":**
Works only with 1 command-line argument: a date in the format YYYY-MM-DD. After the user starts the program with this argument, the same input flow is applied as with "--add". After valid input, the selected date entry is updated with the new data.

- **"-d", "--delete":**
Works only with 1 command-line argument: a date in the format YYYY-MM-DD. After the user starts the program with this argument, the entry for the given date is removed from the database.

- **"-e", "--export":**
Works with 1 or 2 arguments, both dates in the format YYYY-MM-DD.
    - With one date argument, a file called moods.csv is created containing the entry for that date.
    - With two date arguments, the same export is performed for all entries between the given dates (inclusive).
In case of an incorrect number of arguments, the following error messages appear:
*“Invalid number of command-line arguments. You should input 1 or 2 dates.”*

### Implementation details:
**Input validation:**
- Mood values are validated to ensure they are integers between 1 and 10.
- Dates are validated using Python’s datetime.date.fromisoformat() to ensure correct YYYY-MM-DD formatting.
- Tags are validated using regular expressions and must contain only alphabetic characters. Tags are normalized by trimming whitespace and converting them to lowercase before being stored.

**Tag handling:**
Tags are stored in a separate table to avoid duplication. When adding or modifying an entry:
- New tags are inserted only if they do not already exist.
- Existing tags are reused via their unique IDs.
- A junction table is used to associate mood entries with multiple tags.

**Database integrity and transactions:**
All database operations are executed using context managers (with sqlite3.connect(...)) to ensure changes are committed automatically and resources are properly released.

**Export functionality:**
The export feature writes queried data into a CSV file (moods.csv) using Python’s built-in csv module. The exported file includes column headers and supports exporting a single day or a date range.

**Separation of concerns:**
The program logic is split into two files:
- project.py handles command-line parsing, user input, validation, and output formatting.
- db.py handles all database-related operations such as inserting, updating, deleting, querying, and managing relationships between tables.

### Database:
Database connection is managed using the sqlite3 package.
There are separate tables for moods (mood score and comment) and tags because of normalization. These tables are connected by their IDs through a junction table.

**Constraints:**
- Only one mood record is allowed per day (the date field in the moods table must be UNIQUE)
- Required fields:
    - date and mood in the moods table
    - name in the tags table
- The mood field must be an integer between 1 and 10.
