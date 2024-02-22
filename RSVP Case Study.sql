-- This Case Study is prepared by Shakti Singh, Vishwajeet Singh and Ashish Grover

USE imdb;
show tables;
/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Explanation of Query:
-- Retrieves table names and row counts from the 'imdb' database.

SELECT table_name, table_rows -- Finding the total number of rows in each table of our DB imdb
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Explanation of Query:
-- These SQL queries count null or empty values in specific columns of the 'movie' table. 
-- They assess null values in 'title,' 'year,' 'date_published,' 'duration,' 'country,' 'worlwide_gross_income,' 'languages,' and 'production_company.'
-- The counts reveal missing or empty information in these columns.

SELECT count(*) FROM movie -- counting null values where Title is null or ''
WHERE title IS NULL OR title = '';

SELECT count(*) FROM movie -- counting null values where year is null or ''
WHERE year IS NULL OR year = '';

SELECT count(*) FROM movie -- counting null values where date_published is null
WHERE date_published IS NULL;

SELECT count(*) FROM movie -- counting null values where duration is null
WHERE duration IS NULL; 

SELECT count(*) FROM movie -- counting null values where country is null or ''
WHERE country IS NULL OR country=''; -- 20 null values found

SELECT count(*) FROM movie -- counting null values where worlwide_gross_income is null or ''
WHERE worlwide_gross_income IS NULL OR worlwide_gross_income=''; -- 3724 null values found

SELECT count(*) FROM movie -- counting null values where language are null or ''
WHERE languages IS NULL OR languages=''; -- 194 null values found

SELECT count(*) FROM movie -- counting null values where language are null or ''
WHERE production_company IS NULL OR production_company=''; -- 528 null values found


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

-- Explanation of Query:
-- The first query counts the number of movies released each year, indicating a declining trend. 
-- The second query counts the number of movies released each month, providing insights into monthly variations in movie releases.

SELECT year as Year, count(distinct id) as number_of_movies 
FROM movie 
GROUP BY year; -- The trend looks to be declining, each year the number of movies released are getting less in number

SELECT month(date_published) as month_num, count(distinct id) as number_of_movies -- second part of question answered
FROM movie
GROUP BY month(date_published)
ORDER BY month_num; -- The trened looks to be jumping around month wise but If we look closely highest movies that are released are in Jan, Mar, Sep and Oct with 800 plus releases.


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Explanation of Query:
-- Counts distinct movies produced in India or the USA in the year 2019 from the 'movie' table.
-- Pattern matching using LIKE 

SELECT Count(DISTINCT id) AS Movies_produced_in_India_and_USA , year -- Number of movies produced in USA and India in the year 2019
FROM movie
WHERE ( country LIKE '%INDIA%' OR country LIKE '%USA%' ) AND year = 2019;  

-- 1059 movies were produced in total in India and USA 

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Explanation of Query:
-- Selects distinct genres from the genre table.
-- Finding the Genres using the Distinct keyword

SELECT DISTINCT genre
FROM genre; 

-- There are 13 different genres that the movies belong from. 

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Explanation of Query:
-- This SQL query counts the distinct movie IDs in each genre, using a left join to retain all genres even if they have no matching movies. 
-- It then orders genres by movie count in descending order and limits the result to one row.

SELECT count(distinct id) as num_of_movies, genre -- counting distinct movie ids in each genre 
FROM genre as g
left join movie as m    -- joining with genre with movies. Using left join for the purpose of retaining all genres from genre dataset
ON g.movie_id = m.id
group by genre
order by num_of_movies desc -- ordering genres by counting movies
limit 1; -- Using Limit to display genre with highest number of movies produced  
                   
-- Drama genre has 4285 movies produced which is also the highest among all the genres

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Explanation of Query:
-- This SQL query identifies movies with only one genre, grouping by movie ID and filtering for those with a count of distinct genres equal to 1. It then counts these movies.
-- Using genre table for finding movies which are from one genre
-- Grouping rows on the basis of movie id and matching DISTINCT number of genre each movie belongs
-- Using output of CTE, we will find that 3289 movies belonging to just one genre 

