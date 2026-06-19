-- task4_q12_generate_invoice.sql
-- Trigger to generate an invoice when payment status becomes 'success'.

CREATE OR REPLACE FUNCTION trg_generate_invoice_on_payment()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.payment_status = 'success' THEN
        INSERT INTO invoices (order_id, invoice_date, total_amount)
        VALUES (NEW.order_id, CURRENT_DATE, NEW.amount)
        ON CONFLICT DO NOTHING;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_after_insert_payment
AFTER INSERT OR UPDATE OF payment_status ON payments
FOR EACH ROW
WHEN (NEW.payment_status = 'success')
EXECUTE FUNCTION trg_generate_invoice_on_payment();
