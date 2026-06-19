-- Rank all products by total revenue within each category using RANK() OVER(PARTITION BY category_id).

SELECT 
    pc.category_id,
    c.category_name,
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER(PARTITION BY pc.category_id ORDER BY SUM(oi.quantity * oi.unit_price) DESC) as revenue_rank
FROM products p
JOIN product_categories pc ON p.product_id = pc.product_id
JOIN categories c ON pc.category_id = c.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY 
    pc.category_id, 
    c.category_name,
    p.product_id, 
    p.product_name;
