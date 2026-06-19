-- Assign ROW_NUMBER() to each customer's orders sorted by date to identify their first and latest purchase.

SELECT 
    customer_id,
    order_id,
    created_at AS order_date,
    -- First purchase has row number 1 when ordered ascending
    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY created_at ASC) as first_purchase_rn,
    -- Latest purchase has row number 1 when ordered descending
    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY created_at DESC) as latest_purchase_rn
FROM 
    orders
ORDER BY 
    customer_id, 
    created_at;
