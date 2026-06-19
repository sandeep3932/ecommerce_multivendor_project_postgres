-- task4_q13_low_stock_alert.sql
-- Trigger to insert an alert when inventory falls below threshold.

CREATE OR REPLACE FUNCTION trg_low_stock_alert()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if stock crossed the threshold downwards
    IF NEW.quantity_available < NEW.reorder_threshold AND OLD.quantity_available >= OLD.reorder_threshold THEN
        BEGIN
            -- Attempt to log into hypothetical inventory_alerts table
            EXECUTE 'INSERT INTO inventory_alerts (product_id, warehouse_id, alert_date, current_stock) VALUES ($1, $2, NOW(), $3)' 
            USING NEW.product_id, NEW.warehouse_id, NEW.quantity_available;
        EXCEPTION
            WHEN undefined_table THEN
                -- Fallback to raising a notice if the table does not exist
                RAISE NOTICE 'Low stock alert for product % in warehouse %. Current stock: %', NEW.product_id, NEW.warehouse_id, NEW.quantity_available;
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_after_update_inventory_stock
AFTER UPDATE OF quantity_available ON inventory
FOR EACH ROW
EXECUTE FUNCTION trg_low_stock_alert();
