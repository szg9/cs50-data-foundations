CREATE TABLE "moods" (
    "id" INTEGER,
    "date" TEXT NOT NULL UNIQUE,
    "mood" INTEGER NOT NULL CHECK("mood" BETWEEN 1 AND 10),
    "comment" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE "tags" (
    "id" INTEGER,
    "name" TEXT UNIQUE NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "mood_tags" (
    "mood_id" INTEGER NOT NULL,
    "tag_id" INTEGER NOT NULL,
    UNIQUE ("mood_id", "tag_id"),
    PRIMARY KEY ("mood_id", "tag_id"),
    FOREIGN KEY("mood_id") REFERENCES "moods"("id"),
    FOREIGN KEY("tag_id") REFERENCES "tags"("id")
);
