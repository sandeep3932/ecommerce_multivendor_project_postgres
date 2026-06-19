-- Task 2, Question 4
-- Retrieve each order with customer name, seller name, and total amount using multi-table INNER JOIN.

SELECT 
    o.order_id,
    cu.full_name AS customer_name,
    s.business_name AS seller_name,
    o.total_amount
FROM orders o
INNER JOIN customer_profiles cp ON o.customer_id = cp.customer_id
INNER JOIN users cu ON cp.user_id = cu.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN seller_profiles s ON p.seller_id = s.seller_id;
