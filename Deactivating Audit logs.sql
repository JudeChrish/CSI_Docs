============================================================================================================
Deactivating Audit logs
============================================================================================================
STEP 1- Execute the following script to create table with data.
------------------------------------------------------------------

CREATE TABLE deletingRecordsofAuditLog AS 
WITH 
		MedicalVerified_Orderids AS 
		(
			SELECT * FROM 
			(
				SELECT DISTINCT lv.LABORDERID,lv.RESULTSTATUS,lv.MODIFIEDON FROM LBRST_VALUEBASEDRESULT lv 
				UNION
				SELECT DISTINCT lt.LABORDERID ,lt.RESULTSTATUS,lt.MODIFIEDON FROM LBRST_TEXTBASEDRESULT lt
				UNION
				SELECT DISTINCT lm.LABORDERID,lm.RESULTSTATUS,lm.MODIFIEDON FROM LBRST_MICROBIOLOGYRESULT lm
				UNION
				SELECT DISTINCT lh.LABORDERID,lh.RESULTSTATUS,lh.MODIFIEDON FROM LBRST_HISTOPATHALOGYRESULT lh
			)
			WHERE RESULTSTATUS = 4 AND MODIFIEDON <= '03-JUL-21'
		),
		Ordered_Orderids AS 
		(
			SELECT * FROM 
			(
				SELECT DISTINCT lv.LABORDERID,lv.RESULTSTATUS,lv.MODIFIEDON FROM LBRST_VALUEBASEDRESULT lv 
				UNION
				SELECT DISTINCT lt.LABORDERID ,lt.RESULTSTATUS,lt.MODIFIEDON FROM LBRST_TEXTBASEDRESULT lt
				UNION
				SELECT DISTINCT lm.LABORDERID,lm.RESULTSTATUS,lm.MODIFIEDON FROM LBRST_MICROBIOLOGYRESULT lm
				UNION
				SELECT DISTINCT lh.LABORDERID,lh.RESULTSTATUS,lh.MODIFIEDON FROM LBRST_HISTOPATHALOGYRESULT lh
			)
			WHERE RESULTSTATUS = 1 AND MODIFIEDON <= '03-JUL-21'
		),
		Resulted_Orderids AS 
		(
			SELECT * FROM 
			(
				SELECT DISTINCT lv.LABORDERID,lv.RESULTSTATUS,lv.MODIFIEDON FROM LBRST_VALUEBASEDRESULT lv 
				UNION
				SELECT DISTINCT lt.LABORDERID ,lt.RESULTSTATUS,lt.MODIFIEDON FROM LBRST_TEXTBASEDRESULT lt
				UNION
				SELECT DISTINCT lm.LABORDERID,lm.RESULTSTATUS,lm.MODIFIEDON FROM LBRST_MICROBIOLOGYRESULT lm
				UNION
				SELECT DISTINCT lh.LABORDERID,lh.RESULTSTATUS,lh.MODIFIEDON FROM LBRST_HISTOPATHALOGYRESULT lh
			)
			WHERE RESULTSTATUS = 1 AND MODIFIEDON <= '03-JUL-21'
		),
		VerifiedLevel1_Orderids AS 
		(
			SELECT * FROM 
			(
				SELECT DISTINCT lv.LABORDERID,lv.RESULTSTATUS,lv.MODIFIEDON FROM LBRST_VALUEBASEDRESULT lv 
				UNION
				SELECT DISTINCT lt.LABORDERID ,lt.RESULTSTATUS,lt.MODIFIEDON FROM LBRST_TEXTBASEDRESULT lt
				UNION
				SELECT DISTINCT lm.LABORDERID,lm.RESULTSTATUS,lm.MODIFIEDON FROM LBRST_MICROBIOLOGYRESULT lm
				UNION
				SELECT DISTINCT lh.LABORDERID,lh.RESULTSTATUS,lh.MODIFIEDON FROM LBRST_HISTOPATHALOGYRESULT lh
			)
			WHERE RESULTSTATUS = 1 AND MODIFIEDON <= '03-JUL-21'
		),
		Caccelled_Orderids AS 
		(
			SELECT * FROM 
			(
				SELECT DISTINCT lv.LABORDERID,lv.RESULTSTATUS,lv.MODIFIEDON FROM LBRST_VALUEBASEDRESULT lv 
				UNION
				SELECT DISTINCT lt.LABORDERID ,lt.RESULTSTATUS,lt.MODIFIEDON FROM LBRST_TEXTBASEDRESULT lt
				UNION
				SELECT DISTINCT lm.LABORDERID,lm.RESULTSTATUS,lm.MODIFIEDON FROM LBRST_MICROBIOLOGYRESULT lm
				UNION
				SELECT DISTINCT lh.LABORDERID,lh.RESULTSTATUS,lh.MODIFIEDON FROM LBRST_HISTOPATHALOGYRESULT lh
			)
			WHERE RESULTSTATUS = 1 AND MODIFIEDON <= '03-JUL-21'
		),
		Rerun_Orderids AS 
		(
			SELECT * FROM 
			(
				SELECT DISTINCT lv.LABORDERID,lv.RESULTSTATUS,lv.MODIFIEDON FROM LBRST_VALUEBASEDRESULT lv 
				UNION
				SELECT DISTINCT lt.LABORDERID ,lt.RESULTSTATUS,lt.MODIFIEDON FROM LBRST_TEXTBASEDRESULT lt
				UNION
				SELECT DISTINCT lm.LABORDERID,lm.RESULTSTATUS,lm.MODIFIEDON FROM LBRST_MICROBIOLOGYRESULT lm
				UNION
				SELECT DISTINCT lh.LABORDERID,lh.RESULTSTATUS,lh.MODIFIEDON FROM LBRST_HISTOPATHALOGYRESULT lh
			)
			WHERE RESULTSTATUS = 1 AND MODIFIEDON <= '03-JUL-21'
		),
		
		MedicallyVerifieNotIn_Ordered AS 
		(
			SELECT * FROM MedicalVerified_Orderids 
			WHERE LABORDERID NOT IN 
			(
				SELECT LABORDERID FROM Ordered_Orderids
			)
		),
		MedicallyVerifieNotIn_Ordered_Resulted AS 
		(
			SELECT * FROM MedicallyVerifieNotIn_Ordered 
			WHERE LABORDERID NOT IN 
			(
				SELECT LABORDERID FROM Resulted_Orderids
			)
		),
		MedicallyVerifieNotIn_Ordered_Resulted_VerifiedLevel1 AS 
		(
			SELECT * FROM MedicallyVerifieNotIn_Ordered_Resulted 
			WHERE LABORDERID NOT IN 
			(
				SELECT LABORDERID FROM VerifiedLevel1_Orderids
			)
		),
		MedicallyVerifieNotIn_Ordered_Resulted_VerifiedLevel1_Caccelled AS 
		(
			SELECT * FROM MedicallyVerifieNotIn_Ordered_Resulted_VerifiedLevel1 
			WHERE LABORDERID NOT IN 
			(
				SELECT LABORDERID FROM Caccelled_Orderids
			)
		),
		MedicallyVerifieNotIn_Ordered_Resulted_VerifiedLevel1_Caccelled_Rerun AS 
		(
			SELECT * FROM MedicallyVerifieNotIn_Ordered_Resulted_VerifiedLevel1_Caccelled 
			WHERE LABORDERID NOT IN 
			(
				SELECT LABORDERID FROM Rerun_Orderids
			)
		)
		
	
		SELECT DISTINCT la.ORDERMAINREVISIONID,la.ISACTIVE FROM LBUTL_AUDITLOG la WHERE la.ORDERMAINREVISIONID IN 
	(SELECT ll.LABORDERID FROM MedicallyVerifieNotIn_Ordered_Resulted_VerifiedLevel1_Caccelled_Rerun ll)

------------------------------------------------------------------------------------------------------------------------------------	
STEP 2- Execute the following script to update auditlog table with selected data.
------------------------------------------------------------------------------------------------------------------------------------

update LBUTL_AUDITLOG a
set ISACTIVE = 0
where exists (select ISACTIVE from deletingRecordsofAuditLog b
where a.ORDERMAINREVISIONID = b.ORDERMAINREVISIONID );

------------------------------------------------------------------------------------------------------------------------------------	
STEP 3- Delete the temp table which holds selected data
------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE deletingRecordsofAuditLog;

------------------------------------------------------------------------------------------------------------------------------------	
STEP 4- Commit transaction
------------------------------------------------------------------------------------------------------------------------------------



		