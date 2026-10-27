# Interior Design Firm – Project Management System
## Execution Guide: Run Scripts in This Order

---

## 📁 Files in This Project

| # | File | What It Does |
|---|------|-------------|
| 1 | `01_DDL_Create_Tables.sql` | Creates all 12 tables + 12 sequences |
| 2 | `02_DML_Sample_Data.sql` | Inserts realistic sample data |
| 3 | `03_PLSQL_Procedure_Function.sql` | Package + Procedure + Function |
| 4 | `04_Triggers.sql` | All 6 database triggers |
| 5 | `05_SQL_Queries.sql` | 8 analytical SQL queries |
| 6 | `06_Oracle_Forms_Design_Guide.sql` | Forms Builder code reference |
| 7 | `07_Oracle_Reports_Queries.sql` | Report queries for Oracle Reports |
| 8 | `08_EBS_Fusion_Mapping.md` | EBS/Fusion mapping + OTBI design |

---

## ▶️ Step-by-Step Execution in Oracle SQL Developer

### Step 1: Open SQL Developer
- Connect to your Oracle schema (e.g., `INTERIOR_ADMIN`)
- Set SERVEROUTPUT ON: `SET SERVEROUTPUT ON;`

### Step 2: Run in Exact Order
```
1. Run → 01_DDL_Create_Tables.sql      (creates schema)
2. Run → 02_DML_Sample_Data.sql        (inserts data)
3. Run → 03_PLSQL_Procedure_Function.sql (compiles PL/SQL)
4. Run → 04_Triggers.sql               (creates triggers)
5. Run → 05_SQL_Queries.sql            (test all queries)
```

### Step 3: Verify Output
After running each script, check the Messages/DBMS_OUTPUT tab in SQL Developer.

---

## ✅ Quick Verification Queries

```sql
-- Check all tables exist
SELECT table_name FROM user_tables
WHERE table_name IN ('LEADS','CUSTOMERS','DESIGNERS','QUOTATIONS',
  'QUOTATION_REVISIONS','QUOTATION_ITEMS','PROJECTS','MILESTONES',
  'VENDORS','MATERIAL_ORDERS','SITE_UPDATES','MILESTONE_INVOICES')
ORDER BY table_name;

-- Check all sequences exist
SELECT sequence_name FROM user_sequences
WHERE sequence_name LIKE 'SEQ_%'
ORDER BY sequence_name;

-- Check all triggers
SELECT trigger_name, status FROM user_triggers
WHERE table_name IN ('MILESTONES','LEADS','QUOTATIONS','MATERIAL_ORDERS')
ORDER BY trigger_name;

-- Check PL/SQL package
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name IN ('PKG_INTERIOR_DESIGN','FN_GET_PROJECT_MARGIN')
ORDER BY object_type;

-- Count rows in all tables
SELECT 'DESIGNERS'         tbl, COUNT(*) cnt FROM Designers         UNION ALL
SELECT 'LEADS',                 COUNT(*)     FROM Leads              UNION ALL
SELECT 'CUSTOMERS',             COUNT(*)     FROM Customers          UNION ALL
SELECT 'QUOTATIONS',            COUNT(*)     FROM Quotations         UNION ALL
SELECT 'QUOTATION_REVISIONS',   COUNT(*)     FROM Quotation_Revisions UNION ALL
SELECT 'QUOTATION_ITEMS',       COUNT(*)     FROM Quotation_Items    UNION ALL
SELECT 'PROJECTS',              COUNT(*)     FROM Projects           UNION ALL
SELECT 'MILESTONES',            COUNT(*)     FROM Milestones         UNION ALL
SELECT 'VENDORS',               COUNT(*)     FROM Vendors            UNION ALL
SELECT 'MATERIAL_ORDERS',       COUNT(*)     FROM Material_Orders    UNION ALL
SELECT 'SITE_UPDATES',          COUNT(*)     FROM Site_Updates       UNION ALL
SELECT 'MILESTONE_INVOICES',    COUNT(*)     FROM Milestone_Invoices;
```

---

## 🔖 Key IDs for Testing

After running the DML script, use these IDs in your tests:

| Entity | Name | ID |
|--------|------|-----|
| Designer | Rahul Sharma | 3001 |
| Designer | Priya Nair | 3002 |
| Lead | Kiran Patel | 1001 |
| Customer | Kiran Patel | 2001 |
| Quotation | Kiran Patel Home | 4001 |
| Project | Kiran Patel Bandra | 7001 |
| Milestone | Civil Work & Tiling (test trigger) | 8002 |
| Vendor | Kajaria Ceramics | 9001 |
| Project (completed) | Arun Kumar Bangalore | 7004 |

---

## 🧪 Test Scenarios

### Test 1: Procedure – Create Revision
```sql
SET SERVEROUTPUT ON;
DECLARE v_id NUMBER;
BEGIN
  pkg_interior_design.create_quotation_revision(4001, 'Add false ceiling', v_id);
  DBMS_OUTPUT.PUT_LINE('New Revision ID: ' || v_id);
END;
/
```

### Test 2: Function – Get Project Margin
```sql
SET SERVEROUTPUT ON;
SELECT fn_get_project_margin(7004) AS Margin_Pct FROM DUAL;
```

### Test 3: Trigger – Auto Invoice on Milestone Complete
```sql
SET SERVEROUTPUT ON;
UPDATE Milestones SET Status = 'Complete' WHERE Milestone_ID = 8002;
COMMIT;
-- Then verify:
SELECT * FROM Milestone_Invoices WHERE Milestone_ID = 8002;
```

### Test 4: Leads Not Converted in 60 Days
```sql
-- (From 05_SQL_Queries.sql — Query 1)
SELECT Lead_ID, Customer_Name, TRUNC(SYSDATE - Inquiry_Date) Days_Old, Status
FROM Leads
WHERE Status NOT IN ('Converted','Lost')
AND Inquiry_Date < SYSDATE - 60;
```

---

## 📊 For Oracle Forms (06_Oracle_Forms_Design_Guide.sql)
Open **Oracle Forms Builder 12c** and:
1. Create a new `.fmb` file → `PROJ_MASTER_FORM.fmb`
2. Create Data Block → Table: `PROJECTS` → Single record layout
3. Add Tab Canvas with 3 Tab Pages
4. For each tab, add a new Data Block linked to the main project
5. Copy trigger code from `06_Oracle_Forms_Design_Guide.sql`
6. Deploy to WebLogic via Oracle Forms Servlet

## 📈 For Oracle Reports (07_Oracle_Reports_Queries.sql)
Open **Oracle Reports Builder 12c** and:
1. Create `RPT_DESIGNER_PROJECT_STATUS.rdf` — Group Above style
2. Paste REPORT 1 query; set Group Break on `DESIGNER_ID`
3. Create `RPT_REVENUE_BY_PROJECT_TYPE.rdf` — Tabular style
4. Paste REPORT 2 query; add summary totals in Footer
5. Deploy to Reports Server

---

*Wipro Oracle Project — Interior Design Firm Project Management System*
