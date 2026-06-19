-- Find the first order date and most recent order date per customer using MIN() and MAX() as window functions.

SELECT DISTINCT
    customer_id,
    MIN(created_at) OVER(PARTITION BY customer_id) AS first_order_date,
    MAX(created_at) OVER(PARTITION BY customer_id) AS most_recent_order_date
FROM 
    orders
ORDER BY 
    customer_id;
