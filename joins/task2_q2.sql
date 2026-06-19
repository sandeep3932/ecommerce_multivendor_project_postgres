-- Task 2, Question 2
-- Find all customers who have never placed an order using LEFT JOIN with a NULL check on orders.

SELECT 
    cp.customer_id,
    u.full_name,
    u.email
FROM customer_profiles cp
INNER JOIN users u ON cp.user_id = u.user_id
LEFT JOIN orders o ON cp.customer_id = o.customer_id
WHERE o.order_id IS NULL;
