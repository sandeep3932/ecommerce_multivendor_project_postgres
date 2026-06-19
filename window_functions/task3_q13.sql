-- Use LEAD() to find the next order date for each customer and compute days between consecutive orders.

WITH NextOrders AS (
    SELECT 
        customer_id,
        order_id,
        created_at AS current_order_date,
        LEAD(created_at) OVER(PARTITION BY customer_id ORDER BY created_at) AS next_order_date
    FROM 
        orders
)
SELECT 
    customer_id,
    order_id,
    current_order_date,
    next_order_date,
    EXTRACT(DAY FROM (next_order_date - current_order_date)) AS days_between_orders
FROM 
    NextOrders
ORDER BY 
    customer_id, 
    current_order_date;
