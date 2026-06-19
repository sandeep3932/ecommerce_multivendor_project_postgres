-- task2_q5.sql
-- Find all products that have been ordered at least once using EXISTS subquery.

SELECT 
    p.product_id,
    p.product_name,
    p.base_price
FROM 
    products p
WHERE 
    EXISTS (
        -- Subquery to check if the product appears in the order_items table
        SELECT 1
        FROM order_items oi
        WHERE oi.product_id = p.product_id
    );
