CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT,
    `first_name` TINYTEXT NOT NULL,
    `last_name` TINYTEXT NOT NULL,
    `password` TEXT NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `schools` (
    `id` INT AUTO_INCREMENT,
    `name` TINYTEXT NOT NULL,
    `location` TINYTEXT,
    `type` ENUM('type1', 'type2', 'type3'),
    `founded` YEAR,
    PRIMARY KEY(`id`)
);

CREATE TABLE `companies` (
    `id` INT AUTO_INCREMENT,
    `name` TINYTEXT NOT NULL,
    `industry` VARCHAR(32) NOT NULL,
    `location` TINYTEXT,
    PRIMARY KEY(`id`)
);

CREATE TABLE `connects` (
    `user_a_id` INT NOT NULL,
    `user_b_id` INT NOT NULL,
    FOREIGN KEY(`user_a_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`user_b_id`) REFERENCES `users`(`id`)
);

CREATE TABLE `studies` (
    `user_id` INT NOT NULL,
    `school_id` INT NOT NULL,
    `start_date` DATE,
    `end_date` DATE,
    `degree` ENUM('BA', 'MA', 'PhD'),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`)
);

CREATE TABLE `works` (
    `user_id` INT NOT NULL,
    `company_id` INT NOT NULL,
    `start_date` DATE,
    `end_date` DATE,
    `title` VARCHAR(32),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`)
);
