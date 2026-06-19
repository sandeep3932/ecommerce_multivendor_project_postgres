-- Compute each customer's average order value and compare it to the overall platform average using AVG() OVER().

WITH CustomerAvg AS (
    SELECT 
        customer_id,
        AVG(total_amount) AS customer_avg_order_value
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    customer_id,
    customer_avg_order_value,
    AVG(customer_avg_order_value) OVER() AS overall_platform_avg,
    customer_avg_order_value - AVG(customer_avg_order_value) OVER() AS difference_from_platform_avg
FROM 
    CustomerAvg
ORDER BY 
    difference_from_platform_avg DESC;
