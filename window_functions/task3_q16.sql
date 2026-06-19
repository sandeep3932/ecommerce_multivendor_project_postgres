-- Calculate the cumulative number of orders placed per day using COUNT() OVER(ORDER BY order_date).

SELECT 
    order_id,
    DATE(created_at) AS order_date,
    COUNT(order_id) OVER(ORDER BY DATE(created_at)) AS cumulative_orders
FROM 
    orders
ORDER BY 
    DATE(created_at), 
    order_id;
