-- ============================================================
-- PROJECT  : Interior Design Firm – Quotation & Project Execution System
-- SCRIPT   : 07_Oracle_Reports_Queries.sql
-- PURPOSE  : SQL queries powering the two mandatory Oracle Reports
-- ============================================================

/*
====================================================================
REPORT 1: PROJECT STATUS REPORT — GROUPED BY DESIGNER
  Report Name : RPT_DESIGNER_PROJECT_STATUS.rdf
  Report Type : Group-Above / Tabular
  Grouping    : By Designer (Group-Above on Designer_ID)
====================================================================

  LAYOUT PREVIEW:
  ─────────────────────────────────────────────────────────────────
  Designer: Rahul Sharma           Specialization: Modern Minimalist
  ─────────────────────────────────────────────────────────────────
  Proj ID  Project Name          Type    City       Status     Value
  7001     Kiran Patel Bandra    Home    Mumbai     In Progress 13.45L
  7005     Nisha Iyer Kochi Villa Villa  Kochi      In Progress 1.13Cr
  ─────────────────────────────────────────────────────────────────
  Designer: Priya Nair             Specialization: Contemporary
  ─────────────────────────────────────────────────────────────────
  7002     Meera Rao IT Office   Office  Pune       In Progress 43.50L
  ─────────────────────────────────────────────────────────────────
  SUMMARY: Total Projects: 5 | On Track: 3 | Delayed: 2
====================================================================
*/

-- ================================================================
-- REPORT 1 — MAIN QUERY (Paste as Report Query in Oracle Reports)
-- ================================================================
SELECT
    -- DESIGNER (Group-Above level)
    d.Designer_ID,
    d.Full_Name                                         AS Designer_Name,
    d.Specialization,
    d.Experience_Yrs,
    d.Phone                                             AS Designer_Phone,

    -- PROJECT (Detail level)
    p.Project_ID,
    p.Project_Name,
    p.Project_Type,
    p.City,
    p.Site_Address,
    TO_CHAR(p.Start_Date,        'DD-Mon-YYYY')         AS Start_Date,
    TO_CHAR(p.Planned_End_Date,  'DD-Mon-YYYY')         AS Planned_End_Date,
    TO_CHAR(p.Actual_End_Date,   'DD-Mon-YYYY')         AS Actual_End_Date,
    p.Contract_Value,
    p.Status                                            AS Project_Status,

    -- MILESTONE SUMMARY (sub-select for completeness %)
    (SELECT COUNT(*) FROM Milestones m WHERE m.Project_ID = p.Project_ID)
                                                        AS Total_Milestones,
    (SELECT COUNT(*) FROM Milestones m
     WHERE m.Project_ID = p.Project_ID AND m.Status = 'Complete')
                                                        AS Completed_Milestones,
    ROUND(
        (SELECT COUNT(*) FROM Milestones m
         WHERE m.Project_ID = p.Project_ID AND m.Status = 'Complete')
        / NULLIF(
          (SELECT COUNT(*) FROM Milestones m WHERE m.Project_ID = p.Project_ID), 0
        ) * 100, 0
    )                                                   AS Overall_Pct_Complete,

    -- DELAY FLAG
    CASE
        WHEN p.Status IN ('Completed','Cancelled') THEN 'N/A'
        WHEN EXISTS (
            SELECT 1 FROM Milestones m
            WHERE  m.Project_ID     = p.Project_ID
              AND  m.Status        NOT IN ('Complete','On Hold')
              AND  m.Planned_End_Date < SYSDATE
        ) THEN 'DELAYED'
        ELSE 'On Track'
    END                                                 AS Delay_Flag,

    -- FINANCIAL
    NVL((SELECT SUM(mi.Amount_Received)
         FROM Milestone_Invoices mi
         WHERE mi.Project_ID = p.Project_ID), 0)        AS Amount_Collected,
    fn_get_project_margin(p.Project_ID)                 AS Margin_Pct,

    -- CUSTOMER
    c.Full_Name                                         AS Customer_Name,
    c.Contact_Number                                    AS Customer_Phone

