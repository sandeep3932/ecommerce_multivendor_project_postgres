-- Task 2, Question 20
-- List all cart items that were never converted to an order, along with the customer email and cart age in days.

SELECT 
    ci.cart_item_id,
    p.product_name,
    u.email AS customer_email,
    CURRENT_DATE - DATE(c.expires_at) AS cart_age_days
FROM cart_items ci
INNER JOIN cart c ON ci.cart_id = c.cart_id
INNER JOIN customer_profiles cp ON c.customer_id = cp.customer_id
INNER JOIN users u ON cp.user_id = u.user_id
INNER JOIN products p ON ci.product_id = p.product_id
LEFT JOIN (
    orders o 
    INNER JOIN order_items oi ON o.order_id = oi.order_id
) ON o.customer_id = c.customer_id AND oi.product_id = ci.product_id
WHERE o.order_id IS NULL;
