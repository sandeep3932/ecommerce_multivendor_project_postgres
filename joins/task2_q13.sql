-- Task 2, Question 13
-- List all products with their average rating and total review count using LEFT JOIN on reviews and ratings.

SELECT 
    p.product_id,
    p.product_name,
    COUNT(DISTINCT rv.review_id) AS total_review_count,
    AVG(rt.rating) AS average_rating
FROM products p
LEFT JOIN reviews rv ON p.product_id = rv.product_id
LEFT JOIN ratings rt ON p.product_id = rt.product_id
GROUP BY p.product_id, p.product_name;
