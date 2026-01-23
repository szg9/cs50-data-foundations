# Design Document

By Gergo Szasz

Video overview: https://youtu.be/NMh1QcCOjLc

## Scope

The purpose of this MySQL database is to allow users to collect movies that they want to see in the future from a simplified movie database. The main goal is not just allow users to have their own watchlist but to let them follow other users, search movies inside their watchlists, see their activities and copy their watchlists. In addition, users are capable to see basic statistics (TOP lists) about their and friends' watchlists, reviews and activities. So, the main scope of this database are movies and users. This database does not contain detailed information about actors and other attributes in connection with movies.

## Functional Requirements

Users should do the following with database:
- add/delete movies to/from their watchlist
- set a movie to watched and review watched movies (reviewed movies automatically get removed from watchlist)
- follow/unfollow other users
- copy other user's watchlist
- get a random movie from own and/or combined with friend's watchlist
- see friend's activities

This database is not for getting detailed information about given movies, so only default information is accecable about movies. Users will also not able to comment or share information with other users in any way.

## Representation

### Entities

This database represents users, movies, reviews and activities.

**User means everyone who have registered to use the app**
**USERS** table:
id, which is the ID of the user
username, which is the choosen unique name of user: maxmimum 50 character length, required and must be unique
password, which is the choosen password of user: basic text type, required.

**Movie means every single movie from history based on IMDb records excluding series.**
**MOVIES** table:
id, which is the ID of the movie
title, which is the English title of the movie - in case there no English title, original title is used: maximum character length of 255, required
year, which is the release year of the movie: YEAR type, required (to prepare for cases when several movies have the same title)
director, which is the director of movie - in case of several directors, separated by "-": maximum character length of 100, required (to prepare when several movies have the same title and year)

**Watchlist means a group of movies saved by a user for later watching.**
**WATCHLISTS** table:
user_id, which is the ID of the users owning the watchlist: required
movie_id, which is the ID of the movie on the watchlist: required
*Primary key is a composite of user_id and movie_id.*

**Review means a number between 1-10 and a free text given by a user about a movie. Rating on the scale of 1 to 10 is obligatory for a correct review.**
**REVIEWS** table:
id, which is the ID of the review
user_id, which is the ID of user who made the review: required
movie_id, which is the ID of the movie the review is about: required
rating, which is an integer between 1 and 10 representing how the user liked the movie: required
review, which is a text-formed opinion of the user about the movie: text type, not required
*Important constraint: a given user can review a given movie only once. This constraint is enforced via a UNIQUE (user_id, movie_id) constraint.*

**Follow means that user is connected to another user. Get notified by the activities of the followed user.**
**FOLLOWS** table:
user_id, which is the ID of the user who follows another user: required
followed_user_id, which is the ID of the user who is followed by user: required
*Primary key is a composite of user_id and followed_user_id. A CHECK constraint prevents a user from following themselves.*

**Activity means any user interaction with database.**
**ACTIVITIES** table:
id, which is the ID of the interaction
user_id, which is the ID of the user who made the interaction: required
followed_user_id, which is the ID of the followed user related to the interaction: required only in case of given interaction types, else NULL
movie_id, which is the ID of the movie related to the interaction: required only in case of given interaction types, else NULL
datetime, which is the timestamp of the interaction: required, default value is current date and time
type, which is the description of interaction: ENUM list as followed:
    - add: movie has been added to watchlist
    - remove: movie has been removed from watchlist
    - review: a user has written a review
    - follow: a user has followed another user
    - unfollow: a user has unfollowed user
*Important to mention that in case of add, remove and review, movie_id is required and followed_user_id is always NULL. In case of follow and unfollow followed_user_id is required and movie_id is always NULL.*

### Relationships

Entity relationship diagram:

