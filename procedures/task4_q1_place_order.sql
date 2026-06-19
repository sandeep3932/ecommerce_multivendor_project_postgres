-- task4_q1_place_order.sql
-- Procedure to place an order, processing cart items and recording payment.
-- Everything is wrapped in a transaction implicitly by PL/pgSQL; explicit ROLLBACK on error.

CREATE OR REPLACE PROCEDURE place_order(
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
BEGIN
    -- 1. Insert order
    INSERT INTO orders (customer_id, order_status, total_amount, created_at)
    VALUES (p_customer_id, 'pending', 0, NOW())
    RETURNING order_id INTO v_order_id;

    -- 2. Process cart items
    FOR v_item IN (
        SELECT ci.product_id, ci.quantity, p.base_price 
        FROM cart_items ci 
        JOIN products p ON ci.product_id = p.product_id 
        WHERE ci.cart_id = p_cart_id
    )
    LOOP
        -- Check stock
        SELECT quantity_available INTO v_stock
        FROM inventory
        WHERE product_id = v_item.product_id;

        IF v_stock < v_item.quantity THEN
            RAISE EXCEPTION 'Insufficient stock for product %', v_item.product_id;
        END IF;

        -- Insert order item
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (v_order_id, v_item.product_id, v_item.quantity, v_item.base_price);

        v_total_amount := v_total_amount + (v_item.quantity * v_item.base_price);
    END LOOP;

    -- 3. Update total amount
    UPDATE orders SET total_amount = v_total_amount WHERE order_id = v_order_id;

    -- 4. Record Payment
    INSERT INTO payments (order_id, payment_method, payment_status, amount, paid_at)
    VALUES (v_order_id, p_payment_method, 'pending', v_total_amount, NOW());

    -- 5. Clear cart
    DELETE FROM cart_items WHERE cart_id = p_cart_id;
    DELETE FROM cart WHERE cart_id = p_cart_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
