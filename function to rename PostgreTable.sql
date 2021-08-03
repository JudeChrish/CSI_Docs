
CREATE OR REPLACE FUNCTION for_loop_through_query() 
RETURNS VOID AS $$
DECLARE
    rec RECORD;
   query text;
   query1 text;
   query2 text;  
   query3 text;
begin
	query1 := 'ALTER TABLE  public."';
	query2 := '" RENAME TO "';
	query3 := '"';

    FOR rec IN SELECT tablename FROM pg_catalog.pg_tables where schemaname= 'public' and tablename like 'LB%' order by tablename
    LOOP 
		query := query1 || rec.tablename || query2 || lower(rec.tablename) || query3;
		EXECUTE  query;
	RAISE NOTICE '%', query;
 RAISE NOTICE '% - %', rec.tablename,lower(rec.tablename);
    END LOOP;
END;
$$ LANGUAGE plpgsql;