
-- Q1. For every user, get user_id and last booked room_no

SELECT user_id, name, room_no, booking_date
FROM (
    SELECT u.user_id, u.name, b.room_no, b.booking_date,
           ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY b.booking_date DESC) AS rn
    FROM users u
    LEFT JOIN bookings b ON u.user_id = b.user_id
) x
WHERE rn = 1;


-- Q2. Get booking_id and total billing amount for bookings created in November 2021

SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
  AND MONTH(bc.bill_date) = 11
GROUP BY bc.booking_id;


-- Q3. Get bill_id and bill amount of all bills in Oct 2021 having total > 1000

SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING bill_amount > 1000;


-- Q4. Determine the most and least ordered item for each month of 2021

WITH monthly_item AS (
    SELECT 
        YEAR(bill_date) AS yr,
        MONTH(bill_date) AS mon,
        item_id,
        SUM(item_quantity) AS qty
    FROM booking_commercials
    WHERE YEAR(bill_date) = 2021
    GROUP BY YEAR(bill_date), MONTH(bill_date), item_id
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY yr, mon ORDER BY qty DESC) AS rn_desc,
           ROW_NUMBER() OVER (PARTITION BY yr, mon ORDER BY qty ASC) AS rn_asc
    FROM monthly_item
)
SELECT 
    r1.yr,
    r1.mon,
    (SELECT item_name FROM items i WHERE i.item_id = r1.item_id) AS most_ordered_item,
    r1.qty AS most_qty,
    (SELECT item_name FROM items i WHERE i.item_id = r2.item_id) AS least_ordered_item,
    r2.qty AS least_qty
FROM ranked r1
JOIN ranked r2 
    ON r1.yr = r2.yr 
   AND r1.mon = r2.mon
WHERE r1.rn_desc = 1
  AND r2.rn_asc = 1
ORDER BY r1.yr, r1.mon;


-- Q5. Find the customers with the second-highest bill value of each month of 2021

WITH bill_totals AS (
    SELECT 
        bc.bill_id,
        b.user_id,
        YEAR(bc.bill_date) AS yr,
        MONTH(bc.bill_date) AS mon,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY bc.bill_id, b.user_id, YEAR(bill_date), MONTH(bill_date)
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY yr, mon ORDER BY bill_amount DESC) AS rn
    FROM bill_totals
)
SELECT 
    r.yr,
    r.mon,
    r.bill_id,
    r.user_id,
    u.name,
    r.bill_amount
FROM ranked r
JOIN users u ON r.user_id = u.user_id
WHERE r.rn = 2
ORDER BY r.yr, r.mon;
