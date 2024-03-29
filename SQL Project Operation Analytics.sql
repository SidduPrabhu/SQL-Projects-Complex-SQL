#Question A:
Calculate the number of jobs reviewed per hour per day for November 2020?

#Number of Jobs Reviewed per Day:
 
SELECT
COUNT(job_id) / 30 num_of_jobs_reviewed_per_day
FROM
project1;

#Number of Jobs Reviewed per Hour

#Question B:
Let’s say the above metric is called throughput. Calculate 7 day rolling average of throughput? For
throughput, do you prefer daily metric or 7-day rolling and why?

SELECT
 b.*,round(avg(events_per_sec) OVER (order by date rows between 7 preceding and current
row),2) 7_day_rolling_avg from
(SELECT
a.*,round(total_events/86400,2) events_per_sec
 FROM
(SELECT
 DATE(occurred_at) date, COUNT(*) total_events
 FROM
 events
GROUP BY DATE(occurred_at)) a)b;

#Question C:
Calculate the percentage share of each language in the last 30 days?

SELECT
 language,100*cnt/sum(cnt) OVER() percentage_shared
FROM
 (select *,count(language) cnt
FROM
 project1
group by language) a

#Question D:
Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?

SELECT
 *, COUNT(*) count
FROM
 project1
GROUP BY ds , job_id , actor_id , event , language , time_spent , org
HAVING COUNT(*) > 1;

SELECT
 (SELECT
 COUNT(job_id) / 30 num_of_jobs_reviewed_per_day
 FROM
 project1) / 24 num_of_jobs_reviewed_per_hour
FROM
 project1;

#Case Study - 2
Question A:
Calculate the weekly user engagement?
    
SELECT 
    a.*, COUNT(event_type) Total_engagement
FROM
    (SELECT 
        event_type,
            YEAR(occurred_at) year,
            MONTHNAME(occurred_at) month,
            WEEK(occurred_at) week
    FROM
        events) a
WHERE
    event_type = 'engagement'
GROUP BY week;

#Question B:
Calculate the user growth for product?

select a.*,count(event_type) Total_engagement from
(select event_type,occurred_at,year(occurred_at),monthname(occurred_at) month,week(occurred_at) week from 
events) a
where event_type = "engagement"
group by year(occurred_at),month(occurred_at),week(occurred_at);

#Question C:
Calculate the email engagement metrics?

SELECT 
    YEAR(created_at) year,
    MONTH(created_at) month,
    COUNT(user_id) Total_users_created
FROM
    users
GROUP BY YEAR(created_at) , MONTH(created_at);

SELECT 
    action, COUNT(action) Total_Engagement
FROM
    email_events
GROUP BY action;

#Question D:
Calculate the weekly engagement per device?

SELECT 
    device,
    WEEK(occurred_at) week,
    COUNT(occurred_at) total_engagement
FROM
    events
WHERE
    event_type = 'engagement'
GROUP BY device , WEEK(occurred_at)
ORDER BY device , week;

#Question E:
Calculate the weekly retention of users-sign up cohort?

SELECT 
    first_week,
    SUM(CASE
        WHEN week_number = 0 THEN 1
        ELSE 0
    END) AS week_0,
    SUM(CASE
        WHEN week_number = 1 THEN 1
        ELSE 0
    END) AS week_1,
    SUM(CASE
        WHEN week_number = 2 THEN 1
        ELSE 0
    END) AS week_2,
    SUM(CASE
        WHEN week_number = 3 THEN 1
        ELSE 0
    END) AS week_3,
    SUM(CASE
        WHEN week_number = 4 THEN 1
        ELSE 0
    END) AS week_4,
    SUM(CASE
        WHEN week_number = 5 THEN 1
        ELSE 0
    END) AS week_5,
    SUM(CASE
        WHEN week_number = 6 THEN 1
        ELSE 0
    END) AS week_6,
    SUM(CASE
        WHEN week_number = 7 THEN 1
        ELSE 0
    END) AS week_7,
    SUM(CASE
        WHEN week_number = 8 THEN 1
        ELSE 0
    END) AS week_8,
    SUM(CASE
        WHEN week_number = 9 THEN 1
        ELSE 0
    END) AS week_9,
    SUM(CASE
        WHEN week_number = 10 THEN 1
        ELSE 0
    END) AS week_10,
    SUM(CASE
        WHEN week_number = 11 THEN 1
        ELSE 0
    END) AS week_11,
    SUM(CASE
        WHEN week_number = 12 THEN 1
        ELSE 0
    END) AS week_12,
    SUM(CASE
        WHEN week_number = 13 THEN 1
        ELSE 0
    END) AS week_13,
    SUM(CASE
        WHEN week_number = 14 THEN 1
        ELSE 0
    END) AS week_14,
    SUM(CASE
        WHEN week_number = 15 THEN 1
        ELSE 0
    END) AS week_15,
    SUM(CASE
        WHEN week_number = 16 THEN 1
        ELSE 0
    END) AS week_16,
    SUM(CASE
        WHEN week_number = 17 THEN 1
        ELSE 0
    END) AS week_17,
    SUM(CASE
        WHEN week_number = 18 THEN 1
        ELSE 0
    END) AS week_18,
    SUM(CASE
        WHEN week_number = 19 THEN 1
        ELSE 0
    END) AS week_19
FROM
    (SELECT 
        m.user_id,
            m.login_week,
            n.first_week AS first_week,
            m.login_week - first_week AS week_number
    FROM
        (SELECT 
        user_id, WEEK(occurred_at) AS login_week
    FROM
        events
    GROUP BY user_id , WEEK(occurred_at)) m, (SELECT 
        user_id, MIN(WEEK(occurred_at)) AS first_week
    FROM
        events
    GROUP BY user_id) n
    WHERE
        m.user_id = n.user_id) with_week_number
GROUP BY first_week
ORDER BY first_week;

