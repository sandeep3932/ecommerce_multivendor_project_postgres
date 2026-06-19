-- task4_q3_cancel_order.sql
-- Procedure to cancel an order within 24 hours, invoking refund if applicable.

CREATE OR REPLACE PROCEDURE cancel_order(
    p_order_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_order_status VARCHAR;
    v_created_at TIMESTAMP;
    v_payment_id INT;
    v_amount NUMERIC;
BEGIN
    -- Lock order row
    SELECT order_status, created_at INTO v_order_status, v_created_at
    FROM orders
    WHERE order_id = p_order_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Order % not found', p_order_id;
    END IF;

    -- Status validation
    IF v_order_status IN ('cancelled', 'delivered') THEN
        RAISE EXCEPTION 'Order cannot be cancelled. Current status: %', v_order_status;
    END IF;

    -- Time window validation
    IF NOW() > v_created_at + INTERVAL '24 hours' THEN
        RAISE EXCEPTION 'Cancellation window of 24 hours has expired.';
    END IF;

    -- Update status
    UPDATE orders 
    SET order_status = 'cancelled' 
    WHERE order_id = p_order_id;

    -- Find any successful payments to refund
    FOR v_payment_id, v_amount IN 
        SELECT payment_id, amount FROM payments WHERE order_id = p_order_id AND payment_status = 'success'
    LOOP
        -- Assume refund_payment takes payment_id and amount
        CALL refund_payment(v_payment_id, v_amount, NULL);
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
