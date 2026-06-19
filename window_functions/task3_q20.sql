-- Use ROW_NUMBER() to de-duplicate cart_items where the same product was added multiple times, keeping the latest.

WITH DeduplicatedCart AS (
    SELECT 
        cart_item_id,
        cart_id,
        product_id,
        quantity,
        ROW_NUMBER() OVER(PARTITION BY cart_id, product_id ORDER BY cart_item_id DESC) AS rn
    FROM 
        cart_items
)
SELECT 
    cart_item_id,
    cart_id,
    product_id,
    quantity
FROM 
    DeduplicatedCart
WHERE 
    rn = 1
ORDER BY 
    cart_id, 
    cart_item_id;
