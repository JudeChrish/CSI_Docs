
CREATE OR REPLACE FUNCTION column_renaming_scriptGeneration(tablename text) 
RETURNS VOID AS $$
DECLARE
   --Tablerec RECORD;
   Columnrec RECORD;
   query_str text;
   query1 text;
   query2 text;  
   query3 text;
   query4 text;
begin
	query1 := 'ALTER TABLE "';
	query2 := '" RENAME COLUMN "';
	query3 := '" TO "';
	query4 := '";';
	
	RAISE NOTICE '--Table Name :- %', tablename;
   	FOR Columnrec in SELECT column_name  FROM information_schema.columns WHERE table_schema = 'public'  AND table_name = tablename
--FOR Columnrec in SELECT column_name  FROM information_schema.columns WHERE table_schema = 'public'  AND table_name = 'lbadt_doctor'
    	loop
	    	query_str := query1 || tablename || query2 || Columnrec.column_name || query3 || lower(Columnrec.column_name) || query4	;
			--EXECUTE  query_str;
		RAISE NOTICE '%', query_str;	
		end loop;
END;
$$ LANGUAGE plpgsql;