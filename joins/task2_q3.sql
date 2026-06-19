-- Task 2, Question 3
-- List all sellers along with their total number of products — include sellers with zero products using LEFT JOIN.

SELECT 
    s.seller_id,
    s.business_name,
    COUNT(p.product_id) AS total_products
FROM seller_profiles s
LEFT JOIN products p ON s.seller_id = p.seller_id
GROUP BY s.seller_id, s.business_name;
