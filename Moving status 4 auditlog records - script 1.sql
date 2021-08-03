--First Create Sequence
CREATE SEQUENCE LBUTL_AUDITLOG_HISTORY_SEQ
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    MAXVALUE 9999999999
    CYCLE
    CACHE 2;
	
--Create AuditLog TABLE

CREATE TABLE "CSI-LAB-WR-LABSRVCS-02"."LBUTL_AUDITLOG_HISTORY" 
   ("AUDITLOGID" NVARCHAR2(450) NOT NULL ENABLE, 
	"ISACTIVE" NUMBER(1,0) NOT NULL ENABLE, 
	"CREATEDBY" NUMBER(10,0) NOT NULL ENABLE, 
	"CREATEDON" TIMESTAMP (7) NOT NULL ENABLE, 
	"MODIFIEDBY" NUMBER(10,0) NOT NULL ENABLE, 
	"MODIFIEDON" TIMESTAMP (7) NOT NULL ENABLE, 
	"APPROVEDBY" NUMBER(10,0) NOT NULL ENABLE, 
	"APPROVEDON" TIMESTAMP (7) NOT NULL ENABLE, 
	"ROWVERSION" TIMESTAMP (7) NOT NULL ENABLE, 
	"HOSPITALID" NUMBER(10,0) NOT NULL ENABLE, 
	"GROUPID" NUMBER(10,0) NOT NULL ENABLE, 
	"LABID" NUMBER(10,0) NOT NULL ENABLE, 
	"TRANSACTIONREVISIONID" NUMBER(10,0) NOT NULL ENABLE, 
	"LABORDERDETAILREVISIONID" NUMBER(10,0) NOT NULL ENABLE, 
	"ACTIONNAME" NVARCHAR2(2000), 
	"ORDERMAINREVISIONID" NUMBER(10,0) NOT NULL ENABLE, 
	"TESTID" NUMBER(10,0) NOT NULL ENABLE, 
	"OLDVALUE" NVARCHAR2(2000), 
	"NEWVALUE" NVARCHAR2(2000), 
	"ACTIONCREATEDTIME" TIMESTAMP (7) NOT NULL ENABLE,
	"AUDITID" NUMBER(10,0) DEFAULT "LB_LABSERVICE"."LBUTL_AUDITLOG_HISTORY_SEQ"."NEXTVAL", 
	"REASON" NVARCHAR2(2000), 
	"ACTIONCREATEDBY" NVARCHAR2(2000), 
	"TESTABBRE" NVARCHAR2(50), 
	"PATIENTID" NUMBER(10,0) DEFAULT 0 NOT NULL ENABLE,
	 CONSTRAINT "LBUTL_AUDITLOG_HISTORY_PK" PRIMARY KEY ("AUDITLOGID"));
	 
--Now insert data using Second script "Moving status 4 auditlog records - script 2"

--Rollback Script
----------------------------
--DROP TABLE LBUTL_AUDITLOG_HISTORY;
--DROP SEQUENCE LBUTL_AUDITLOG_HISTORY_SEQ;