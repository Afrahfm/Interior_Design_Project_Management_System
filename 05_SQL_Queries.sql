/*
  Interior Design Firm - Quotation and Project Execution System
  Script 05 - SQL Analytical Queries
  Run AFTER Script 02 (DML Sample Data)
*/

SET DEFINE OFF;

-- ================================================================
-- QUERY 1 (MANDATORY): Leads not converted in 60 days
-- Business Use: Sales follow-up, mark as lost, reassign designer
-- ================================================================
PROMPT ============================================================
PROMPT QUERY 1: Leads Not Converted in Last 60 Days
PROMPT ============================================================

SELECT
    l.Lead_ID,
    l.Customer_Name,
    l.Contact_Number,
    l.Email,
    l.City,
    l.Project_Type,
    l.Budget_Min,
    l.Budget_Max,
    TO_CHAR(l.Inquiry_Date, 'DD-Mon-YYYY')         AS Inquiry_Date,
    TRUNC(SYSDATE - l.Inquiry_Date)                 AS Days_Since_Inquiry,
    l.Status                                        AS Current_Status,
    l.Source,
    d.Full_Name                                     AS Assigned_Designer,
    l.Remarks
FROM
    Leads     l
    LEFT JOIN Designers d ON l.Designer_ID = d.Designer_ID
WHERE
    l.Status NOT IN ('Converted', 'Lost')          -- Open leads only
    AND l.Inquiry_Date < SYSDATE - 60              -- Older than 60 days
ORDER BY
    Days_Since_Inquiry DESC;                        -- Oldest first


-- ================================================================
-- QUERY 2 (MANDATORY): Projects delayed beyond planned milestone date
-- Business Use: Project manager escalation dashboard
-- ================================================================
PROMPT ============================================================
PROMPT QUERY 2: Projects With Delayed Milestones
PROMPT ============================================================

SELECT
    p.Project_ID,
    p.Project_Name,
    p.Project_Type,
    p.City,
    d.Full_Name                                      AS Designer,
    c.Full_Name                                      AS Customer,
    m.Milestone_ID,
    m.Milestone_Name,
    m.Milestone_Order,
    TO_CHAR(m.Planned_End_Date, 'DD-Mon-YYYY')       AS Planned_Completion,
    TO_CHAR(SYSDATE, 'DD-Mon-YYYY')                  AS Today,
    TRUNC(SYSDATE - m.Planned_End_Date)              AS Days_Overdue,
    m.Status                                         AS Milestone_Status,
    m.Completion_Pct                                 AS Pct_Complete,
    m.Notes                                          AS Remarks
FROM
    Projects    p
    JOIN Milestones  m ON p.Project_ID   = m.Project_ID
    JOIN Designers   d ON p.Designer_ID  = d.Designer_ID
    JOIN Customers   c ON p.Customer_ID  = c.Customer_ID
WHERE
    m.Status   NOT IN ('Complete', 'On Hold')       -- Active milestones only
    AND p.Status NOT IN ('Completed', 'Cancelled')  -- Active projects only
    AND m.Planned_End_Date < SYSDATE                -- Past due date
ORDER BY
    Days_Overdue DESC,
    p.Project_ID,
    m.Milestone_Order;


-- ================================================================
-- QUERY 3: Material orders that are delayed (Expected vs Actual)
-- Business Use: Vendor performance tracking
-- ================================================================
PROMPT ============================================================
PROMPT QUERY 3: Delayed Material Orders by Vendor
PROMPT ============================================================

SELECT
    mo.Order_ID,
    p.Project_Name,
    v.Vendor_Name,
    v.Category                                       AS Vendor_Category,
    mo.Material_Name,
    mo.Quantity || ' ' || mo.Unit                    AS Qty_Unit,
    TO_CHAR(mo.Order_Date,          'DD-Mon-YYYY')   AS Order_Date,
    TO_CHAR(mo.Expected_Delivery,   'DD-Mon-YYYY')   AS Expected_Delivery,
    TO_CHAR(mo.Actual_Delivery,     'DD-Mon-YYYY')   AS Actual_Delivery,
    CASE
        WHEN mo.Actual_Delivery IS NOT NULL
             THEN TRUNC(mo.Actual_Delivery - mo.Expected_Delivery)
        ELSE TRUNC(SYSDATE - mo.Expected_Delivery)
    END                                              AS Days_Delayed,
    mo.Delivery_Status,
    mo.Total_Price,
    mo.Remarks
FROM
    Material_Orders mo
    JOIN Projects p ON mo.Project_ID = p.Project_ID
    JOIN Vendors  v ON mo.Vendor_ID  = v.Vendor_ID
WHERE
    mo.Delivery_Status IN ('Delayed', 'Ordered', 'In Transit')
    AND mo.Expected_Delivery < SYSDATE
ORDER BY
    Days_Delayed DESC;


-- ================================================================
-- QUERY 4: Designer-wise project summary (for Reports)
-- Business Use: Manager review – who's handling what
-- ================================================================
PROMPT ============================================================
PROMPT QUERY 4: Designer-wise Project Status Summary
PROMPT ============================================================

SELECT
    d.Designer_ID,
    d.Full_Name                                      AS Designer_Name,
    d.Specialization,
    COUNT(p.Project_ID)                              AS Total_Projects,
    SUM(CASE WHEN p.Status = 'In Progress'  THEN 1 ELSE 0 END) AS Active,
    SUM(CASE WHEN p.Status = 'Completed'    THEN 1 ELSE 0 END) AS Completed,
    SUM(CASE WHEN p.Status = 'On Hold'      THEN 1 ELSE 0 END) AS On_Hold,
    SUM(p.Contract_Value)                            AS Total_Contract_Value,
    ROUND(AVG(
        CASE WHEN p.Status = 'Completed'
             THEN p.Actual_End_Date - p.Start_Date
        END
    ))                                               AS Avg_Completion_Days
