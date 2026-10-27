/*
  Interior Design Firm - Quotation and Project Execution System
  Script 04 - Database Triggers
  Run AFTER Script 02 (DML Sample Data)
*/

SET DEFINE OFF;

-- ================================================================
-- TRIGGER 1 (MANDATORY): trg_milestone_invoice
-- PURPOSE : AFTER UPDATE on Milestones — when Status changes to
--           'Complete', automatically INSERT a row in Milestone_Invoices.
-- ================================================================
CREATE OR REPLACE TRIGGER trg_milestone_invoice
    AFTER UPDATE OF Status ON Milestones
    FOR EACH ROW
    WHEN (NEW.Status = 'Complete' AND OLD.Status <> 'Complete')
DECLARE
    v_contract_value    Projects.Contract_Value%TYPE;
    v_customer_id       Projects.Customer_ID%TYPE;
    v_payment_pct       Milestones.Payment_Percentage%TYPE;
    v_invoice_amount    NUMBER(14,2);
    v_tax_amount        NUMBER(14,2);
    v_total_payable     NUMBER(14,2);
    v_invoice_id        NUMBER;
    v_invoice_number    VARCHAR2(30);
    v_tax_rate          CONSTANT NUMBER := 18;   -- GST 18%
    v_already_exists    NUMBER;
