CREATE TABLE temp_table AS
WITH AggregatedItems AS (
    SELECT
        product_id,
        MAX(category_id) AS category_id,
        STRING_AGG(DISTINCT category_code, ', ') AS category_codes, -- Aggregates all unique category codes
        STRING_AGG(DISTINCT brand, ', ') AS brands -- Aggregates all unique brands
    FROM
        items
    GROUP BY
        product_id
)
SELECT
    C.event_time,
    C.event_type,
    C.product_id,
    C.price,
    C.user_id,
    C.user_session,
    AI.category_id,
    AI.category_codes,
    AI.brands
FROM
    customers C
LEFT JOIN
    AggregatedItems AI ON C.product_id = AI.product_id;

DROP TABLE customers;
ALTER TABLE temp_table RENAME TO customers;
