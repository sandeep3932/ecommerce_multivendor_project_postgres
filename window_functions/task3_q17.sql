-- Use PERCENT_RANK() to show where each seller stands relative to all sellers by revenue.

WITH SellerRevenue AS (
    SELECT 
        p.seller_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY 
        p.seller_id
)
SELECT 
    seller_id,
    total_revenue,
    ROUND(CAST(PERCENT_RANK() OVER(ORDER BY total_revenue) AS numeric), 4) AS revenue_percent_rank
FROM 
    SellerRevenue
ORDER BY 
    revenue_percent_rank DESC;
