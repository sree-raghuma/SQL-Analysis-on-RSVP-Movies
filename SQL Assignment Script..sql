USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM GENRE ;
-- Number of Rows - 14662

SELECT COUNT(*) FROM DIRECTOR_MAPPING;
-- Number of Rows - 3867

SELECT COUNT(*) FROM  MOVIE;
-- Number of Rows - 7997

SELECT COUNT(*) FROM  NAMES;
-- Number of Rows - 25735

SELECT COUNT(*) FROM  RATINGS;
-- Number of Rows - 7997

SELECT COUNT(*) FROM  ROLE_MAPPING;
-- Number of Rows - 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
		SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_null, 
		SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null, 
		SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null,
		SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null,
		SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null,
		SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null,
		SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null,
		SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null,
		SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null

FROM movie;
-- Columns Country, Worlwise_gross_income, Languages, Production_company has Null Values
/*
# ID_null	title_null	year_null	date_published_null	duration_null	country_null	worlwide_gross_income_null	languages_null	production_company_null
0	0	0	0	0	20	3724	194	528*/


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year
SELECT Year,
       Count(title) AS number_of_movies
FROM   movie
GROUP  BY year;

/*# Year	number_of_movies
2017	3052
2018	2944
2019	2001
*/

-- Number of movies released each month 
SELECT Month(date_published) AS month_num,
       Count(*)              AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

/*# month_num	number_of_movies
1	804
2	640
3	824
4	680
5	625
6	580
7	493
8	678
9	809
10	801
11	625
12	438
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 
       
-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 

/*# genre
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/

-- 13 Unique Genres

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Using LIMIT clause to display only the genre with highest number of movies produced
SELECT     genre,
           Count(m.id) AS number_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
where      g.movie_id = m.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;

/*
# genre	number_of_movies
Drama	4285
*/

-- 4265 Drama movies were produced in total and are the highest among all genres. 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Utilizing the genre table to identify movies that are associated with just a single genre.
-- Grouping records by movie ID and determining the unique number of genres that each movie is associated with.
-- By using the outcome of the Common Table Expression (CTE), we calculate the count of movies that are exclusively linked to a single genre.
WITH CTE_genre AS(
SELECT movie_id, COUNT(genre) AS number_of_genre_movies 
FROM genre
GROUP BY movie_id
HAVING number_of_genre_movies = 1)
SELECT COUNT(movie_id) AS number_of_movies_with_one_genre FROM CTE_genre;

-- 3289 movies belong to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Calculating the avg duration of movies by categorizing them according to their associated genres.

SELECT g.genre, ROUND(AVG(m.duration),2) AS avg_duration 
FROM
movie AS m 
INNER JOIN
genre AS g
ON m.id = g.movie_id
GROUP BY g.genre;

/*
# genre	avg_duration
Drama	106.77
Fantasy	105.14
Thriller	101.58
Comedy	102.62
Horror	92.72
Family	100.97
Romance	109.53
Adventure	101.87
Action	112.88
Sci-Fi	97.94
Crime	107.05
Mystery	101.80
Others	100.16
*/

-- The longest average movie duration, at 112.88 seconds, is found within the Action genre, with Romance and Crime genres following closely behind.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Common Table Expression (CTE): Determines the rank of each genre based on the quantity of movies in each genre.
-- The SELECT query presents the rank of the Thriller genre and the count of movies within that genre.

WITH genre_rankings AS(
SELECT genre,count(genre) AS movie_count, 
RANK() OVER(ORDER BY count(genre) DESC) AS genre_rank
FROM genre
GROUP BY genre)
SELECT * FROM genre_rankings
WHERE genre = 'Thriller';

