-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` TEXT NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `movies` (
    `id` INT AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `year` YEAR NOT NULL,
    `director` VARCHAR(100) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `watchlists` (
    `user_id` INT NOT NULL,
    `movie_id` INT NOT NULL,
    PRIMARY KEY (`user_id`, `movie_id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`movie_id`) REFERENCES `movies`(`id`) ON DELETE CASCADE
);

-- Unique constraint to prevent user to review the same movie more than once
CREATE TABLE `reviews` (
    `id` INT AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `movie_id` INT NOT NULL,
    `rating` SMALLINT NOT NULL CHECK(`rating` BETWEEN 1 AND 10),
    `review` TEXT,
    UNIQUE (`user_id`, `movie_id`),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`movie_id`) REFERENCES `movies`(`id`) ON DELETE CASCADE
);

-- Check constraint to prevent user follow themself
CREATE TABLE `follows` (
    `user_id` INT NOT NULL,
    `followed_user_id` INT NOT NULL,
    CHECK (`user_id` <> `followed_user_id`),
    PRIMARY KEY (`user_id`, `followed_user_id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`followed_user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Check constraint to make sure fields are required and null based on value of type field
CREATE TABLE `activities` (
    `id` INT AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `followed_user_id` INT,
    `movie_id` INT,
    `datetime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `type` ENUM('add', 'remove', 'review', 'follow', 'unfollow') NOT NULL,
    CHECK (
        (type IN ('add','remove','review') AND `movie_id` IS NOT NULL AND `followed_user_id` IS NULL)
        OR
        (type IN ('follow','unfollow') AND `followed_user_id` IS NOT NULL AND `movie_id` IS NULL)
    ),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`followed_user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`movie_id`) REFERENCES `movies`(`id`) ON DELETE CASCADE
);

-- View for easy query of all the details of every movie by user id
CREATE VIEW `watchlists_detailed` AS
SELECT `user_id`, `title`, `year`, `director` FROM `watchlists`
JOIN `movies` ON `movies`.`id` = `watchlists`.`movie_id`;

-- View for easy query of a user's activity with detailed movie and followed user information
CREATE VIEW `activity_feed` AS
SELECT `activities`.`user_id`, `datetime`, `type`, `title`, `year`, `username` AS `followed username` FROM `activities`
LEFT JOIN `movies` ON `movies`.`id` = `activities`.`movie_id`
LEFT JOIN `users` ON `users`.`id` = `activities`.`followed_user_id`;

-- Trigger for automatically add an "add" activity after adding a movie to watchlist
DELIMITER //
CREATE TRIGGER `trg_watchlist_add`
AFTER INSERT ON `watchlists`
FOR EACH ROW
BEGIN
    INSERT INTO `activities` (`user_id`, `movie_id`, `type`)
    VALUES (NEW.`user_id`, NEW.`movie_id`, 'add');
END//

-- Trigger for automatically add a "remove" activity before deleting a movie from watchlist
CREATE TRIGGER `trg_watchlist_remove`
BEFORE DELETE ON `watchlists`
FOR EACH ROW
BEGIN
    INSERT INTO `activities` (`user_id`, `movie_id`, `type`)
    VALUES (OLD.`user_id`, OLD.`movie_id`, 'remove');
END//

-- Trigger for automatically add a "follow" activity after following a user
CREATE TRIGGER `trg_follow_add`
AFTER INSERT ON `follows`
FOR EACH ROW
BEGIN
    INSERT INTO `activities` (`user_id`, `followed_user_id`, `type`)
    VALUES (NEW.`user_id`, NEW.`followed_user_id`, 'follow');
END//

-- Trigger for automatically add a "remove" activity before deleting a movie from watchlist
CREATE TRIGGER `trg_follow_remove`
BEFORE DELETE ON `follows`
FOR EACH ROW
BEGIN
    INSERT INTO `activities` (`user_id`, `followed_user_id`, `type`)
    VALUES (OLD.`user_id`, OLD.`followed_user_id`, 'unfollow');
END//

-- Trigger for removal of movie from watchlist after user made a review
CREATE TRIGGER `trg_review_add`
AFTER INSERT ON `reviews`
FOR EACH ROW
BEGIN
    DELETE FROM `watchlists`
    WHERE `user_id` = NEW.`user_id`
    AND `movie_id` = NEW.`movie_id`;
    INSERT INTO `activities` (`user_id`, `movie_id`, `type`)
    VALUES (NEW.`user_id`, NEW.`movie_id`, 'review');
END//
DELIMITER ;

-- Index for finding the given user's watchlist
CREATE INDEX `user_index_watchlist` ON `watchlists`(`user_id`);
CREATE INDEX `movie_index_watchlist` ON `watchlists`(`movie_id`);
CREATE INDEX `user_index_follows` ON `follows`(`user_id`);