FROM
    Designers   d
    JOIN Projects   p ON d.Designer_ID = p.Designer_ID
    JOIN Customers  c ON p.Customer_ID = c.Customer_ID
WHERE
    p.Status NOT IN ('Cancelled')
ORDER BY
    d.Full_Name,          -- Group break
    p.Project_ID;         -- Detail order


-- ================================================================
-- REPORT 1 — SUMMARY FOOTER QUERY
-- (Used in Oracle Reports Summary section / Footer band)
-- ================================================================
SELECT
    COUNT(p.Project_ID)                                 AS Grand_Total_Projects,
    SUM(CASE WHEN p.Status = 'In Progress'  THEN 1 ELSE 0 END) AS Active_Projects,
    SUM(CASE WHEN p.Status = 'Completed'    THEN 1 ELSE 0 END) AS Completed_Projects,
    SUM(CASE WHEN p.Status = 'On Hold'      THEN 1 ELSE 0 END) AS On_Hold_Projects,
    SUM(p.Contract_Value)                               AS Total_Portfolio_Value,
    ROUND(AVG(fn_get_project_margin(p.Project_ID)), 2)  AS Avg_Margin_Pct,
    -- Count of delayed projects
    (SELECT COUNT(DISTINCT m.Project_ID)
     FROM   Milestones m
     JOIN   Projects   px ON m.Project_ID = px.Project_ID
     WHERE  m.Status NOT IN ('Complete','On Hold')
       AND  px.Status NOT IN ('Completed','Cancelled')
       AND  m.Planned_End_Date < SYSDATE)               AS Delayed_Projects_Count
FROM
    Projects p
WHERE
    p.Status NOT IN ('Cancelled');


/*
====================================================================
REPORT 2: REVENUE SUMMARY BY PROJECT TYPE
  Report Name : RPT_REVENUE_BY_PROJECT_TYPE.rdf
  Report Type : Tabular with Summary
  Grouping    : By Project_Type
====================================================================

  LAYOUT PREVIEW:
  ─────────────────────────────────────────────────────────────────
  REVENUE SUMMARY BY PROJECT TYPE
  Generated: 27-Oct-2026
  ─────────────────────────────────────────────────────────────────
  Type   Projects  Contract Val  Invoiced   Collected  Outstanding  Margin%
  Home       2     ₹32.33L      ₹9.45L     ₹9.45L     ₹0.00L       78.5%
  Office     1     ₹43.50L      ₹15.40L    ₹5.67L     ₹9.73L       65.2%
  Villa      2     ₹1.46Cr      ₹31.86L    ₹21.86L    ₹10.00L      72.1%
  ─────────────────────────────────────────────────────────────────
  TOTAL      5     ₹2.21Cr      ₹56.71L    ₹36.98L    ₹19.73L      72.0%
====================================================================
*/

-- ================================================================
-- REPORT 2 — MAIN QUERY (Paste as Report Query in Oracle Reports)
-- ================================================================
SELECT
    p.Project_Type,
    COUNT(DISTINCT p.Project_ID)                        AS Project_Count,

    -- Contract metrics
    SUM(p.Contract_Value)                               AS Total_Contract_Value,
    ROUND(SUM(p.Contract_Value) / 100000, 2)            AS Contract_Value_Lakhs,

    -- Invoice metrics
    NVL(SUM(mi_agg.Total_Invoiced), 0)                  AS Total_Invoiced,
    ROUND(NVL(SUM(mi_agg.Total_Invoiced), 0) / 100000, 2) AS Invoiced_Lakhs,

    -- Collection metrics
    NVL(SUM(mi_agg.Total_Collected), 0)                 AS Total_Collected,
    ROUND(NVL(SUM(mi_agg.Total_Collected), 0) / 100000, 2) AS Collected_Lakhs,

    -- Outstanding
    NVL(SUM(mi_agg.Total_Invoiced), 0) -
    NVL(SUM(mi_agg.Total_Collected), 0)                 AS Total_Outstanding,

    -- Collection rate
    ROUND(
        NVL(SUM(mi_agg.Total_Collected), 0)
        / NULLIF(SUM(p.Contract_Value), 0) * 100, 1
    )                                                   AS Collection_Rate_Pct,

    -- Status breakdown
    SUM(CASE WHEN p.Status = 'In Progress' THEN 1 ELSE 0 END) AS Active,
    SUM(CASE WHEN p.Status = 'Completed'   THEN 1 ELSE 0 END) AS Completed,
    SUM(CASE WHEN p.Status = 'On Hold'     THEN 1 ELSE 0 END) AS On_Hold

