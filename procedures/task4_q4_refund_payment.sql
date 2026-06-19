-- task4_q4_refund_payment.sql
-- Procedure to validate and process a refund

CREATE OR REPLACE PROCEDURE refund_payment(
    p_payment_id INT,
    p_refund_amount NUMERIC,
    p_return_id INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_payment_amount NUMERIC;
    v_payment_status VARCHAR;
BEGIN
    -- Lock payment row
    SELECT amount, payment_status INTO v_payment_amount, v_payment_status
    FROM payments
    WHERE payment_id = p_payment_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Payment % not found', p_payment_id;
    END IF;

    IF v_payment_status != 'success' THEN
        RAISE EXCEPTION 'Cannot refund a payment with status: %', v_payment_status;
    END IF;

    IF p_refund_amount > v_payment_amount THEN
        RAISE EXCEPTION 'Refund amount % exceeds original payment %', p_refund_amount, v_payment_amount;
    END IF;

    -- Update payment status to refunded
    UPDATE payments 
    SET payment_status = 'refunded' 
    WHERE payment_id = p_payment_id;

    -- Insert into refunds table
    INSERT INTO refunds (return_id, refund_amount, refund_method, processed_at)
    VALUES (p_return_id, p_refund_amount, 'original_payment_method', NOW());

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
