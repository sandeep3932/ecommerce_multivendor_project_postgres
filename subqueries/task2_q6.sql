-- task2_q6.sql
-- Find all products that have never been ordered using NOT EXISTS.

SELECT 
    p.product_id,
    p.product_name,
    p.base_price
FROM 
    products p
WHERE 
    NOT EXISTS (
        -- Subquery returns true if the product has any order items,
        -- NOT EXISTS will filter out those products, leaving only unordered ones.
        SELECT 1
        FROM order_items oi
        WHERE oi.product_id = p.product_id
    );
