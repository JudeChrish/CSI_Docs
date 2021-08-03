DECLARE
   query_str VARCHAR(2000);
   query1 VARCHAR(2000);
   query2 VARCHAR(2000);  
   query3 VARCHAR(2000);
   tableName VARCHAR(2000);
   
    -- cursor
  CURSOR cTablelist IS  SELECT TABLE_NAME  FROM user_tables WHERE TABLE_NAME LIKE 'LB%'  ORDER BY TABLE_NAME;

BEGIN

    query1 := 'ALTER TABLE "';
	query2 := '" RENAME TO "';
	query3 := '";';

	DBMS_OUTPUT.PUT_LINE('Table Renaming Script Started');
    OPEN cTablelist;
    LOOP
    FETCH cTablelist INTO tableName;
    EXIT WHEN cTablelist%NOTFOUND;
    
    
    query_str := query1 || tableName || query2 || upper(tablename) || query3;
	DBMS_OUTPUT.PUT_LINE('Query is :- '||query_str );
	--EXECUTE IMMEDIATE query_str;
    END LOOP;
    CLOSE cTablelist;
DBMS_OUTPUT.PUT_LINE('Script completed.'); 
END;
