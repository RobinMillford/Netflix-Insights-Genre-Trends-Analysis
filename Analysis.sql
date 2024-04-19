use projects;

select * from netflix;

-- 1. Distinct Titles in Netflix Dataset
SELECT COUNT(DISTINCT title) AS No_of_content
FROM netflix;

-- 2. Filtering Netflix Titles with IMDb Score > 7
SELECT *
FROM netflix
WHERE imdb_score > 7;

-- 3. Counting Movies by Language in Netflix Dataset.
SELECT language, COUNT(*) AS Movie_Count
FROM netflix
GROUP BY language;

-- 4. Calculating Average IMDb Scores by Genre in Netflix Dataset
SELECT genre, AVG(imdb_score) AS Avg_Score
FROM netflix
GROUP BY genre;

-- 5. Top 5 Genres with Highest Average IMDb Scores in Netflix Dataset
SELECT genre, AVG(imdb_score) AS Avg_Score
FROM netflix
GROUP BY genre
ORDER BY Avg_Score DESC
LIMIT 5;

-- 6. Selecting Movies with IMDb Score Above Genre Average in Netflix Dataset
SELECT M1.*
FROM netflix M1
JOIN (
    SELECT genre, AVG(imdb_score) AS avg_score
    FROM netflix
    GROUP BY genre
) AS M2 ON M1.genre = M2.genre
WHERE M1.imdb_score > M2.avg_score;

-- 7. Counting Movies by Genre Released Before 2020 in Netflix Dataset
SELECT genre, COUNT(*) AS Movie_Count
FROM netflix
WHERE YEAR(premiere) < 2020
GROUP BY genre;

-- 8. Finding the Highest Rated Movie in Netflix Dataset.
SELECT *
FROM netflix
ORDER BY imdb_score DESC
LIMIT 5;

-- 9. Finding Movies with Similar Premiere Dates in the Same Genre
SELECT A.title AS Movie1, B.title AS Movie2, A.genre
FROM netflix A
JOIN netflix B ON A.genre = B.genre
WHERE ABS(DATEDIFF(A.premiere, B.premiere)) <= 7
  AND A.title <> B.title;
  
  -- 10. Finding the Top-ranked Genre by Average IMDb Score for Each Year
  WITH RankedGenres AS (
    SELECT 
        year, 
        genre, 
        AVG(imdb_score) AS avg_imdb_score,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY AVG(imdb_score) DESC) AS genre_rank
    FROM netflix
    GROUP BY year, genre
)
SELECT 
    year, 
    genre, 
    avg_imdb_score
FROM RankedGenres
WHERE genre_rank = 1;

-- 11. Finding Average IMDb Score for Movies with Runtime Greater than Overall Average.
SELECT 
    genre, 
    language, 
    AVG(imdb_score) AS avg_imdb_score
FROM 
    netflix
WHERE 
    runtime > (SELECT AVG(runtime) FROM netflix)
GROUP BY 
    genre, language;
    
-- 12. Identify Trends in IMDb Scores Over Years
SELECT YEAR(premiere) AS year, AVG(imdb_score) AS avg_imdb_score
FROM netflix
GROUP BY YEAR(premiere)
ORDER BY year;

-- 13. Find the Longest and Shortest Titles
SELECT title, LENGTH(title) AS title_length
FROM netflix
ORDER BY title_length DESC
LIMIT 1;

SELECT title, LENGTH(title) AS title_length
FROM netflix
ORDER BY title_length
LIMIT 1;

-- 14. Discover Genres with Most Variability in IMDb Scores
SELECT genre, STDDEV(imdb_score) AS score_stddev
FROM netflix
GROUP BY genre
ORDER BY score_stddev DESC
LIMIT 5;

-- 15. Calculate IMDb Score Trends Over Months
SELECT 
    EXTRACT(MONTH FROM premiere) AS month,
    AVG(imdb_score) AS avg_imdb_score
FROM netflix
GROUP BY month
ORDER BY month;

-- 16. Find the Longest and Shortest Movies by Runtime
SELECT title, runtime
FROM netflix
ORDER BY runtime DESC
LIMIT 1;

SELECT title, runtime
FROM netflix
ORDER BY runtime
LIMIT 1;

-- 17.Discover Countries with Highest Average IMDb Scores
SELECT language, AVG(imdb_score) AS avg_imdb_score
FROM netflix
GROUP BY language
ORDER BY avg_imdb_score DESC;

-- 18. Identify Genres with Most Titles Released Each Year
SELECT 
    YEAR(premiere) AS year,
    genre,
    COUNT(*) AS title_count
FROM netflix
GROUP BY YEAR(premiere), genre
ORDER BY year, title_count DESC;

-- 19. Identify Countries with Most Titles in Each Genre
SELECT
    genre,
    language,
    COUNT(*) AS title_count
FROM netflix
GROUP BY genre, language
ORDER BY genre, title_count DESC;


SELECT 
    genre,
    title,
    imdb_score
FROM netflix AS n1
WHERE imdb_score = (
    SELECT MAX(imdb_score)
    FROM netflix AS n2
    WHERE n1.genre = n2.genre
);