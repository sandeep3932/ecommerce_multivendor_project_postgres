-- Task 2, Question 17
-- List all returned orders with customer name, product name, return reason, and refund amount.

SELECT 
    u.full_name AS customer_name,
    p.product_name,
    r.reason_code AS return_reason,
    rf.refund_amount
FROM returns r
INNER JOIN order_items oi ON r.order_item_id = oi.order_item_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN customer_profiles cp ON o.customer_id = cp.customer_id
INNER JOIN users u ON cp.user_id = u.user_id
INNER JOIN products p ON oi.product_id = p.product_id
LEFT JOIN refunds rf ON r.return_id = rf.return_id;
