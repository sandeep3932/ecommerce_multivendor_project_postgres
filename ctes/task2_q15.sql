-- Write a CTE to find repeat customers — those who have placed more than 5 completed orders.

WITH CustomerOrderCounts AS (
    -- Count the number of completed orders per customer
    SELECT 
        customer_id,
        COUNT(order_id) AS completed_order_count
    FROM 
        orders
    WHERE 
        -- Filtering for completed orders (ensure case-insensitivity depending on data)
        LOWER(order_status) = 'completed'
    GROUP BY 
        customer_id
)
SELECT 
    cp.customer_id,
    u.full_name,
    u.email,
    coc.completed_order_count
FROM 
    CustomerOrderCounts coc
JOIN 
    customer_profiles cp ON coc.customer_id = cp.customer_id
JOIN 
    users u ON cp.user_id = u.user_id
WHERE 
    coc.completed_order_count > 5
ORDER BY 
    coc.completed_order_count DESC;
