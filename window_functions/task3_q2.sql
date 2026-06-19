-- List the top 5 best-selling products per category — filter using a subquery WHERE rank <= 5.

SELECT 
    category_id, 
    category_name,
    product_id, 
    product_name, 
    total_revenue, 
    revenue_rank
FROM (
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
        p.product_name
) ranked_products
WHERE 
    revenue_rank <= 5;
