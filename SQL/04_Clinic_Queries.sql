-- Q1. Revenue from each sales channel in a given year

SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel
ORDER BY total_revenue DESC;


-- Q2. Top 10 most valuable customers (highest spend) in 2021

SELECT 
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spend
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spend DESC
LIMIT 10;


-- Q3. Month-wise revenue, expense, profit and status

WITH revenue AS (
    SELECT 
        cid,
        YEAR(datetime) AS yr,
        MONTH(datetime) AS mon,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY cid, YEAR(datetime), MONTH(datetime)
),
expense AS (
    SELECT 
        cid,
        YEAR(datetime) AS yr,
        MONTH(datetime) AS mon,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY cid, YEAR(datetime), MONTH(datetime)
)
SELECT 
    COALESCE(r.cid, e.cid) AS cid,
    COALESCE(r.yr, e.yr) AS yr,
    COALESCE(r.mon, e.mon) AS mon,
    COALESCE(r.total_revenue, 0) AS revenue,
    COALESCE(e.total_expense, 0) AS expense,
    (COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0)) AS profit,
    CASE 
        WHEN (COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0)) > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM revenue r
LEFT JOIN expense e 
    ON r.cid = e.cid 
   AND r.yr = e.yr
   AND r.mon = e.mon
UNION
SELECT 
    COALESCE(r.cid, e.cid),
    COALESCE(r.yr, e.yr),
    COALESCE(r.mon, e.mon),
    COALESCE(r.total_revenue, 0),
    COALESCE(e.total_expense, 0),
    (COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0)),
    CASE 
        WHEN (COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0)) > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END
FROM expense e
LEFT JOIN revenue r
    ON r.cid = e.cid 
   AND r.yr = e.yr
   AND r.mon = e.mon;



-- Q4. For each city, find the most profitable clinic in a given month & year

WITH monthly_base AS (
    SELECT 
        c.cid,c.city,
        YEAR(cs.datetime) AS yr,
        MONTH(cs.datetime) AS mon,
        SUM(cs.amount) AS revenue
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    WHERE YEAR(cs.datetime) = 2021
    GROUP BY c.cid, c.city, YEAR(cs.datetime), MONTH(cs.datetime)
),
monthly_profit AS (
    SELECT 
        mb.cid,mb.city,mb.yr,mb.mon,mb.revenue,
        (
            SELECT COALESCE(SUM(e.amount),0)
            FROM expenses e
            WHERE e.cid = mb.cid
              AND YEAR(e.datetime) = mb.yr
              AND MONTH(e.datetime) = mb.mon
        ) AS expense
    FROM monthly_base mb
)
SELECT 
    cid,city,yr,mon,revenue,expense,(revenue - expense) AS profit
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY city, yr, mon ORDER BY (revenue - expense) DESC) AS rn
    FROM monthly_profit
) AS ranked
WHERE rn = 1
ORDER BY city, yr, mon;


-- Q5. For each state, find the second least profitable clinic in a given month & year

WITH monthly_base AS (
    SELECT 
        c.cid,c.state,
        YEAR(cs.datetime) AS yr,
        MONTH(cs.datetime) AS mon,
        SUM(cs.amount) AS revenue
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    WHERE YEAR(cs.datetime) = 2021
    GROUP BY c.cid, c.state, YEAR(cs.datetime), MONTH(cs.datetime)
),
clinic_profit AS (
    SELECT 
        mb.cid,mb.state,mb.yr,mb.mon,mb.revenue,
        (
            SELECT COALESCE(SUM(e.amount), 0)
            FROM expenses e
            WHERE e.cid = mb.cid
              AND YEAR(e.datetime) = mb.yr
              AND MONTH(e.datetime) = mb.mon
        ) AS expense
    FROM monthly_base mb
),
profit_calc AS (
    SELECT
        cid,state,yr,mon,(revenue - expense) AS profit
    FROM clinic_profit
)
SELECT 
    cid,state,yr,mon,profit
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY state, yr, mon ORDER BY profit ASC) AS rn
    FROM profit_calc
) ranked
WHERE rn = 2
ORDER BY state, yr, mon;
