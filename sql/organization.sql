CREATE TABLE "BVADMIN"."RMS_ORG_INFORMATION" (
  "ID" NUMBER(38) NOT NULL PRIMARY KEY,
  "TYPE" VARCHAR2(40),
  "NAME" VARCHAR2(50)
);
CREATE SEQUENCE "BVADMIN"."RMS_ORG_INFORMATION_seq" START WITH 1000;

CREATE TABLE "BVADMIN"."RMS_ORG_CODE" (
  "ID" NUMBER(38) NOT NULL PRIMARY KEY,
  "OFFICE_ID" NUMBER(38),
  "DIVISION_ID" NUMBER(38),
  "BRANCH_ID" NUMBER(38),
  "UNIT_ID" NUMBER(38),
  "CODE" VARCHAR2(45),
  "EMPLOYEE_ID" NUMBER(38),
  "ROTATION" NUMBER(1) 
);
CREATE SEQUENCE "BVADMIN"."RMS_ORG_CODE_seq" START WITH 1000;

ALTER TABLE "BVADMIN"."EMPLOYEE" ADD "ROTATION_START" DATE;
ALTER TABLE "BVADMIN"."EMPLOYEE" ADD "ROTATION_END" DATE;