/*
  Interior Design Firm - Quotation and Project Execution System
  Script 03 - PLSQL Procedure and Function
  Run AFTER Script 02 (DML Sample Data)
*/

SET DEFINE OFF;

-- ================================================================
-- PACKAGE SPECIFICATION
-- Groups procedure + function together (best practice)
-- ================================================================
CREATE OR REPLACE PACKAGE pkg_interior_design AS

    -- Procedure: Create a new quotation revision by copying items
    PROCEDURE create_quotation_revision(
        p_quotation_id      IN  NUMBER,
        p_reason            IN  VARCHAR2  DEFAULT 'Client requested changes',
        p_new_revision_id   OUT NUMBER
    );

    -- Function: Return project margin percentage
    FUNCTION get_project_margin(
        p_project_id IN NUMBER
    ) RETURN NUMBER;

END pkg_interior_design;
/

-- ================================================================
-- PACKAGE BODY
-- ================================================================
CREATE OR REPLACE PACKAGE BODY pkg_interior_design AS

    -- ============================================================
    -- PROCEDURE: create_quotation_revision
    -- PURPOSE  : Copies all items from the current (latest) revision
    --            of a quotation into a new revision and increments
    --            the version number. Updates the quotation's status
    --            to 'Under Revision'.
    --
    -- HOW IT WORKS:
    --   1. Finds the latest approved/active revision for the quotation
    --   2. Marks it as 'Superseded'
    --   3. Creates a new revision row (version +1)
    --   4. Copies all line items from the old revision to new one
    --   5. Updates the quotation header Current_Version
    --   6. Returns the new Revision_ID via OUT parameter
    -- ============================================================
    PROCEDURE create_quotation_revision(
        p_quotation_id      IN  NUMBER,
        p_reason            IN  VARCHAR2  DEFAULT 'Client requested changes',
        p_new_revision_id   OUT NUMBER
    ) AS

        v_current_version   NUMBER(3);
        v_new_version       NUMBER(3);
        v_latest_rev_id     NUMBER;
        v_designer_id       NUMBER;
        v_subtotal          NUMBER(14,2);
        v_discount_pct      NUMBER(5,2);
        v_total             NUMBER(14,2);
        v_item_count        NUMBER;

    BEGIN
        -- -------------------------------------------------------
        -- STEP 1: Validate that the quotation exists and is eligible
        -- -------------------------------------------------------
        BEGIN
            SELECT Current_Version, Designer_ID
            INTO   v_current_version, v_designer_id
            FROM   Quotations
            WHERE  Quotation_ID = p_quotation_id
              AND  Status IN ('Sent','Approved','Under Revision');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001,
                    'Quotation ID ' || p_quotation_id ||
                    ' not found or not in a revisable state (must be Sent/Approved/Under Revision).');
        END;

        -- -------------------------------------------------------
        -- STEP 2: Get the latest revision details
        -- -------------------------------------------------------
        SELECT Revision_ID, Subtotal_Amount, Discount_Pct, Total_Amount
        INTO   v_latest_rev_id, v_subtotal, v_discount_pct, v_total
        FROM   Quotation_Revisions
        WHERE  Quotation_ID   = p_quotation_id
          AND  Version_Number = v_current_version;

        -- -------------------------------------------------------
        -- STEP 3: Mark the current revision as Superseded
        -- -------------------------------------------------------
        UPDATE Quotation_Revisions
        SET    Status = 'Superseded'
        WHERE  Revision_ID = v_latest_rev_id;

        -- -------------------------------------------------------
        -- STEP 4: Create new revision (version +1)
        -- -------------------------------------------------------
        v_new_version    := v_current_version + 1;
        p_new_revision_id := SEQ_REVISION_ID.NEXTVAL;

        INSERT INTO Quotation_Revisions (
            Revision_ID, Quotation_ID, Version_Number,
            Revised_By, Revision_Date, Reason_For_Revision,
            Subtotal_Amount, Discount_Pct, Total_Amount, Status
        ) VALUES (
            p_new_revision_id, p_quotation_id, v_new_version,
            v_designer_id, SYSDATE, p_reason,
            v_subtotal, v_discount_pct, v_total, 'Draft'
        );

        -- -------------------------------------------------------
        -- STEP 5: Copy all line items from old revision to new
        -- -------------------------------------------------------
        SELECT COUNT(*) INTO v_item_count
        FROM   Quotation_Items
        WHERE  Revision_ID = v_latest_rev_id;

        IF v_item_count > 0 THEN
            INSERT INTO Quotation_Items (
                Item_ID, Revision_ID, Quotation_ID,
                Item_Category, Item_Description,
                Unit, Quantity, Unit_Rate, Remarks
            )
            SELECT  SEQ_ITEM_ID.NEXTVAL,
                    p_new_revision_id,
                    Quotation_ID,
                    Item_Category,
                    Item_Description,
                    Unit,
                    Quantity,
                    Unit_Rate,
                    Remarks
            FROM    Quotation_Items
            WHERE   Revision_ID = v_latest_rev_id;
        END IF;

        -- -------------------------------------------------------
        -- STEP 6: Update quotation header
        -- -------------------------------------------------------
        UPDATE Quotations
        SET    Current_Version = v_new_version,
               Status          = 'Under Revision'
        WHERE  Quotation_ID = p_quotation_id;

        -- -------------------------------------------------------
        -- STEP 7: Commit and log success
        -- -------------------------------------------------------
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('===== REVISION CREATED SUCCESSFULLY =====');
        DBMS_OUTPUT.PUT_LINE('Quotation ID   : ' || p_quotation_id);
        DBMS_OUTPUT.PUT_LINE('Old Version    : ' || v_current_version || '  (Superseded)');
        DBMS_OUTPUT.PUT_LINE('New Version    : ' || v_new_version);
        DBMS_OUTPUT.PUT_LINE('New Revision ID: ' || p_new_revision_id);
        DBMS_OUTPUT.PUT_LINE('Items Copied   : ' || v_item_count);
        DBMS_OUTPUT.PUT_LINE('Reason         : ' || p_reason);
        DBMS_OUTPUT.PUT_LINE('==========================================');

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR in create_quotation_revision: ' || SQLERRM);
            RAISE;
    END create_quotation_revision;


    -- ============================================================
    -- FUNCTION: get_project_margin
    -- PURPOSE  : Calculates and returns the gross margin % for a
    --            project using the formula:
    --
    --   Margin % = ((Total Revenue Billed - Total Material Cost) /
    --               Total Revenue Billed) × 100
    --
    -- INPUTS : p_project_id - the Project_ID
    -- RETURNS: Margin percentage (NUMBER); NULL if no revenue
    -- ============================================================
    FUNCTION get_project_margin(
        p_project_id IN NUMBER
    ) RETURN NUMBER AS

        v_total_revenue     NUMBER(14,2) := 0;
        v_total_material    NUMBER(14,2) := 0;
        v_margin_pct        NUMBER(8,2);
        v_project_exists    NUMBER;

    BEGIN
        -- -------------------------------------------------------
        -- STEP 1: Validate project exists
        -- -------------------------------------------------------
        SELECT COUNT(*) INTO v_project_exists
        FROM   Projects
        WHERE  Project_ID = p_project_id;

        IF v_project_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Project ID ' || p_project_id || ' does not exist.');
        END IF;

        -- -------------------------------------------------------
        -- STEP 2: Total Revenue = sum of paid invoice amounts
        --         (Invoice_Amount = base before tax, which is
        --          % of contract value for each milestone)
        -- -------------------------------------------------------
        SELECT NVL(SUM(Invoice_Amount), 0)
        INTO   v_total_revenue
        FROM   Milestone_Invoices
        WHERE  Project_ID      = p_project_id
          AND  Payment_Status  IN ('Paid','Partially Paid');

        -- -------------------------------------------------------
        -- STEP 3: Total Material Cost = sum of material orders
        --         that have been delivered
        -- -------------------------------------------------------
        SELECT NVL(SUM(Total_Price), 0)
        INTO   v_total_material
        FROM   Material_Orders
        WHERE  Project_ID       = p_project_id
          AND  Delivery_Status  = 'Delivered';

        -- -------------------------------------------------------
        -- STEP 4: Calculate margin
        -- -------------------------------------------------------
        IF v_total_revenue = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No revenue recorded yet for Project ' || p_project_id);
            RETURN NULL;
        END IF;

        v_margin_pct := ROUND(
            ((v_total_revenue - v_total_material) / v_total_revenue) * 100,
            2
        );

        -- -------------------------------------------------------
        -- STEP 5: Display results
        -- -------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('===== PROJECT MARGIN REPORT =====');
        DBMS_OUTPUT.PUT_LINE('Project ID      : ' || p_project_id);
        DBMS_OUTPUT.PUT_LINE('Total Revenue   : INR ' || TO_CHAR(v_total_revenue, '99,99,99,999.99'));
        DBMS_OUTPUT.PUT_LINE('Material Cost   : INR ' || TO_CHAR(v_total_material, '99,99,99,999.99'));
        DBMS_OUTPUT.PUT_LINE('Gross Margin %  : ' || v_margin_pct || '%');
        DBMS_OUTPUT.PUT_LINE('=================================');

        RETURN v_margin_pct;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR in get_project_margin: ' || SQLERRM);
            RAISE;
    END get_project_margin;

