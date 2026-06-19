-- task4_q15_process_return.sql
-- Complete return process inside a single transaction.

CREATE OR REPLACE PROCEDURE process_return(
    p_order_item_id INT,
    p_reason_code VARCHAR,
    p_item_condition VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_order_id INT;
    v_created_at TIMESTAMP;
    v_payment_id INT;
    v_amount NUMERIC;
    v_return_id INT;
BEGIN
    SELECT o.order_id, o.created_at INTO v_order_id, v_created_at
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE oi.order_item_id = p_order_item_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Order item % not found', p_order_item_id;
    END IF;

    IF NOW() > v_created_at + INTERVAL '30 days' THEN
        RAISE EXCEPTION 'Return window of 30 days has expired.';
    END IF;

    INSERT INTO returns (order_item_id, reason_code, item_condition, returned_at)
    VALUES (p_order_item_id, p_reason_code, p_item_condition, NOW())
    RETURNING return_id INTO v_return_id;

    SELECT payment_id, amount INTO v_payment_id, v_amount
    FROM payments 
    WHERE order_id = v_order_id AND payment_status = 'success'
    LIMIT 1;

    IF FOUND THEN
        CALL refund_payment(v_payment_id, v_amount, v_return_id);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
