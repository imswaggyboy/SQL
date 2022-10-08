----------------EASY QUESTIONS-------------------
--Q1. data Science Skills
SELECT DISTINCT(candidate_id) FROM candidates
WHERE skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
having COUNT(candidate_id) = 3;
-------------------------------------------------------------------------------
-- Q2. Page With No Likes
SELECT p.page_id  
FROM pages p
LEFT JOIN page_likes pl
on p.page_id = pl.page_id
where pl.liked_date is NULL
order by page_id ASC;
------------------------------------------------------------------------------
--Q3.Unfinished Parts
SELECT DISTINCT(part) FROM parts_assembly
where finish_date is NULL;
------------------------------------------------------------------------------
--Q4.Laptop vs Mobile Viewership
SELECT 
sum(CASE when device_type = 'laptop' THEN 1 ELSE 0 END) as laptop_views ,
sum(CASE when device_type IN ('tablet','phone') THEN 1 ELSE 0 END) as mobile_views
FROM viewership;
------------------------------------------------------------------------------
--Q5.Cities With Completed Trades
--applied previously learned concept
SELECT u.city, 
sum(CASE WHEN t.status = 'Completed' then 1 else 0 END) as total_trades
FROM users u
join trades t
on u.user_id = t.user_id
GROUP BY u.city
ORDER BY total_trades DESC
LIMIT 3;

--another answer using count() aggre and where clause
SELECT u.city, COUNT(t.status) as total_trades
-- sum(CASE WHEN t.status = 'Completed' then 1 else 0 END) as total_trades
FROM users u
join trades t
on u.user_id = t.user_id
where t.status = 'Completed'
GROUP BY u.city
ORDER BY total_trades DESC
LIMIT 3;
-----------------------------------------------------------------------------
