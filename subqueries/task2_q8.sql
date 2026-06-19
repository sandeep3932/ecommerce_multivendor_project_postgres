-- task2_q8.sql
-- List the top 3 most expensive products per seller using a subquery with ORDER BY and LIMIT.

SELECT 
    p.seller_id,
    s.business_name,
    p.product_id,
    p.product_name,
    p.base_price
FROM 
    products p
JOIN 
    seller_profiles s ON p.seller_id = s.seller_id
WHERE 
    p.product_id IN (
        -- Subquery to find the top 3 most expensive products for the current seller
        SELECT p2.product_id
        FROM products p2
        WHERE p2.seller_id = p.seller_id
        ORDER BY p2.base_price DESC
        LIMIT 3
    )
ORDER BY 
    p.seller_id, 
    p.base_price DESC;
