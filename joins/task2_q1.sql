-- Task 2, Question 1
-- List all products with their seller name, brand name, and category using INNER JOIN across four tables.

SELECT 
    p.product_id,
    p.product_name,
    s.business_name AS seller_name,
    b.brand_name,
    c.category_name
FROM products p
INNER JOIN seller_profiles s ON p.seller_id = s.seller_id
INNER JOIN brands b ON p.brand_id = b.brand_id
INNER JOIN product_categories pc ON p.product_id = pc.product_id
INNER JOIN categories c ON pc.category_id = c.category_id;