BEGIN
    -- -------------------------------------------------------
    -- Safety check: avoid duplicate invoice for same milestone
    -- -------------------------------------------------------
    SELECT COUNT(*)
    INTO   v_already_exists
    FROM   Milestone_Invoices
    WHERE  Milestone_ID = :NEW.Milestone_ID;

    IF v_already_exists > 0 THEN
        -- Invoice already exists; do not create duplicate
        RETURN;
    END IF;

    -- -------------------------------------------------------
    -- Get project contract value and customer
    -- -------------------------------------------------------
    SELECT p.Contract_Value, p.Customer_ID
    INTO   v_contract_value, v_customer_id
    FROM   Projects p
    WHERE  p.Project_ID = :NEW.Project_ID;

    -- -------------------------------------------------------
    -- Determine payment % for this milestone
    -- (use the milestone's defined percentage; default 10 if NULL)
    -- -------------------------------------------------------
    v_payment_pct    := NVL(:NEW.Payment_Percentage, 10);
    v_invoice_amount := ROUND((v_contract_value * v_payment_pct) / 100, 2);
    v_tax_amount     := ROUND((v_invoice_amount  * v_tax_rate)   / 100, 2);
    v_total_payable  := v_invoice_amount + v_tax_amount;

    -- -------------------------------------------------------
    -- Generate invoice number: INV-<ProjectID>-M<MilestoneOrder>
    -- -------------------------------------------------------
    v_invoice_id     := SEQ_INVOICE_ID.NEXTVAL;
    v_invoice_number := 'INV-' || LPAD(:NEW.Project_ID, 4, '0') ||
                        '-M'   || NVL(TO_CHAR(:NEW.Milestone_Order), TO_CHAR(:NEW.Milestone_ID));

    -- -------------------------------------------------------
    -- Insert invoice
    -- -------------------------------------------------------
    INSERT INTO Milestone_Invoices (
        Invoice_ID,
        Milestone_ID,
        Project_ID,
        Customer_ID,
        Invoice_Number,
        Invoice_Date,
        Due_Date,
        Contract_Value,
        Payment_Percentage,
        Invoice_Amount,
        Tax_Rate,
        Tax_Amount,
        Total_Payable,
        Payment_Status,
        Amount_Received,
        Notes,
        Created_At
    ) VALUES (
        v_invoice_id,
        :NEW.Milestone_ID,
        :NEW.Project_ID,
        v_customer_id,
        v_invoice_number,
        SYSDATE,
        SYSDATE + 15,              -- Payment due within 15 days
        v_contract_value,
        v_payment_pct,
        v_invoice_amount,
        v_tax_rate,
        v_tax_amount,
        v_total_payable,
        'Unpaid',
        0,
        'Auto-generated: ' || :NEW.Milestone_Name || ' completed.',
        SYSTIMESTAMP
    );

    DBMS_OUTPUT.PUT_LINE('TRIGGER FIRED: Invoice created for Milestone "' ||
                         :NEW.Milestone_Name || '" | Amount: INR ' ||
                         TO_CHAR(v_total_payable, '99,99,99,999.99'));

EXCEPTION
    WHEN OTHERS THEN
        -- Log error but do not block the milestone update
        DBMS_OUTPUT.PUT_LINE('TRIGGER ERROR [trg_milestone_invoice]: ' || SQLERRM);
        RAISE;
END trg_milestone_invoice;
/


-- ================================================================
-- TRIGGER 2: trg_milestone_completion_timestamp
-- PURPOSE : Sets Completed_At timestamp and Completion_Pct = 100
--           automatically when a milestone is marked Complete
-- ================================================================
CREATE OR REPLACE TRIGGER trg_milestone_completion_timestamp
    BEFORE UPDATE OF Status ON Milestones
    FOR EACH ROW
    WHEN (NEW.Status = 'Complete' AND OLD.Status <> 'Complete')
BEGIN
    :NEW.Completed_At     := SYSTIMESTAMP;
    :NEW.Actual_End_Date  := SYSDATE;
    :NEW.Completion_Pct   := 100;

    DBMS_OUTPUT.PUT_LINE('TRIGGER: Milestone "' || :NEW.Milestone_Name ||
                         '" marked Complete at ' || TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI'));
END trg_milestone_completion_timestamp;
/


-- ================================================================
-- TRIGGER 3: trg_lead_to_customer_status
-- PURPOSE : When a Lead's Status changes to 'Converted',
--           automatically update the lead's converted date (Remarks)
--           and enforce that a Customer record can only be created
--           for a Converted lead.
-- ================================================================
CREATE OR REPLACE TRIGGER trg_lead_status_update
    BEFORE UPDATE OF Status ON Leads
    FOR EACH ROW
BEGIN
    IF :NEW.Status = 'Converted' AND :OLD.Status <> 'Converted' THEN
        -- Append conversion note to Remarks
        :NEW.Remarks := NVL(:OLD.Remarks, '') ||
                        ' | Converted on: ' || TO_CHAR(SYSDATE, 'DD-Mon-YYYY');

        DBMS_OUTPUT.PUT_LINE('TRIGGER: Lead ' || :NEW.Lead_ID ||
                             ' (' || :NEW.Customer_Name || ') marked as Converted.');

    ELSIF :NEW.Status = 'Lost' AND :OLD.Status NOT IN ('Lost','Converted') THEN
        :NEW.Remarks := NVL(:OLD.Remarks, '') ||
                        ' | Marked Lost on: ' || TO_CHAR(SYSDATE, 'DD-Mon-YYYY');
    END IF;
END trg_lead_status_update;
/


-- ================================================================
-- TRIGGER 4: trg_quotation_total_calc
-- PURPOSE : BEFORE INSERT or UPDATE on Quotations,
--           auto-calculate Discount_Amount, Tax_Amount, Total_Amount
--           from Subtotal_Amount and Discount_Pct
-- ================================================================
CREATE OR REPLACE TRIGGER trg_quotation_total_calc
    BEFORE INSERT OR UPDATE OF Subtotal_Amount, Discount_Pct ON Quotations
    FOR EACH ROW
DECLARE
    v_gst_rate  CONSTANT NUMBER := 18;
BEGIN
    :NEW.Discount_Amount := ROUND((:NEW.Subtotal_Amount * NVL(:NEW.Discount_Pct, 0)) / 100, 2);
    :NEW.Tax_Amount      := ROUND(((:NEW.Subtotal_Amount - :NEW.Discount_Amount) * v_gst_rate) / 100, 2);
    :NEW.Total_Amount    := (:NEW.Subtotal_Amount - :NEW.Discount_Amount) + :NEW.Tax_Amount;
END trg_quotation_total_calc;
/


-- ================================================================
-- TRIGGER 5: trg_material_order_total
-- PURPOSE : BEFORE INSERT or UPDATE on Material_Orders,
--           auto-calculate Total_Price = Quantity × Unit_Price
-- ================================================================
CREATE OR REPLACE TRIGGER trg_material_order_total
    BEFORE INSERT OR UPDATE OF Quantity, Unit_Price ON Material_Orders
    FOR EACH ROW
BEGIN
    IF :NEW.Quantity IS NOT NULL AND :NEW.Unit_Price IS NOT NULL THEN
        :NEW.Total_Price := ROUND(:NEW.Quantity * :NEW.Unit_Price, 2);
    END IF;
END trg_material_order_total;
/


-- ================================================================
-- TRIGGER 6: trg_project_status_on_last_milestone
-- PURPOSE : When ALL milestones of a project are 'Complete',
--           automatically update Projects.Status to 'Completed'
-- ================================================================
CREATE OR REPLACE TRIGGER trg_project_auto_complete
FOR UPDATE OF Status ON Milestones
COMPOUND TRIGGER

    TYPE t_project_ids IS TABLE OF Projects.Project_ID%TYPE;
    g_project_ids t_project_ids := t_project_ids();

    AFTER EACH ROW IS
    BEGIN
        IF :NEW.Status = 'Complete' THEN
            g_project_ids.EXTEND;
            g_project_ids(g_project_ids.LAST) := :NEW.Project_ID;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_incomplete_count NUMBER;
    BEGIN
        FOR i IN 1 .. g_project_ids.COUNT LOOP
            SELECT COUNT(*)
            INTO   v_incomplete_count
            FROM   Milestones
            WHERE  Project_ID = g_project_ids(i)
              AND  Status <> 'Complete';

            IF v_incomplete_count = 0 THEN
                UPDATE Projects
                SET    Status          = 'Completed',
                       Actual_End_Date = SYSDATE
                WHERE  Project_ID = g_project_ids(i)
                  AND  Status <> 'Completed';

                DBMS_OUTPUT.PUT_LINE('TRIGGER: Project ' || g_project_ids(i) ||
                                     ' automatically marked COMPLETED — all milestones done!');
            END IF;
        END LOOP;
        g_project_ids.DELETE;
    END AFTER STATEMENT;

END trg_project_auto_complete;
/


-- ================================================================
-- TEST: Trigger demonstration
-- Fire trg_milestone_invoice by marking a milestone Complete
-- ================================================================
SET SERVEROUTPUT ON;

-- Check current state of a milestone before update
SELECT Milestone_ID, Milestone_Name, Status, Completion_Pct, Completed_At
FROM   Milestones
WHERE  Project_ID = 7001
ORDER  BY Milestone_Order;

-- Mark Milestone 8002 (Civil Work - Kiran Patel Home) as Complete
-- This should:
--   (a) Fire trg_milestone_completion_timestamp → set Completed_At, Completion_Pct=100
--   (b) Fire trg_milestone_invoice → INSERT into Milestone_Invoices
--   (c) Fire trg_project_auto_complete → check if project is done
UPDATE Milestones
SET    Status = 'Complete'
WHERE  Milestone_ID = 8002;

COMMIT;

-- Verify invoice was auto-created
SELECT Invoice_ID, Invoice_Number, Invoice_Amount, Tax_Amount, Total_Payable, Payment_Status
FROM   Milestone_Invoices
WHERE  Milestone_ID = 8002;

-- Verify milestone timestamps
SELECT Milestone_ID, Milestone_Name, Status, Completion_Pct,
       TO_CHAR(Completed_At, 'DD-Mon-YYYY HH24:MI:SS') AS Completed_At
FROM   Milestones
WHERE  Milestone_ID = 8002;

-- ============================================================
-- END OF SCRIPT 04_Triggers.sql
-- ============================================================