FROM
    Projects p
    LEFT JOIN (
        SELECT
            Project_ID,
            SUM(Invoice_Amount)                         AS Total_Invoiced,
            SUM(Amount_Received)                        AS Total_Collected,
            SUM(Tax_Amount)                             AS Total_Tax,
            SUM(Total_Payable)                          AS Total_Payable
        FROM Milestone_Invoices
        GROUP BY Project_ID
    ) mi_agg ON p.Project_ID = mi_agg.Project_ID
WHERE
    p.Status NOT IN ('Cancelled')
GROUP BY
    p.Project_Type
ORDER BY
    Total_Contract_Value DESC;


-- ================================================================
-- REPORT 2 — DETAIL QUERY (Drill-down: per project within type)
-- Use this as a sub-query or linked report
-- ================================================================
SELECT
    p.Project_Type,
    p.Project_ID,
    p.Project_Name,
    d.Full_Name                                         AS Designer,
    c.Full_Name                                         AS Customer,
    p.City,
    TO_CHAR(p.Start_Date,        'DD-Mon-YYYY')         AS Start_Date,
    TO_CHAR(p.Planned_End_Date,  'DD-Mon-YYYY')         AS Planned_End,
    p.Contract_Value,
    NVL((SELECT SUM(Invoice_Amount) FROM Milestone_Invoices mi WHERE mi.Project_ID = p.Project_ID), 0) AS Invoiced_Amount,
    NVL((SELECT SUM(Amount_Received) FROM Milestone_Invoices mi WHERE mi.Project_ID = p.Project_ID), 0) AS Collected_Amount,
    fn_get_project_margin(p.Project_ID)                 AS Margin_Pct,
    p.Status
FROM
    Projects    p
    JOIN Designers  d ON p.Designer_ID = d.Designer_ID
    JOIN Customers  c ON p.Customer_ID = c.Customer_ID
WHERE
    p.Status NOT IN ('Cancelled')
ORDER BY
    p.Project_Type, p.Start_Date;


-- ================================================================
-- REPORT 2 — GRAND TOTAL FOOTER QUERY
-- ================================================================
SELECT
    'GRAND TOTAL'                                       AS Label,
    COUNT(DISTINCT p.Project_ID)                        AS Total_Projects,
    SUM(p.Contract_Value)                               AS Total_Contract,
    NVL(SUM(mi_agg.Total_Invoiced), 0)                 AS Total_Invoiced,
    NVL(SUM(mi_agg.Total_Collected), 0)                AS Total_Collected,
    NVL(SUM(mi_agg.Total_Invoiced), 0) -
    NVL(SUM(mi_agg.Total_Collected), 0)                AS Outstanding,
    ROUND(
        NVL(SUM(mi_agg.Total_Collected), 0) /
        NULLIF(SUM(p.Contract_Value), 0) * 100, 1
    )                                                   AS Overall_Collection_Pct
FROM
    Projects p
    LEFT JOIN (
        SELECT Project_ID,
               SUM(Invoice_Amount)  AS Total_Invoiced,
               SUM(Amount_Received) AS Total_Collected
        FROM   Milestone_Invoices
        GROUP  BY Project_ID
    ) mi_agg ON p.Project_ID = mi_agg.Project_ID
WHERE
    p.Status NOT IN ('Cancelled');

-- ============================================================
-- END OF SCRIPT 07_Oracle_Reports_Queries.sql
-- ============================================================
