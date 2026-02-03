-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Create actual user id variable
SET @actualUserId = 1;

-- Get watchlist of current user from view ordered alphabetically by title
SELECT `title`, `year`, `director` FROM `watchlists_detailed`
WHERE `user_id` = @actualUserId
ORDER BY `title`;

-- User filters inside their watchlist based on decade and name of director. Sorted by year, if in the same year, than sorted alphabetically.
SELECT `title`, `year`, `director` FROM `watchlists_detailed`
WHERE `user_id` = @actualUserId
AND `director` LIKE '%lynch%'
AND `year` BETWEEN 1980 AND 1989
ORDER BY `year` DESC, `title`;

-- Display the number of movies of current user
SELECT COUNT(*) AS 'Number of movies on your watchlist:' FROM `watchlists`
WHERE `user_id` = @actualUserId;

-- Get a list of followed friends by current user
SELECT `username` FROM `users`
WHERE `id` IN (
    SELECT `followed_user_id` FROM `follows`
    WHERE `user_id` = @actualUserId
);

-- Get a random movie from watchlist of current user
SELECT `title`, `year`, `director` FROM `watchlists_detailed`
WHERE `user_id` = @actualUserId
ORDER BY RAND()
LIMIT 1;

-- Get a random movie that is both on user's and a choosen friend's watchlist
SELECT `title`, `year`, `director` FROM `watchlists_detailed`
WHERE `user_id` = @actualUserId
INTERSECT
SELECT `title`, `year`, `director` FROM `watchlists_detailed`
WHERE `user_id` = (
    SELECT `id` FROM `users`
    WHERE `username` = 'friendname'
)
ORDER BY RAND()
LIMIT 1;

-- Insert a single movie to user's watchlist
INSERT INTO `watchlists` (`user_id`, `movie_id`)
SELECT
    @actualUserId,
    `id` FROM `movies`
    WHERE `id` = 123;

-- Copy all movies from friend's watchlist to current user's watchlist
INSERT INTO `watchlists` (`user_id`, `movie_id`)
SELECT
    @actualUserId,
    `movie_id` FROM `watchlists`
    WHERE `user_id` = (
        SELECT `id` FROM `users`
        WHERE `username` = 'friendname'
    );

-- Delete a single movie from user's watchlist
DELETE FROM `watchlists`
WHERE `user_id` = @actualUserId
AND `movie_id` = (
    SELECT `id` FROM `movies`
    WHERE `id` = 123
);

-- Follow a user
INSERT INTO `follows` (`user_id`, `followed_user_id`)
SELECT
    @actualUserId,
    `id` FROM `users`
    WHERE `username` = 'friendname';

-- Unfollow a user
DELETE FROM `follows`
WHERE `user_id` = @actualUserId
AND `followed_user_id` = (
    SELECT `id` FROM `users`
    WHERE `username` = 'friendname'
);

-- Make a review
INSERT INTO `reviews` (`user_id`, `movie_id`, `rating`, `review`)
SELECT
    @actualUserId,
    `id`,
    8,
    'Was a fun movie!'
FROM `movies`
WHERE `id` = 123;

-- Get all the activities of current user for 2025. Sorted by date.
SELECT `datetime`, `type`, `title`, `year`, `username` FROM `activity_feed`
WHERE `user_id` = @actualUserId
AND `datetime` BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59'
ORDER BY `datetime` DESC;

-- STATISTICS
-- TOP10 movies on watchlists
SELECT `title`, `year`, COUNT(DISTINCT(`movie_id`)) AS 'number of watchlists' FROM `watchlists`
JOIN `movies` ON `movies`.`id` = `watchlists`.`movie_id`
GROUP BY `movie_id`
ORDER BY `number of watchlists` DESC
LIMIT 10;

-- TOP10 user with most followers
SELECT `username`, COUNT(*) AS `number of followers` FROM `follows`
JOIN `users` ON `users`.`id` = `follows`.`followed_user_id`
GROUP BY `followed_user_id`
ORDER BY `number of followers` DESC
LIMIT 10;

-- TOP10 movies by average ratings of all user
SELECT `title`, `year`, `director`, AVG(`rating`) AS 'average rating' FROM `reviews`
JOIN `movies` ON `movies`.`id` = `reviews`.`movie_id`
GROUP BY `movie_id`
ORDER BY `average rating` DESC
LIMIT 10;
