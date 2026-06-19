-- Find the top 3 sellers by revenue within each product category using DENSE_RANK() OVER(PARTITION BY category).

WITH SellerCategoryRevenue AS (
    SELECT 
        pc.category_id,
        p.seller_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN product_categories pc ON p.product_id = pc.product_id
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY 
        pc.category_id, 
        p.seller_id
),
RankedSellers AS (
    SELECT 
        category_id,
        seller_id,
        total_revenue,
        DENSE_RANK() OVER(PARTITION BY category_id ORDER BY total_revenue DESC) AS seller_rank
    FROM 
        SellerCategoryRevenue
)
SELECT 
    c.category_name,
    rs.seller_id,
    sp.business_name,
    rs.total_revenue,
    rs.seller_rank
FROM 
    RankedSellers rs
JOIN categories c ON rs.category_id = c.category_id
JOIN seller_profiles sp ON rs.seller_id = sp.seller_id
WHERE 
    rs.seller_rank <= 3
ORDER BY 
    c.category_name, 
    rs.seller_rank;
