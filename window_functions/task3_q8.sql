-- Calculate a 7-day rolling average order value using AVG() OVER with ROWS BETWEEN 6 PRECEDING AND CURRENT ROW.

WITH DailyAvg AS (
    SELECT 
        DATE(created_at) AS order_date,
        AVG(total_amount) AS avg_order_value
    FROM 
        orders
    GROUP BY 
        DATE(created_at)
)
SELECT 
    order_date,
    avg_order_value,
    AVG(avg_order_value) OVER(
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7_day_avg_order_value
FROM 
    DailyAvg
ORDER BY 
    order_date;
