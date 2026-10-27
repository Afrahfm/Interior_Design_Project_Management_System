-- ============================================================
-- PROJECT  : Interior Design Firm – Quotation & Project Execution System
-- SCRIPT   : 06_Oracle_Forms_Design_Guide.sql
-- PURPOSE  : SQL blocks and logic for Oracle Forms Builder
--            Tab Canvas: Project Master Form
-- ============================================================

/*
====================================================================
  ORACLE FORMS BUILDER — PROJECT MASTER FORM
  
  Form Name  : PROJ_MASTER_FORM.fmb
  Description: Master form with Tab Canvas for project management
  
  LAYOUT OVERVIEW:
  ┌─────────────────────────────────────────────────────────────┐
  │  PROJECT MASTER FORM                                        │
  │  ─────────────────────────────────────────────────────────  │
  │  Project ID : [____]  Project Name : [____________________] │
  │  Customer   : [____]  Designer     : [____________________] │
  │  Type       : [____]  City         : [____________________] │
  │  Start Date : [____]  End Date     : [____________________ ]│
  │  Status     : [____]  Value        : [____________________] │
  │  ─────────────────────────────────────────────────────────  │
  │  [MILESTONES] [MATERIAL ORDERS] [SITE UPDATES]              │
  │  ─────────────────────────────────────────────────────────  │
  │  (Tab content changes based on selected tab)                │
  └─────────────────────────────────────────────────────────────┘
====================================================================
*/

-- ================================================================
-- BLOCK 1: PROJECT (Master Block — single-record)
-- Data Block Query
-- ================================================================

-- Block Name   : BLK_PROJECT
-- Table        : PROJECTS
-- Layout Style : Form
-- Primary Key  : PROJECT_ID (hidden, auto-populated by sequence)

-- When-New-Form-Instance trigger on form:
-- (Paste this in Form-Level WHEN-NEW-FORM-INSTANCE trigger)
/*
DECLARE
  v_next_id NUMBER;
BEGIN
  SELECT SEQ_PROJECT_ID.NEXTVAL INTO v_next_id FROM DUAL;
  :BLK_PROJECT.PROJECT_ID := v_next_id;
END;
*/

-- ================================================================
-- BLOCK 2: MILESTONES Tab (Multi-record — Tab Page 1)
-- ================================================================

-- Block Name   : BLK_MILESTONES
-- Table        : MILESTONES
-- Layout Style : Tabular (spreadsheet view, 8 rows visible)
-- Join         : PROJECT_ID = :BLK_PROJECT.PROJECT_ID

-- Pre-Query trigger (fires when navigating to Milestones tab):
/*
BEGIN
  :BLK_MILESTONES.PROJECT_ID := :BLK_PROJECT.PROJECT_ID;
END;
*/

-- When-Button-Pressed trigger on [Mark Complete] button:
/*
DECLARE
  v_milestone_id NUMBER := :BLK_MILESTONES.MILESTONE_ID;
BEGIN
  IF :BLK_MILESTONES.STATUS = 'Complete' THEN
    MESSAGE('This milestone is already marked Complete.');
    RETURN;
  END IF;
  
  -- Update triggers the auto-invoice (trg_milestone_invoice will fire)
  UPDATE Milestones
  SET    Status = 'Complete'
  WHERE  Milestone_ID = v_milestone_id;
  
  COMMIT;
  MESSAGE('Milestone marked Complete. Invoice auto-generated!');
  EXECUTE_QUERY;   -- Refresh the block
  
EXCEPTION
  WHEN OTHERS THEN
    MESSAGE('Error: ' || SQLERRM);
    ROLLBACK;
END;
*/

-- ================================================================
-- BLOCK 3: MATERIAL ORDERS Tab (Multi-record — Tab Page 2)
-- ================================================================

-- Block Name   : BLK_MATERIAL_ORDERS
-- Table        : MATERIAL_ORDERS
-- Layout Style : Tabular (8 rows visible)
-- Join         : PROJECT_ID = :BLK_PROJECT.PROJECT_ID

-- LOV (List of Values) for Vendor_ID field:
-- LOV Name: LOV_VENDORS
-- Query:
/*
SELECT Vendor_ID, Vendor_Name, Category, Phone
FROM   Vendors
WHERE  Status = 'Active'
ORDER BY Vendor_Name;
*/

-- When-Button-Pressed trigger on [New Order] button:
/*
BEGIN
  :BLK_MATERIAL_ORDERS.PROJECT_ID  := :BLK_PROJECT.PROJECT_ID;
  :BLK_MATERIAL_ORDERS.ORDER_DATE   := SYSDATE;
  :BLK_MATERIAL_ORDERS.DELIVERY_STATUS := 'Ordered';
  NAVIGATE_TO_ITEM('BLK_MATERIAL_ORDERS.VENDOR_ID');
END;
*/

-- When-Validate-Item trigger on TOTAL_PRICE (auto-calculate):
/*
BEGIN
  :BLK_MATERIAL_ORDERS.TOTAL_PRICE :=
    NVL(:BLK_MATERIAL_ORDERS.QUANTITY, 0) *
    NVL(:BLK_MATERIAL_ORDERS.UNIT_PRICE, 0);
END;
*/

-- ================================================================
-- BLOCK 4: SITE UPDATES Tab (Multi-record — Tab Page 3)
-- ================================================================

-- Block Name   : BLK_SITE_UPDATES
-- Table        : SITE_UPDATES
-- Layout Style : Tabular (6 rows visible, larger text areas)
-- Join         : PROJECT_ID = :BLK_PROJECT.PROJECT_ID