END pkg_interior_design;
/

-- ================================================================
-- TEST BLOCK 1: Test create_quotation_revision procedure
-- Run AFTER 02_DML_Sample_Data.sql
-- ================================================================
SET SERVEROUTPUT ON;

DECLARE
    v_new_rev_id  NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TEST: create_quotation_revision ---');

    -- Create a new revision for Quotation 4001 (Kiran Patel Home)
    pkg_interior_design.create_quotation_revision(
        p_quotation_id    => 4001,
        p_reason          => 'Client wants to add false ceiling in master bedroom',
        p_new_revision_id => v_new_rev_id
    );

    DBMS_OUTPUT.PUT_LINE('Returned New Revision ID: ' || v_new_rev_id);

    -- Verify
    FOR r IN (
        SELECT Revision_ID, Version_Number, Status, Reason_For_Revision
        FROM   Quotation_Revisions
        WHERE  Quotation_ID = 4001
        ORDER  BY Version_Number
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('  Rev ' || r.Version_Number || ': ID=' || r.Revision_ID ||
                             ' | ' || r.Status || ' | ' || r.Reason_For_Revision);
    END LOOP;
END;
/

-- ================================================================
-- TEST BLOCK 2: Test get_project_margin function
-- ================================================================
DECLARE
    v_margin  NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TEST: get_project_margin ---');

    -- Test for completed project 7004 (Arun Kumar Bangalore)
    v_margin := pkg_interior_design.get_project_margin(7004);
    DBMS_OUTPUT.PUT_LINE('Margin for Project 7004: ' || v_margin || '%');

    -- Test for in-progress project 7001 (Kiran Patel Mumbai)
    v_margin := pkg_interior_design.get_project_margin(7001);
    DBMS_OUTPUT.PUT_LINE('Margin for Project 7001: ' || NVL(TO_CHAR(v_margin), 'No revenue yet') || '%');
END;
/

-- ================================================================
-- STANDALONE FUNCTION (alternative to package approach)
-- Useful if your Oracle Forms calls it directly
-- ================================================================
CREATE OR REPLACE FUNCTION fn_get_project_margin(p_project_id IN NUMBER)
RETURN NUMBER AS
    v_revenue   NUMBER(14,2);
    v_material  NUMBER(14,2);
BEGIN
    SELECT NVL(SUM(Invoice_Amount), 0) INTO v_revenue
    FROM   Milestone_Invoices
    WHERE  Project_ID = p_project_id
      AND  Payment_Status IN ('Paid', 'Partially Paid');

    SELECT NVL(SUM(Total_Price), 0) INTO v_material
    FROM   Material_Orders
    WHERE  Project_ID = p_project_id
      AND  Delivery_Status = 'Delivered';

    IF v_revenue = 0 THEN RETURN 0; END IF;

    RETURN ROUND(((v_revenue - v_material) / v_revenue) * 100, 2);
END fn_get_project_margin;
/

-- Quick test of standalone function
SELECT
    p.Project_ID,
    p.Project_Name,
    p.Project_Type,
    p.Contract_Value,
    fn_get_project_margin(p.Project_ID) AS Margin_Pct
FROM Projects p
ORDER BY p.Project_ID;

-- ============================================================
-- END OF SCRIPT 03_PLSQL_Procedure_Function.sql
-- ============================================================
