-- Use a CTE to calculate total revenue per seller, then filter only sellers earning above the overall average.

WITH SellerRevenue AS (
    -- Calculate total revenue for each seller based on order items
    SELECT 
        p.seller_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM 
        products p
    JOIN 
        order_items oi ON p.product_id = oi.product_id
    GROUP BY 
        p.seller_id
),
OverallAverage AS (
    -- Calculate the overall average revenue across all sellers
    SELECT 
        AVG(total_revenue) AS avg_revenue
    FROM 
        SellerRevenue
)
SELECT 
    sp.seller_id,
    sp.business_name,
    sr.total_revenue
FROM 
    SellerRevenue sr
JOIN 
    seller_profiles sp ON sr.seller_id = sp.seller_id
CROSS JOIN 
    OverallAverage oa
WHERE 
    sr.total_revenue > oa.avg_revenue
ORDER BY 
    sr.total_revenue DESC;