[![](https://mermaid.ink/img/pako:eNqdU2FvmzAQ_SvWfVqlJCIEGuJvKGMaWukqQrO2ilR5sZtYAxwdZllG-O8zkKZpOk3b_MGc3717704nKlgqLoCCwPeSrZBli5yYczsLYrLf9_uqIv40Cedhck8o4UoUbwnR53kYmOyW6eU6lYU-5dSq5bQxJU8qTdX2NxpxYDS-NCIo9bPJAVRVv7_fH23YV1XqjnCiU3Vxc8LrhEhObj69QHM_nn7043eudUHKQmDOMvGSTYK7hGxYUWwV8g6uu0_n-XfatuteEC11eqJ8H_gx2QmGb-lDy_TCJYqlVvjK9DD2n10bqJnk0eAfzvBMfZfiPDGL_KurJotMy3x1Nj0KU7J91cZx7__fSLduwR__qdMkjIJZ4kc3hDMttDxdVXB9GxG92xygGnqwQsmBaixFDzKBGWue0Da9AL0WphyoCTnDbwtY5E3NhuUPSmXPZajK1RroE0sL8yo3je_hfziiKHIucKrKXAMd2bbdqgCt4AdQzx443nBkWSPXMdekBztDGg-sse14I-vSHjvO0Kl78LN1tQaeN3QvJ-byxtbEtb36F7yg_LI?type=png)](https://mermaid.live/edit#pako:eNqdU2FvmzAQ_SvWfVqlJCIEGuJvKGMaWukqQrO2ilR5sZtYAxwdZllG-O8zkKZpOk3b_MGc3717704nKlgqLoCCwPeSrZBli5yYczsLYrLf9_uqIv40Cedhck8o4UoUbwnR53kYmOyW6eU6lYU-5dSq5bQxJU8qTdX2NxpxYDS-NCIo9bPJAVRVv7_fH23YV1XqjnCiU3Vxc8LrhEhObj69QHM_nn7043eudUHKQmDOMvGSTYK7hGxYUWwV8g6uu0_n-XfatuteEC11eqJ8H_gx2QmGb-lDy_TCJYqlVvjK9DD2n10bqJnk0eAfzvBMfZfiPDGL_KurJotMy3x1Nj0KU7J91cZx7__fSLduwR__qdMkjIJZ4kc3hDMttDxdVXB9GxG92xygGnqwQsmBaixFDzKBGWue0Da9AL0WphyoCTnDbwtY5E3NhuUPSmXPZajK1RroE0sL8yo3je_hfziiKHIucKrKXAMd2bbdqgCt4AdQzx443nBkWSPXMdekBztDGg-sse14I-vSHjvO0Kl78LN1tQaeN3QvJ-byxtbEtb36F7yg_LI)

USER follows USER: a user can exist without following or followed by anyone and user can follow and be followed by several users. Constraint: a given user cannot follow themself.
USER does ACTIVITY: behaving like "transactions" table. User can exist without any activities and can have multiple activities. A given activity is strictly connected to a specific user.
USER adds MOVIE to WATCHLIST (many-to-many via WATCHLISTS): a user can exist without adding any movie to their watchlist and also can add multiple movies to it. A movie inside a given watchlist is strictly connected to one specific user.
USER writes REVIEW: a user can exist without writing any review and also can write multiple reviews. A review is strictly connected to one specific user. After user reviews a given movie, it gets removed from their watchlist. This rule is enforced via  trigger, not by relational constraints.
REVIEW about MOVIE: a review is about one specific movie. A movie can have 0 or multiples reviews too.

## Optimizations

**Views:**
watchlists_detailed, which allows more simplified querying since it already joins all the movie information (title, year, director) with "watchlists" to display watchlist for a given user

**Indexes:**
user_index_watchlist, which is for when searching for a given user's watchlist inside "watchlists"
user_index_follows, which is for when displaying list of followed people/followers

**Triggers:**
Schema contains triggers for relevant ENUM values in "activities" table. Triggers make sure that all inserting/updating/deleting is recorded into "activities" table.
    - trg_watchlist_add: after inserting to "watchlists", adds an activity with type 'add'
    - trg_watchlist_remove: before deleting from "watchlists", adds an activity type 'remove'
    - trg_review_add: after inserting to "reviews", adds an activity with type 'review'
    - trg_follow_add: after inserting to "follows", adds an activity with type 'follow'
    - trg_follow_remove: before deleting from "follows", adds an activity with type 'unfollow'

## Limitations

In this state of database users are not capable of:
- changing/updating their reviews
- interacting with other users - no comment or chat opportunities
- set access control - every user can access to every other user's watchlist
- passwords are assumed to be securely hashed - authentication is outside the scope of this project
- there is no soft delete logic built in
