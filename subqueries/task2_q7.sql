-- Use a correlated subquery to list products priced above their own category's average price.

SELECT 
    p.product_id,
    p.product_name,
    p.base_price,
    c.category_name
FROM 
    products p
JOIN 
    product_categories pc ON p.product_id = pc.product_id
JOIN 
    categories c ON pc.category_id = c.category_id
WHERE 
    p.base_price > (
        -- Correlated subquery calculating the average base_price for the current product's category
        SELECT AVG(p2.base_price)
        FROM products p2
        JOIN product_categories pc2 ON p2.product_id = pc2.product_id
        WHERE pc2.category_id = pc.category_id
    );
