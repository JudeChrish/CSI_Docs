--1 execute following script and check whethere there are records appering
SELECT p.GROUPID,p.MAPPEDHOSPITALID,p.TESTMAINID,count(p.TESTMAINID),max(p.TESTMAINREVISIONID) AS MAX_TESTMAINEREVISIONID
		FROM LBTDR_HOSPITALTESTMAIN p 
		WHERE p.ISACTIVE = 1 AND p.STATUSREVISIONID = 2 AND P.ISENABLE = 1
		GROUP BY p.MAPPEDHOSPITALID,p.GROUPID,p.TESTMAINID
		HAVING count(p.TESTMAINID) > 1 
		
--2 if there are records then run following set 
CREATE TABLE JCBKP_LBTDR_HOSPITALTESTMAIN AS SELECT * FROM LB_LABSERVICE.LBTDR_HOSPITALTESTMAIN lh;

--3 delete duplicates
DELETE FROM LBTDR_HOSPITALTESTMAIN WHERE TESTMAINREVISIONID IN (
WITH 
	duplicate_all_with_MAX_TESTMAINEREVISIONID AS 
	(
		SELECT p.GROUPID,p.MAPPEDHOSPITALID,p.TESTMAINID,count(p.TESTMAINID),max(p.TESTMAINREVISIONID) AS MAX_TESTMAINEREVISIONID
		FROM LBTDR_HOSPITALTESTMAIN p 
		WHERE p.ISACTIVE = 1 AND p.STATUSREVISIONID = 2 AND P.ISENABLE = 1
		GROUP BY p.MAPPEDHOSPITALID,p.GROUPID,p.TESTMAINID
		HAVING count(p.TESTMAINID) > 1 
),
all_duplicates as
	(SELECT p.GROUPID,p.MAPPEDHOSPITALID,p.TESTMAINID,t.TESTMAINREVISIONID FROM duplicate_all_with_MAX_TESTMAINEREVISIONID p
		INNER JOIN 
		(SELECT * FROM LBTDR_HOSPITALTESTMAIN WHERE ISACTIVE = 1 AND STATUSREVISIONID = 2 AND ISENABLE = 1) t 
		ON p.GROUPID = t.GROUPID AND p.MAPPEDHOSPITALID = t.MAPPEDHOSPITALID AND p.TESTMAINID = t.TESTMAINID 
		),
LesThanMaxRecordsof AS 
(
	SELECT a.TESTMAINREVISIONID,a.TESTMAINID,a.MAPPEDHOSPITALID,a.GROUPID FROM all_duplicates a
	WHERE a.TESTMAINREVISIONID NOT IN (SELECT MAX_TESTMAINEREVISIONID FROM duplicate_all_with_MAX_TESTMAINEREVISIONID)
	ORDER BY a.TESTMAINID 
)
--SELECT * FROM LesThanMaxRecordsof;
SELECT TESTMAINREVISIONID FROM LesThanMaxRecordsof
);

