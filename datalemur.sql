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
-- Q6.Duplicate Job Listings

----this i tried i'm still lack in knowledge about sql
-- SELECT 
-- SUM(CASE WHEN count(description) >1 THEN 1 ELSE 0 END) as duplicate_companies
-- FROM job_listings
-- GROUP BY description,title,company_id
-- HAVING COUNT(description) > 1


--new concept learned
WITH job_listings_rank 
AS (
  SELECT
    ROW_NUMBER() OVER (
      PARTITION BY company_id, title, description 
    ) AS ranking, 
    company_id, 
    title, 
    description 
  FROM job_listings
)

SELECT COUNT(ranking) AS duplicate_companies
FROM job_listings_rank
WHERE ranking = 2;
-------------------------------------------------------------------------------
Q7. Final Account Balance
this question has solved without any hectic , hint . im so glad!!!!!!

SELECT account_id,
sum((CASE WHEN transaction_type = 'Withdrawal' THEN -amount ELSE +amount END)) as final_balance
FROM transactions
GROUP BY account_id;
-------------------------------------------------------------------------------
Q8. Histogram of Tweets
SELECT
tweet_num as tweet_bucket,
COUNT(user_id) as users_num
FROM(
SELECT user_id,COUNT(user_id) as tweet_num
FROM tweets
WHERE tweet_date BETWEEN '2022/01/01/' AND '2022/12/31'
GROUP BY user_id) as Total_tweets
GROUP BY tweet_bucket;
--------------------------------------------------------------------------------

Q9. Average Review Ratings
SELECT EXTRACT(MONTH FROM submit_date) as mth,
product_id as product ,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY product_id,mth
ORDER BY mth,product;

--------------------------------------------------------------------------------
Q10. LinkedIn Power Creators (Part 1)
SELECT pp.profile_id
FROM personal_profiles pp
JOIN company_pages cp
on pp.employer_id = cp.company_id
where pp.followers > cp.followers
ORDER BY pp.profile_id;
--------------------------------------------------------------------------------
Q11. Highest Number of Products
SELECT user_id,COUNT(product_id) as product_num
FROM user_transactions
GROUP BY user_id
HAVING SUM(spend) >= 1000
ORDER BY product_num DESC, sum(spend) DESC
LIMIT 3;
---------------------------------------------------------------------------------
Q12.Spare Server Capacity
SELECT dc.datacenter_id,
(dc.monthly_capacity)- sum(fd.monthly_demand) as spare_capacity
FROM datacenters dc
JOIN forecasted_demand fd
on fd.datacenter_id = dc.datacenter_id
GROUP BY dc.datacenter_id ,dc.monthly_capacity
ORDER BY dc.datacenter_id asc ;
---------------------------------------------------------------------------------
Q13. Average Post Hiatus (Part 1)
select user_id, EXTRACT(day from diff) as days_between
from 
(SELECT user_id,  max(post_date)-min(post_date) as diff
FROM posts
WHERE post_date BETWEEN '01/01/2021' AND '12/31/2021'
GROUP BY user_id) as a
WHERE EXTRACT(day from diff)> 0 ;

--someone's approach 
SELECT user_id ,extract (day from (max(post_date)-min(post_date)))  
as days_between
FROM posts where extract (year from post_date)=2021 group by user_id
having extract (day from (max(post_date)-min(post_date))) != 0 ;

----------------------------------------------------------------------------------
Q14.Teams Power Users

SELECT sender_id , COUNT(message_id) as message_count
FROM messages
WHERE sent_date BETWEEN '08/01/2022' AND '08/21/2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

--i can use  EXTRACT() ini where --
SELECT sender_id , COUNT(message_id) as message_count
FROM messages
WHERE EXTRACT(month from sent_date) = '8'
AND EXTRACT(year from sent_date) = '2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

------------------------------------------------------------------
Q15.Top Rated Businesses

SELECT COUNT(business_id) as business_count,
100*COUNT(review_stars)/
(SELECT COUNT(business_id) FROM reviews) as top_rated_pct
FROM reviews
where review_stars >= 4;

-------------------------------------------------------------------
Q16.Ad Campaign ROAS

SELECT advertiser_id ,ROUND((SUM(revenue)/SUM(spend))::decimal,2) 
FROM ad_campaigns
GROUP BY advertiser_id
ORDER BY advertiser_id;
--how to use round() fun in postgreSQL --
PostgreSQL requires the ROUND function input to be numeric, while our calculated ROAS is type double. You can read more about different numeric types in the PostgreSQL documentation here.

We can fix this by converting the resulting ROAS to a decimal type before rounding. We can accomplish this using the double-colon :: conversion with the following syntax: ROUND(result::DECIMAL, num_places)

To put it all together, first use the double-colon :: conversion and then round the results.
----------------------------------------------------------------------
Q17.Apple Pay Volume
SELECT merchant_id , SUM(trans_amount)
FROM
(SELECT merchant_id,
CASE 
WHEN lower(payment_method) = 'apple pay' THEN transaction_amount
ELSE 0 END  as trans_amount
FROM transactions) a
GROUP BY merchant_id
ORDER BY SUM(trans_amount) DESC;
--sometimes i just have to use my brain instead of worked with the flow 
SELECT merchant_id,
SUM(CASE 
WHEN lower(payment_method) = 'apple pay' THEN transaction_amount
ELSE 0 END)  as trans_amount
FROM transactions
GROUP BY merchant_id
ORDER BY trans_amount DESC;
-------------------------------------------------------------------------------
Q18.App Click-through Rate (CTR)

Notes:
To avoid integer division, you should multiply the click-through rate by 100.0, not 100.
Percentage of click-through rate = 100.0 * Number of clicks / Number of impressions

-- SELECT * FROM events;
SELECT app_id,
ROUND(100.0*SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END)/
SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END),2) as ctr
FROM events
WHERE EXTRACT(year from timestamp)=2022
GROUP BY app_id;
---------------------------------------------------------------------------------
Q19.Second Day Confirmation
SELECT user_id
FROM
(SELECT e.user_id ,e.email_id,  t.signup_action , t.action_date- e.signup_date as confirm_other_day
FROM emails e
join texts t
on e.email_id = t.email_id) a
WHERE EXTRACT(day FROM confirm_other_day)  = 1;