WITH movies_of_one_genre
     AS (SELECT movie_id
         FROM genre
         GROUP BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS count_of_movies_with_one_genre
FROM movies_of_one_genre; 

-- 3289 movies belonging to just one genre 


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

-- Explanation of Query:
-- Calculates and rounds the average duration for each movie genre, then orders the result by average duration in descending order.
-- Average duration of movies is calulated by grouping the same genre a movie belongs from 

SELECT genre, Round(Avg(duration),2) AS avg_duration
FROM movie as m
INNER JOIN genre as g
ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration DESC;

-- Conclusion: Action, Romance and Crime are the Top Three genres that have the longest duration. It would be best for RSVP to keep their duration as per the Average listed below for any genres they decide to produce 

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

-- Explanation of Query:
-- This SQL query counts the distinct movie IDs per genre, ranks genres by the count of distinct movie IDs in descending order, and retains all genres even if they have no matching movies.

SELECT genre, count(distinct id) as count_of_movies,  -- count of distinct movie ids per genre
RANK() OVER(order by count(distinct id) desc) as rank_of_genre -- ranking all rows by count of distinct movie ids or count_of_movies 
FROM genre as g
left join movie as m    -- joining genre with movies. We are using left join as we want to retain all genres from genre dataset
ON g.movie_id = m.id
group by genre; -- thriller genre ranks 3rd with 1484 movies produced  


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

-- Explanation of Query:
-- Calculates minimum and maximum values for average rating, total votes, and median rating from ratings.
-- Implying MIN and MAX functions for the query 

select min(avg_rating) as min_avg_rating,
max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_votes ,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as min_median_rating
from ratings; 

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
-- We are ranking each movie based on their avergae rating and displaying the top 10 using LIMIT 

-- Explanation of Query:
-- Selects movie title, average rating, and ranking, ordered by average rating, limiting to top 10.

select title, avg_rating,
rank() over(order by avg_rating desc) as movie_ranking
from ratings as r
inner join movie as m
on m.id = r.movie_id limit 10;


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

-- Explanation of Query:
-- Counts movies by median rating and orders by movie count.
-- Sorting the movies on the basis of movie count and finding the number of movies based on median rating

select median_rating, Count(movie_id) as movie_count
from ratings
group by median_rating
order by movie_count desc; 

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

-- Explanation of Query:
-- This SQL query identifies hit movies (average rating > 8) and their production companies. 
-- It then counts the number of hit movies produced by each production company, ranks them based on the movie count, and presents the result ordered by the count of hit movies in descending order.

with hit_movies_list   -- finding all hit movies and their production companies that have avg_rating higher than 8
as
(
select production_company,   
		id,
        title,
        avg_rating
from movie as m   
inner join ratings as r      -- joining movies and ratings tables
on m.id = r.movie_id
where avg_rating > 8    -- a movie is considered a hit if it has an avg_rating > 8
)
select production_company,
		count(distinct id) as movie_count,      -- count of hit movies produced by each production house
        rank() over(order by count(distinct id) desc) as prod_company_rank  -- ranking production companies by the number of hit movies they produced
from hit_movies_list
group by production_company
order by movie_count desc;               -- ordering by count of hit movies produced by each production house

-- Dream Warrior Pictures and National Theatre Live production houses have produced the most number of hit movies (average rating > 8)
-- They have rank=1 and movie count =3 

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

-- Explanation of Query:
-- step one, finding number of movies released in each genre 
-- step two, finding movies that were released in march 2017 
-- step three, finding movies that were released in the USA using Like
-- step four, finding movies that had more than 1,000 votes


-- This SQL query counts the number of movies in each genre released in the USA in March 2017 with more than 1000 total votes. 
-- It joins the "movie," "genre," and "ratings" tables, applies filtering conditions, and presents results grouped by genre, ordered by movie count in descending order.

select genre, Count(M.id) as movie_count
from movie as M 
inner join genre as G
on G.movie_id = M.id
inner join ratings as R
on R.movie_id = M.id
where year = 2017 and Month(date_published) = 3 and country LIKE '%USA%' and total_votes > 1000
group by genre
order by movie_count desc; 

-- There were 24 Drama genre movies released in march 2017 in the USA that had more than 1000 votes. Additionally, the top three genres are Drama, Comedy and Action in the USA in march 2017


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

-- Explanation of Query:
-- This SQL query selects movie titles, average ratings, and genres for movies starting with 'The' and having an average rating greater than 8, ordering results by genre.

select title, avg_rating, genre
from movie as m
inner join genre as g                   
on m.id= g.movie_id                      -- joining movie and genre tables
inner join ratings as r               -- now joining with ratings table
on m.id= r.movie_id
where title regexp '^The' and avg_rating > 8        -- sorting movies that start with 'The' using regexp and has an average rating greater than 8
order by genre;             -- ordering by genre



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- Explanation of Query:
-- This SQL query counts the number of movies with a median rating of 8 published between April 1, 2018, and April 1, 2019. 
-- It achieves this by joining the "movie" and "ratings" tables using an inner join, filtering for the specified rating and date range, and grouping the results by the median rating.

select median_rating, Count(*) as movie_count -- count of movies
from movie as m
inner join ratings as r -- joining movies and rating using inner join
on r.movie_id = m.id
where median_rating = 8 -- filtering for median rating 8 movies
and date_published between '2018-04-01' and '2019-04-01' -- filtering the desired dates
group by median_rating;

-- There are 361 movies with the median rating of 8 that were released between 1 April 2018 and 1 April 2019


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Explanation of Query: 
-- This SQL query selects the total votes for movies from Germany or Italy by joining the "movie" and "ratings" tables and grouping by country.

select country, sum(total_votes) as total_votes 
from movie as m
inner join ratings as r on m.id = r.movie_id
where country = 'Germany' or country = 'Italy' -- filtering for German and Italian movies
group by country;

-- The answer is Yes German movies get more views when compared to Italian movies, Germany has 106710 and Italy has 77965

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

-- Explanation of Query:
-- This SQL query counts the number of null values in specific columns ("name," "height," "date_of_birth," and "known_for_movies") in the "names" table using conditional aggregation. 
-- It sums up occurrences where each specified column is null, providing a count of null values for each respective column in the output.

select
sum(case when name is null then 1 else 0 end) as name_nulls, 
sum(case when height is null then 1 else 0 end) as height_nulls,
sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;

-- Using CASE we have elimiated the need for writing the individual columns names table and have the desired output. Where we see that only name_nulls column has no null values

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

-- Explanation of Query:
-- This SQL query first identifies the top 3 movie genres with the highest counts and ranks them based on movies with an average rating above 8. 
-- Then, it selects the top 3 directors who have directed the most movies in these genres with ratings above 8. 
-- The query involves joining the "director_mapping," "genre," "names," and "ratings" tables, filtering by genre and average rating criteria, and grouping the results by director names. 
-- The final output is ordered by the movie count in descending order, limited to the top 3 directors.
-- This SQL code selects the top 3 movie genres based on the count of movies with an average rating above 8. Then, it identifies the top 3 directors within those genres by counting their movies.

with top_3_genres as
(
select genre, count(m.id) as movie_count,
rank() over(order by count(m.id) desc) as genre_rank
from movie as m
inner join genre as g -- joining name table to get director name
on g.movie_id = m.id
inner join ratings as r -- joining genre table to get genre
on r.movie_id = m.id
where avg_rating > 8 -- filtering movies with desired avergare rating
group by genre limit 3 )
select n.name as director_name,
count(d.movie_id) as movie_count
from director_mapping as d
inner join genre g
using(movie_id)
inner join names as n
on n.id = d.name_id
inner join top_3_genres
using(genre)
inner join ratings
using(movie_id)
where avg_rating > 8
group by name
order by movie_count desc limit 3;

-- The top three directors in the top three genres whose movies have an average rating > 8 are James Mangol, Anthony Russo and Soubin Shahir

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

-- Explanation of Query:
-- This SQL query retrieves the top 2 actors with the highest movie counts, filtering for actors in the 'ACTOR' category and having a median rating of 8 or above.
-- It joins the "role_mapping," "movie," "ratings," and "names" tables, grouping the results by actor names and ordering them by movie count in descending order.

SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id -- joining role mapping 
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N -- joining role mapping to name of actors
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8 -- filtering for actors havingn desired rating 
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 

-- The top two actors are Mammooty and Mohanlal

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

-- Explanation of Query:
-- This SQL code calculates the total vote count for each production company by joining the "movie" and "ratings" tables. 
-- It then assigns a rank to each production company based on the descending order of vote counts. Finally, it selects the production company, vote count, and rank for the top 3 production companies.
WITH ranking AS(
SELECT production_company, sum(total_votes) AS vote_count,
	RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
	INNER JOIN ratings AS r ON r.movie_id=m.id
GROUP BY production_company)
SELECT production_company, vote_count, prod_comp_rank
FROM ranking
WHERE prod_comp_rank < 4;

-- The top three production houses are Marvel Studios, Twentieth Century Fox and Warner Bros 

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

-- Explanation of Query: 
-- This SQL script first modifies the SQL mode to remove the 'ONLY_FULL_GROUP_BY' restriction. It then creates two views, "ACTORS" and "movies_India," filtering actors and movies from India. 
-- The main query selects actor names, their total votes, movie counts, average ratings, and ranks actors based on their average ratings and total votes, considering only those with at least 5 movies in India.
-- Finally, the script drops the temporary views "ACTORS" and "movies_India."

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

DROP VIEW IF EXISTS ACTORS;
CREATE VIEW ACTORS as
SELECT *
FROM role_mapping as rm
INNER JOIN names as n
ON rm.name_id= n.id
WHERE category='actor';

DROP VIEW IF EXISTS movies_India;
CREATE VIEW movies_India as
SELECT *
FROM movie
WHERE country REGEXP 'India';

SELECT a.name as actor_name,
		sum(r.total_votes) as total_votes,             
        count(distinct a.movie_id) as movie_count,
        (sum(r.avg_rating* r.total_votes)/sum(r.total_votes)) as actor_avg_rating,
        RANK() OVER(ORDER BY (sum(r.avg_rating* r.total_votes)/sum(r.total_votes)) DESC, sum(r.total_votes) DESC) as actor_rank
FROM ACTORS as a
INNER JOIN movies_India as mi
ON a.movie_id= mi.id
	INNER JOIN ratings as r
    ON a.movie_id= r.movie_id
group by actor_name
having movie_count>=5
limit 1;

DROP VIEW IF EXISTS ACTORS;
DROP VIEW IF EXISTS movies_India;

-- Top actor is Vijay Sethupathi with total voates 23,114, movie_count 5, rating 8.41673 and actor ranking 1 


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

-- Explanation of Query: 
-- This SQL code generates a summary of Indian actresses who have performed in Hindi movies, calculating their total votes, movie counts, and average ratings.
-- It then ranks these actresses based on their average ratings in descending order and selects the top 5, considering only those with at least 3 movies.
WITH actress_summary AS
(
           SELECT     n.NAME as actress_name,
                      total_votes,
                      Count(r.movie_id) as movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) as actress_avg_rating
           FROM       movie as m
           INNER JOIN ratings as r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping as rm
           ON         m.id = rm.movie_id
           INNER JOIN names as n
           ON         rm.name_id = n.id
           WHERE      category = 'ACTRESS'
           AND        country = "INDIA"
           AND        languages LIKE '%HINDI%'
           GROUP BY   NAME
           HAVING     movie_count>=3 )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_summary LIMIT 5;

