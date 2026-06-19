-- task4_q2_select_for_update.sql
-- Procedure with SELECT ... FOR UPDATE to prevent race conditions during inventory check.

CREATE OR REPLACE PROCEDURE place_order_with_lock(
    p_customer_id INT,
    p_cart_id INT,
    p_coupon_id INT DEFAULT NULL,
    p_payment_method VARCHAR DEFAULT 'credit_card'
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_order_id INT;
    v_total_amount NUMERIC := 0;
    v_item RECORD;
    v_stock INT;
    v_inventory_id INT;
BEGIN
    INSERT INTO orders (customer_id, order_status, total_amount, created_at)
    VALUES (p_customer_id, 'pending', 0, NOW())
    RETURNING order_id INTO v_order_id;

    FOR v_item IN (
        SELECT ci.product_id, ci.quantity, p.base_price 
        FROM cart_items ci 
        JOIN products p ON ci.product_id = p.product_id 
        WHERE ci.cart_id = p_cart_id
    )
    LOOP
        -- SELECT FOR UPDATE row-level lock
        SELECT inventory_id, quantity_available INTO v_inventory_id, v_stock
        FROM inventory
        WHERE product_id = v_item.product_id
        FOR UPDATE;

        IF v_stock < v_item.quantity THEN
            RAISE EXCEPTION 'Insufficient stock for product %', v_item.product_id;
        END IF;

        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (v_order_id, v_item.product_id, v_item.quantity, v_item.base_price);

        v_total_amount := v_total_amount + (v_item.quantity * v_item.base_price);
    END LOOP;

    UPDATE orders SET total_amount = v_total_amount WHERE order_id = v_order_id;

    INSERT INTO payments (order_id, payment_method, payment_status, amount, paid_at)
    VALUES (v_order_id, p_payment_method, 'pending', v_total_amount, NOW());

    DELETE FROM cart_items WHERE cart_id = p_cart_id;
    DELETE FROM cart WHERE cart_id = p_cart_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