-- Default values trigger (When-Create-Record):
/*
BEGIN
  :BLK_SITE_UPDATES.PROJECT_ID  := :BLK_PROJECT.PROJECT_ID;
  :BLK_SITE_UPDATES.UPDATE_DATE := SYSDATE;
  :BLK_SITE_UPDATES.UPDATED_BY  := :GLOBAL.CURRENT_USER;
END;
*/

-- ================================================================
-- HELPER SQL: LOV Queries used in Forms
-- ================================================================

-- LOV for Customer dropdown
SELECT Customer_ID, Full_Name, City, Contact_Number
FROM   Customers
ORDER BY Full_Name;

-- LOV for Designer dropdown
SELECT Designer_ID, Full_Name, Specialization
FROM   Designers
WHERE  Status = 'Active'
ORDER BY Full_Name;

-- LOV for Milestone in Material Order tab
SELECT Milestone_ID, Milestone_Name, Status
FROM   Milestones
WHERE  Project_ID = :BLK_PROJECT.PROJECT_ID
ORDER BY Milestone_Order;

-- LOV for Project Type
SELECT 'Home'   FROM DUAL UNION ALL
SELECT 'Office' FROM DUAL UNION ALL
SELECT 'Villa'  FROM DUAL UNION ALL
SELECT 'Retail' FROM DUAL;

-- ================================================================
-- POST-QUERY trigger for BLK_PROJECT
-- Calculates project margin % to display in a non-database item
-- ================================================================
/*
DECLARE
  v_margin NUMBER;
BEGIN
  v_margin := fn_get_project_margin(:BLK_PROJECT.PROJECT_ID);
  :BLK_PROJECT.MARGIN_PCT := NVL(v_margin, 0);
EXCEPTION
  WHEN OTHERS THEN
    :BLK_PROJECT.MARGIN_PCT := 0;
END;
*/

-- ================================================================
-- FORM VALIDATION: Key-Commit trigger (fires when user saves)
-- ================================================================
/*
BEGIN
  -- Validate contract value is positive
  IF NVL(:BLK_PROJECT.CONTRACT_VALUE, 0) <= 0 THEN
    MESSAGE('Contract Value must be greater than zero!');
    RAISE FORM_TRIGGER_FAILURE;
  END IF;
  
  -- Validate end date is after start date
  IF :BLK_PROJECT.PLANNED_END_DATE < :BLK_PROJECT.START_DATE THEN
    MESSAGE('Planned End Date cannot be before Start Date!');
    RAISE FORM_TRIGGER_FAILURE;
  END IF;
  
  COMMIT_FORM;
  MESSAGE('Project saved successfully!');
END;
*/

-- ================================================================
-- LEAD ENTRY FORM — Quick SQL Reference
-- Form: LEAD_ENTRY_FORM.fmb | Table: LEADS
-- ================================================================

-- Default values for new lead:
/*
:BLK_LEAD.LEAD_ID       := SEQ_LEAD_ID.NEXTVAL;  -- via SELECT FROM DUAL
:BLK_LEAD.INQUIRY_DATE  := SYSDATE;
:BLK_LEAD.STATUS        := 'New';
*/

-- Convert Lead to Customer button:
/*
DECLARE
  v_cust_id NUMBER;
BEGIN
  IF :BLK_LEAD.STATUS <> 'Quotation Sent' THEN
    MESSAGE('Lead must be in Quotation Sent status to convert!');
    RAISE FORM_TRIGGER_FAILURE;
  END IF;
  
  SELECT SEQ_CUSTOMER_ID.NEXTVAL INTO v_cust_id FROM DUAL;
  
  INSERT INTO Customers (
    Customer_ID, Lead_ID, Full_Name, Contact_Number,
    Email, City
  ) VALUES (
    v_cust_id,
    :BLK_LEAD.LEAD_ID,
    :BLK_LEAD.CUSTOMER_NAME,
    :BLK_LEAD.CONTACT_NUMBER,
    :BLK_LEAD.EMAIL,
    :BLK_LEAD.CITY
  );
  
  UPDATE Leads SET Status = 'Converted' WHERE Lead_ID = :BLK_LEAD.LEAD_ID;
  
  COMMIT;
  MESSAGE('Lead converted to Customer ID: ' || v_cust_id);
  
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    MESSAGE('Error converting lead: ' || SQLERRM);
END;
*/

-- ================================================================
-- QUOTATION FORM — Quick SQL Reference
-- Form: QUOTATION_FORM.fmb | Tables: QUOTATIONS + QUOTATION_ITEMS
-- ================================================================

-- Calculate totals when items are entered (Post-Change on Unit_Rate/Qty):
/*
-- Note: Amount is a VIRTUAL column, so read it from DB or compute manually
DECLARE
  v_subtotal NUMBER := 0;
BEGIN
  -- Sum all items
  SELECT NVL(SUM(Quantity * Unit_Rate), 0)
  INTO   v_subtotal
  FROM   Quotation_Items
  WHERE  Revision_ID = :BLK_QUOTATION.CURRENT_REVISION_ID;
  
  :BLK_QUOTATION.SUBTOTAL_AMOUNT := v_subtotal;
  -- trg_quotation_total_calc will auto-compute discount + tax + total
END;
*/

-- Create Revision button:
/*
DECLARE
  v_new_rev NUMBER;
BEGIN
  pkg_interior_design.create_quotation_revision(
    p_quotation_id    => :BLK_QUOTATION.QUOTATION_ID,
    p_reason          => :BLK_QUOTATION.REVISION_REASON,
    p_new_revision_id => v_new_rev
  );
  :BLK_QUOTATION.CURRENT_REVISION_ID := v_new_rev;
  MESSAGE('New Revision Created: ID = ' || v_new_rev);
  EXECUTE_QUERY;
END;
*/

-- ============================================================
-- END OF SCRIPT 06_Oracle_Forms_Design_Guide.sql
-- ============================================================