-- Taapsee Pannu tops with average rating of 7.74 followed by Kriti Sanon 7.05, Divya Dutta 6.88, Shraddha Kapoor 6.63 and Kriti Kharbanda 4.80 

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Explanation of Query
-- This SQL code creates a view named "thriller_movies" that includes distinct titles and average ratings of movies in the "THRILLER" genre.
-- The main query then selects all columns from this view, adding a new column "avg_rating_category" that categorizes movies based on their average ratings into 'Superhit,' 'Hit,' 'One-time-watch,' or 'Flop.' 
-- The categories are determined by specific rating ranges.
WITH thriller_movies
     AS (SELECT DISTINCT title,
                         avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON R.movie_id = M.id
                INNER JOIN genre AS G using(movie_id)
         WHERE  genre LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies; 


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

-- Explanation of Query:
-- This SQL query calculates statistics related to movie durations by genre. 
-- It retrieves the genre, the rounded average duration for each genre, the running total duration for each genre ordered by genre, and the moving average duration over a window of 10 preceding rows for each genre.
-- It achieves this by joining the "movie" and "genre" tables, grouping by genre, and utilizing window functions to compute running totals and moving averages based on the specified ordering.
-- The final result is ordered by genre.
SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
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

-- Explanation of Query:
-- This SQL code first identifies the top 3 movie genres with the highest counts and ranks them based on movies with an average rating above 8.
-- It then creates a summary of movies within these top genres, considering their worldwide gross income, year, and title, ranking them by income within each year. 
-- Finally, the query selects movies with a rank of 5 or below within their respective years, providing a list of top-performing movies in each genre.
-- The result is ordered by the year, showcasing the top movies from the selected genres in each year.

	WITH top_genres AS
(
           SELECT     genre,
                      Count(m.id) AS movie_count,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie AS m
           INNER JOIN genre AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 ), movie_summary AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
           FROM       movie AS m
           INNER JOIN genre AS g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_genres)
            GROUP BY   movie_name
           )
