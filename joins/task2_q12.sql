-- Task 2, Question 12
-- Find orders where the payment failed — join orders, payments, and payment_transactions.

SELECT 
    o.order_id,
    o.customer_id,
    o.total_amount,
    p.payment_method,
    pt.transaction_status,
    pt.transaction_date
FROM orders o
INNER JOIN payments p ON o.order_id = p.order_id
INNER JOIN payment_transactions pt ON p.payment_id = pt.payment_id
WHERE pt.transaction_status = 'failed' OR p.payment_status = 'failed';
