-- Task 2, Question 18
-- Find sellers who have received at least one 1-star review using JOIN across sellers, products, and ratings.

SELECT DISTINCT
    s.seller_id,
    s.business_name
FROM seller_profiles s
INNER JOIN products p ON s.seller_id = p.seller_id
INNER JOIN ratings r ON p.product_id = r.product_id
WHERE r.rating = 1;
