----------------EASY QUESTIONS-------------------
--Q1. data Science Skills
SELECT DISTINCT(candidate_id) FROM candidates
WHERE skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
having COUNT(candidate_id) = 3;

-- Q2. Page With No Likes
SELECT p.page_id  
FROM pages p
LEFT JOIN page_likes pl
on p.page_id = pl.page_id
where pl.liked_date is NULL
order by page_id ASC;

--Q3.Unfinished Parts
SELECT DISTINCT(part) FROM parts_assembly
where finish_date is NULL;
