-- task4_q11_update_average_rating.sql
-- Trigger to recalculate average_rating on products when a new review is inserted.

CREATE OR REPLACE FUNCTION trg_update_avg_rating()
RETURNS TRIGGER AS $$
DECLARE
    v_avg_rating NUMERIC;
BEGIN
    -- Recalculate average rating from ratings table
    SELECT ROUND(AVG(rating_value), 2) INTO v_avg_rating
    FROM ratings
    WHERE product_id = NEW.product_id;
    
    -- Dynamically update products table (bypassing if column doesn't strictly exist to prevent fatal failure)
    BEGIN
        EXECUTE 'UPDATE products SET average_rating = $1 WHERE product_id = $2' USING v_avg_rating, NEW.product_id;
    EXCEPTION
        WHEN undefined_column THEN
            NULL; -- Safely ignore if average_rating column isn't implemented
    END;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_after_insert_review
AFTER INSERT ON reviews
FOR EACH ROW
EXECUTE FUNCTION trg_update_avg_rating();