SELECT *
FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;

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

-- Explanation of Query:
-- This SQL code generates a summary of production companies based on the count of movies with a median rating equal to or greater than 8, where the production company is not null and languages contain a comma.
-- The result includes production companies and their corresponding movie counts, ranked in descending order by movie count.
-- The query employs a window function to assign ranks to production companies based on their movie counts, and the final result is limited to the top 2 production companies.

WITH production_company_summary
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS m
                inner join ratings AS r
                        ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()
         over(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summary
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

-- Explanation of Query: 
-- This SQL code creates a summary of actresses who have acted in Drama genre movies with an average rating above 8. 
-- It calculates their total votes, movie counts, and average ratings, ranking them based on movie counts in descending order.
-- The final result provides details on the top 3 actresses meeting the specified criteria, including their ranks. 
-- The query combines data from the "movie," "ratings," "role_mapping," "names," and "genre" tables through various joins and conditions.

WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id) AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie AS m
           INNER JOIN ratings AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary LIMIT 3;

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

-- Explanation of Query:
-- This SQL code first calculates the difference in days between consecutive movies published by each director, along with various metrics like average rating, total votes, and total duration. 
-- It achieves this by joining the "director_mapping," "names," "movie," and "ratings" tables.
-- The final result summarizes the top 9 directors based on the count of movies they directed, displaying metrics such as the average inter-movie days, average rating, total votes, minimum and maximum ratings, and total duration. 
-- The result is ordered by the count of movies in descending order, limiting to the top 9 directors.

WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM director_mapping AS d
           INNER JOIN names AS n
           ON n.id = d.name_id
           INNER JOIN movie AS m
           ON m.id = d.movie_id
           INNER JOIN ratings AS r
           ON r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id AS director_id,
         NAME AS director_name,
         Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration) AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;