FROM
    Designers d
    LEFT JOIN Projects p ON d.Designer_ID = p.Designer_ID
GROUP BY
    d.Designer_ID, d.Full_Name, d.Specialization
ORDER BY
    Total_Projects DESC;


-- ================================================================
-- QUERY 5: Revenue summary by project type
-- Business Use: Financial / business performance report
-- ================================================================
PROMPT ============================================================
PROMPT QUERY 5: Revenue Summary by Project Type
PROMPT ============================================================

SELECT
    p.Project_Type,
    COUNT(DISTINCT p.Project_ID)                     AS Project_Count,
    SUM(p.Contract_Value)                            AS Total_Contract_Value,
    SUM(mi.Invoice_Amount)                           AS Total_Billed,
    SUM(mi.Amount_Received)                          AS Total_Collected,
    SUM(mi.Total_Payable - mi.Amount_Received)       AS Total_Outstanding,
    ROUND(
        SUM(mi.Amount_Received) / NULLIF(SUM(p.Contract_Value), 0) * 100,
        1
    )                                                AS Collection_Pct,
    ROUND(AVG(fn_get_project_margin(p.Project_ID)),2) AS Avg_Margin_Pct
FROM
    Projects          p
    LEFT JOIN Milestone_Invoices mi ON p.Project_ID = mi.Project_ID
GROUP BY
    p.Project_Type
ORDER BY
    Total_Contract_Value DESC;


-- ================================================================
-- QUERY 6: Site update log — issues observed (open issues)
-- Business Use: Site manager dashboard – flag problems
-- ================================================================
PROMPT ============================================================
PROMPT QUERY 6: Open Site Issues Across All Projects
PROMPT ============================================================

SELECT
    su.Site_Update_ID,
    p.Project_Name,
    d.Full_Name                                      AS Designer,
    TO_CHAR(su.Update_Date, 'DD-Mon-YYYY')           AS Update_Date,
    su.Updated_By,
    su.Work_Done,
    su.Issues_Observed,
    m.Milestone_Name                                 AS Current_Milestone,
    su.Next_Day_Plan
FROM
    Site_Updates su
    JOIN Projects   p  ON su.Project_ID  = p.Project_ID
    JOIN Designers  d  ON p.Designer_ID  = d.Designer_ID
    LEFT JOIN Milestones m ON su.Milestone_ID = m.Milestone_ID
WHERE
    su.Issues_Observed IS NOT NULL
    AND p.Status NOT IN ('Completed', 'Cancelled')
ORDER BY
    su.Update_Date DESC;


-- ================================================================
-- QUERY 7: Milestone billing status — how much remains to be billed
-- Business Use: Finance team – pending invoice creation
-- ================================================================
PROMPT ============================================================
PROMPT QUERY 7: Milestone Billing Status per Project
PROMPT ============================================================

SELECT
    p.Project_ID,
    p.Project_Name,
    p.Contract_Value,
    COUNT(m.Milestone_ID)                            AS Total_Milestones,
    SUM(CASE WHEN m.Status = 'Complete' THEN 1 ELSE 0 END) AS Completed_Milestones,
    SUM(CASE WHEN mi.Invoice_ID IS NOT NULL THEN mi.Total_Payable ELSE 0 END) AS Total_Invoiced,
    SUM(CASE WHEN mi.Payment_Status = 'Paid' THEN mi.Amount_Received ELSE 0 END) AS Total_Received,
    p.Contract_Value - 
        SUM(CASE WHEN mi.Invoice_ID IS NOT NULL THEN mi.Invoice_Amount ELSE 0 END) AS Balance_To_Bill,
    p.Status                                         AS Project_Status
FROM
    Projects              p
    JOIN Milestones        m  ON p.Project_ID  = m.Project_ID
    LEFT JOIN Milestone_Invoices mi ON m.Milestone_ID = mi.Milestone_ID
GROUP BY
    p.Project_ID, p.Project_Name, p.Contract_Value, p.Status
ORDER BY
    Balance_To_Bill DESC;


-- ================================================================
-- QUERY 8: Top vendors by delivery performance
-- Business Use: Preferred vendor list for procurement
-- ================================================================
PROMPT ============================================================
PROMPT QUERY 8: Vendor Delivery Performance Ranking
PROMPT ============================================================

SELECT
    v.Vendor_ID,
    v.Vendor_Name,
    v.Category,
    v.Rating                                         AS Firm_Rating,
    COUNT(mo.Order_ID)                               AS Total_Orders,
    SUM(mo.Total_Price)                              AS Total_Order_Value,
    SUM(CASE WHEN mo.Delivery_Status = 'Delivered' THEN 1 ELSE 0 END) AS On_Time_Delivered,
    SUM(CASE WHEN mo.Delivery_Status = 'Delayed'   THEN 1 ELSE 0 END) AS Delayed_Orders,
    ROUND(
        SUM(CASE WHEN mo.Delivery_Status = 'Delivered' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(mo.Order_ID), 0) * 100,
        1
    )                                                AS Delivery_Success_Pct
FROM
    Vendors         v
    LEFT JOIN Material_Orders mo ON v.Vendor_ID = mo.Vendor_ID
GROUP BY
    v.Vendor_ID, v.Vendor_Name, v.Category, v.Rating
HAVING
    COUNT(mo.Order_ID) > 0
ORDER BY
    Delivery_Success_Pct DESC, v.Rating DESC;

-- ============================================================
-- END OF SCRIPT 05_SQL_Queries.sql
-- ============================================================
