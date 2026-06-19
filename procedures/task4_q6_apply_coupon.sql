-- task4_q6_apply_coupon.sql
-- Validate coupon constraints before discounting.

CREATE OR REPLACE PROCEDURE apply_coupon(
    p_coupon_code VARCHAR,
    p_customer_id INT,
    p_cart_total NUMERIC,
    OUT p_discount_amount NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_coupon_id INT;
    v_discount_type VARCHAR;
    v_discount_value NUMERIC;
    v_max_uses INT;
    v_expiry_date DATE;
    v_min_order NUMERIC;
    v_times_used INT;
BEGIN
    SELECT coupon_id, discount_type, discount_value, max_uses, expiry_date, minimum_order_value
    INTO v_coupon_id, v_discount_type, v_discount_value, v_max_uses, v_expiry_date, v_min_order
    FROM coupons
    WHERE coupon_code = p_coupon_code;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Coupon % is invalid', p_coupon_code;
    END IF;

    IF v_expiry_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Coupon % has expired', p_coupon_code;
    END IF;

    IF p_cart_total < v_min_order THEN
        RAISE EXCEPTION 'Cart total % does not meet minimum order value %', p_cart_total, v_min_order;
    END IF;

    SELECT COUNT(*) INTO v_times_used
    FROM coupon_usage
    WHERE coupon_id = v_coupon_id;

    IF v_times_used >= v_max_uses THEN
        RAISE EXCEPTION 'Coupon % has reached its maximum number of uses', p_coupon_code;
    END IF;

    IF v_discount_type = 'percentage' THEN
        p_discount_amount := p_cart_total * (v_discount_value / 100.0);
    ELSE
        p_discount_amount := v_discount_value;
    END IF;

    IF p_discount_amount > p_cart_total THEN
        p_discount_amount := p_cart_total;
    END IF;

END;
$$;
