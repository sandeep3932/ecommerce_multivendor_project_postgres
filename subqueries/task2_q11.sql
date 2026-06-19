-- task2_q11.sql
-- Retrieve each seller's best-selling product (by quantity sold) using a subquery.

SELECT 
    s.business_name,
    best_sellers.product_id,
    best_sellers.product_name,
    best_sellers.total_quantity_sold
FROM (
    -- Subquery to aggregate quantity sold per product and rank them per seller
    SELECT 
        p.seller_id,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold,
        RANK() OVER(PARTITION BY p.seller_id ORDER BY SUM(oi.quantity) DESC) as rnk
    FROM 
        products p
    JOIN 
        order_items oi ON p.product_id = oi.product_id
    GROUP BY 
        p.seller_id, 
        p.product_id,
        p.product_name
) best_sellers
JOIN 
    seller_profiles s ON best_sellers.seller_id = s.seller_id
WHERE 
    best_sellers.rnk = 1;
