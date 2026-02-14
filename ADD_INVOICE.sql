CREATE OR REPLACE PROCEDURE COPILOT_DB.STATS.ADD_INVOICE(
    invoice_name VARCHAR,
    invoice_content VARCHAR
) COPY GRANTS 
RETURNS VARCHAR
LANGUAGE SQL

AS
$$
DECLARE
    rows_added INTEGER;
    sql_statement VARCHAR;
BEGIN
    -- Build the INSERT statement
    sql_statement := 'INSERT INTO COPILOT_DB.STATS.INVOICES_CHUNKED (relative_path, chunk, language) VALUES (\'' || invoice_name || '\',\''||invoice_content||'\', \'English\');';
    
    -- Execute the DELETE statement
    EXECUTE IMMEDIATE sql_statement;
    
    -- Get the number of rows deleted
    rows_added := SQLROWCOUNT;
    
    -- Return success message
    RETURN 'Successfully added ' || rows_added || ' row(s) ';
END;
$$;
