-- Task 2, Question 10
-- List all coupons that have never been used by any customer using LEFT JOIN on coupon_usage.

SELECT 
    c.coupon_id,
    c.coupon_code,
    c.discount_type,
    c.discount_value
FROM coupons c
LEFT JOIN coupon_usage cu ON c.coupon_id = cu.coupon_id
WHERE cu.usage_id IS NULL;