/*
# genre	movie_count	genre_rank
Thriller	1484	3
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Using MIN and MAX functions for the query 
SELECT Min(avg_rating)    AS MIN_AVG_RATING,
       Max(avg_rating)    AS MAX_AVG_RATING,
       Min(total_votes)   AS MIN_TOTAL_VOTES,
       Max(total_votes)   AS MAX_TOTAL_VOTES,
       Min(median_rating) AS MIN_MEDIAN_RATING,
       Max(median_rating) AS MAX_MEDIAN_RATING
FROM   ratings; 

/*# MIN_AVG_RATING	MAX_AVG_RATING	MIN_TOTAL_VOTES	MAX_TOTAL_VOTES	MIN_MEDIAN_RATING	MAX_MEDIAN_RATING
1.0	10.0	100	725138	1	10
*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
-- using rank
with movie_ranking as 
(select
title,
avg_rating, 
rank() over(order by avg_rating desc) movie_rank s
from movie
inner join ratings
on(movie.id=ratings.movie_id))
select * from movie_ranking where movie_rank <= 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, COUNT(movie_id) movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with top_prod_com as(select 
production_company,
count(id) movie_count,
rank() over(order by count(id) desc) prod_company_rank from movie
inner join ratings
on(movie.id=ratings.movie_id)
where avg_rating>8 and production_company is not null
group by production_company)
select * from top_prod_com where prod_company_rank=1;




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, COUNT(id) movie_count
FROM
    movie
        INNER JOIN
    genre ON (movie.id = genre.movie_id)
        INNER JOIN
    ratings ON (genre.movie_id = ratings.movie_id)
WHERE
    country LIKE '%USA%' AND year = 2017
        AND MONTH(date_published) = '03'
        AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC; 

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, 
    avg_rating, 
    group_concat(genre) genre
FROM
    movie
        INNER JOIN
    ratings ON (movie.id = ratings.movie_id)
        INNER JOIN
    genre ON (movie.id = genre.movie_id)
WHERE
    title LIKE 'The%' AND avg_rating > 8
    group by title, avg_rating;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    median_rating, COUNT(*) movie_count
FROM
    movie
        INNER JOIN
    ratings ON (movie.id = ratings.movie_id)
WHERE
    date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND median_rating = 8
GROUP BY median_rating; 


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

with german_italian_vote as (select 
sum(case when languages like '%German%' then total_votes else 0 end) german_lang_movie_count,
sum(case when languages like '%Italian%' then total_votes else 0 end) Italian_lang_movie_count
from movie
inner join ratings
on(movie.id=ratings.movie_id))
select german_lang_movie_count,
Italian_lang_movie_count,
(case when german_lang_movie_count > Italian_lang_movie_count then 'Yes' else 'No' end) IS_GER_GT_ITA
from german_italian_vote;



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) known_for_movies_nulls
FROM
    names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top3_genres as (
select 
genre,rank() over(order by count(id) desc) genre_rank
from movie
inner join ratings
on(movie.id=ratings.movie_id)
inner join genre
on(ratings.movie_id=genre.movie_id)
where 
avg_rating>8
group by genre) /Top 3 genres/

select director_ranks.director_name, director_ranks.movie_count from(select names.name director_name,
count(movie.id) movie_count,
rank() over (order by count(movie.id) desc) director_rank
 from movie
inner join ratings
on(movie.id=ratings.movie_id)
inner join director_mapping
on(movie.id=director_mapping.movie_id)
inner join names
on(director_mapping.name_id=names.id)
inner join genre
on(ratings.movie_id=genre.movie_id)
where avg_rating>8
and genre in (select genre from top3_genres where genre_rank<=3)
group by director_name) director_ranks 
where director_ranks.director_rank<=3;








/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT name AS actor_name, COUNT(r.movie_id) AS movie_count
FROM ratings AS r
INNER JOIN role_mapping AS rm
ON rm.movie_id = r.movie_id
INNER JOIN names AS n
ON rm.name_id = n.id
WHERE median_rating >= 8 AND category = 'actor'
GROUP BY name
ORDER BY movie_count DESC
LIMIT 2;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, SUM(r.total_votes) AS vote_count,
DENSE_RANK() OVER(ORDER BY sum(r.total_votes)DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN
ratings AS r 
ON m.id= r.movie_id
GROUP BY production_company
LIMIT 3;








/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name AS actor_name, SUM(total_votes),
COUNT(m.id) AS movie_count,
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
RANK() OVER(ORDER BY  ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actor_rank
FROM movie AS m 
INNER JOIN ratings AS r 
ON m.id = r.movie_id 
INNER JOIN role_mapping AS rm 
ON m.id=rm.movie_id 
INNER JOIN names AS nm 
ON rm.name_id=nm.id
WHERE category='actor' AND country= 'India'
GROUP BY name
HAVING movie_count>=5
LIMIT 3;






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT name AS actress_name, sum(r.total_votes),
                COUNT(m.id) AS movie_count,
                ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
               	RANK() OVER(ORDER BY  ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actress_rank		
FROM movie AS m 
INNER JOIN ratings AS r 
ON m.id = r.movie_id 
INNER JOIN role_mapping AS rm 
ON m.id=rm.movie_id 
INNER JOIN names AS nm 
ON rm.name_id=nm.id
WHERE rm.category='actress' AND m.country LIKE '%India%' AND m.languages LIKE '%Hindi%'
GROUP BY name
HAVING COUNT(m.country='India')>=3
LIMIT 5;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title,r.avg_rating,
	CASE 
		WHEN avg_rating > 8 THEN 'Superhit movies'
		WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
		WHEN avg_rating < 5 THEN 'Flop movies'
	END AS avg_rating_category
FROM movie AS m
INNER JOIN genre AS g
ON m.id=g.movie_id
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE genre='thriller'
ORDER BY r.avg_rating DESC;








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
	ROUND(AVG(duration)) AS avg_duration,
	SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	ROUND(AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration

FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_3_genre AS
( 	
	SELECT genre, COUNT(movie_id) AS number_of_movies
    FROM genre AS g
    INNER JOIN movie AS m
    ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

top_5 AS
(
	SELECT genre,
			year,
			title AS movie_name,
			worlwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
        
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top_3_genre)
)

SELECT *
FROM top_5
WHERE movie_rank<=5;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company ,count(m.id)AS movie_count, 
RANK() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND position(',' IN languages)>0
GROUP BY production_company
LIMIT 2;







-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT r.movie_id) AS movie_count,
    ROUND(AVG(r.avg_rating), 2) AS actress_avg_rating,
    DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT r.movie_id) DESC) AS actress_rank
FROM names AS n
INNER JOIN role_mapping AS rm ON n.id = rm.name_id
INNER JOIN (
    SELECT m.movie_id
    FROM ratings AS m_r
    INNER JOIN movies AS m ON m_r.movie_id = m.id
    INNER JOIN genre AS m_g ON m.id = m_g.movie_id
    WHERE m_r.avg_rating > 8 AND m_g.genre = 'drama'
) AS super_hit_movies ON rm.movie_id = super_hit_movies.movie_id
INNER JOIN ratings AS r ON rm.movie_id = r.movie_id
WHERE n.category = 'actress'
GROUP BY n.name
ORDER BY COUNT(DISTINCT r.movie_id) DESC
LIMIT 3;






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
SELECT
    d.id AS director_id,
    d.name AS director_name,
    COUNT(m.id) AS number_of_movies,
    AVG(DATEDIFF(m.release_date, LAG(m.release_date, 1, m.release_date) OVER (PARTITION BY m.director_id ORDER BY m.release_date))) AS avg_inter_movie_days,
    AVG(m.avg_rating) AS avg_rating,
    SUM(m.total_votes) AS total_votes,
    MIN(m.min_rating) AS min_rating,
    MAX(m.max_rating) AS max_rating,
    SUM(m.duration) AS total_duration
FROM directors AS d
LEFT JOIN movies AS m ON d.id = m.director_id
GROUP BY d.id, d.name
ORDER BY number_of_movies DESC
LIMIT 9;






