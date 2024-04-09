DO $$
DECLARE
    tn text;
    sql_insert text := 'INSERT INTO customers(event_time, event_type, product_id, price, user_id, user_session) ';
BEGIN
    FOR tn IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name LIKE 'data\_202%' ESCAPE '\'
    LOOP
        sql_insert := sql_insert || 'SELECT event_time, event_type, product_id, price, user_id, user_session FROM ' || quote_ident(tn) || ' UNION ALL ';
    END LOOP;

    sql_insert := rtrim(sql_insert, ' UNION ALL ');

    CREATE TABLE IF NOT EXISTS customers(
        event_time TIMESTAMPTZ,
        event_type TEXT,
        product_id BIGINT,
        price NUMERIC,
        user_id INTEGER,
        user_session UUID
    );
    TRUNCATE customers;
    EXECUTE sql_insert;
END $$;
