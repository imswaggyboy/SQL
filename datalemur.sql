--Q1. data Science Skills
SELECT DISTINCT(candidate_id) FROM candidates
WHERE skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
having COUNT(candidate_id) = 3;
