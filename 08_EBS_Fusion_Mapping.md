# Interior Design Firm – Quotation & Project Execution System
## Oracle EBS / Fusion Mapping Document & OTBI Dashboard Guide

---

## 1. Oracle EBS / Fusion Module Mapping

This document maps the custom system tables to standard Oracle EBS / Oracle Fusion Cloud modules for enterprise integration.

---

### 1.1 Oracle Projects Module Mapping

| Custom Table | Oracle Module | Oracle Object | Notes |
|---|---|---|---|
| `Projects` | **Oracle Project Costing (PA)** | PA_PROJECTS_ALL | Project_ID maps to PA Project Number |
| `Milestones` | **Oracle Project Billing** | PA_BILLING_ASSIGNMENTS | Each milestone = a billing event |
| `Milestone_Invoices` | **Oracle Project Billing** | PA_DRAFT_INVOICES_ALL | Auto-generated milestone invoices |
| `Site_Updates` | **Oracle Project Status Reporting** | PA_PROJECT_STATUSES | Progress % and issues log |
| `Designers` | **Oracle HR / HCM** | PER_PEOPLE_F | Designers as employees/resources |

**EBS Setup Steps:**
1. Create a **Project Template** for Home / Office / Villa types
2. Map Milestones to **Billing Events** with percentage billing amounts
3. Enable **AutoAccounting Rules** for invoice generation
4. Link Designers as **Project Resources** with billing rates

---

### 1.2 Oracle Procure-to-Pay (P2P) Mapping

Material ordering maps to Oracle's Purchase-to-Pay cycle:

```
CUSTOM SYSTEM              ORACLE EBS P2P MODULE
─────────────────────────────────────────────────────────────
Material_Orders.Order      → Purchase Order (PO_HEADERS_ALL)
Material_Orders.Line       → PO Lines (PO_LINES_ALL)
Vendors                    → Suppliers (AP_SUPPLIERS)
Delivery_Status=Delivered  → Goods Receipt Note (RCV_SHIPMENT_HEADERS)
Material_Orders.Invoice    → AP Invoice (AP_INVOICES_ALL)
Payment to Vendor          → AP Payment (AP_CHECKS_ALL)
```

**P2P Flow in Oracle EBS:**
```
Vendor Registered in Oracle
    ↓
Purchase Requisition (Auto from Material_Order)
    ↓
Purchase Order Approved
    ↓
Goods Receipt (Actual_Delivery date)
    ↓
Supplier Invoice Entry
    ↓
3-Way Match (PO + Receipt + Invoice)
    ↓
Payment to Vendor
```

---

### 1.3 Oracle Accounts Receivable (AR) Mapping

| Custom Table | Oracle AR Object | Description |
|---|---|---|
| `Customers` | `HZ_PARTIES` + `HZ_CUST_ACCOUNTS` | Customer master in TCA |
| `Milestone_Invoices` | `RA_CUSTOMER_TRX_ALL` | Customer transaction / invoice |
| `Invoice_Amount` | `RA_CUSTOMER_TRX_LINES_ALL` | Invoice line amount |
| `Tax_Amount (GST)` | `ZX_LINES` | Tax lines via E-Business Tax |
| `Payment_Status` | `AR_PAYMENT_SCHEDULES_ALL` | Payment tracking |
| `Amount_Received` | `AR_CASH_RECEIPTS_ALL` | Receipt application |

---

### 1.4 Oracle Fusion Cloud Mapping (SaaS)

| Custom System | Oracle Fusion Module | Feature |
|---|---|---|
| Projects + Milestones | **Fusion Project Management** | Project Plan, Deliverables |
| Material_Orders | **Fusion Procurement** | Self-Service Purchasing |
| Milestone_Invoices | **Fusion Project Billing** | Contract Billing Events |
| Site_Updates | **Fusion Project Execution** | Status Reports |
| Revenue Report | **Fusion Revenue Management** | Revenue Recognition |
| OTBI Dashboard | **Oracle Analytics (OAC/OTBI)** | Real-time dashboards |

---

## 2. OTBI Project Margin Dashboard

### Dashboard Name: `Interior Design – Executive Project Dashboard`

---

### 2.1 Dashboard Overview Layout

```
┌─────────────────────────────────────────────────────────────────┐
│        INTERIOR DESIGN – PROJECT MARGIN DASHBOARD               │
│        Oracle Transactional Business Intelligence (OTBI)        │
├──────────────┬──────────────┬──────────────┬────────────────────┤
│  KPI TILE 1  │  KPI TILE 2  │  KPI TILE 3  │    KPI TILE 4      │
│  Active      │  Total       │  Avg Margin  │  Overdue           │
│  Projects    │  Portfolio   │     %        │  Milestones        │
│    40        │  ₹2.21 Cr    │    72.4%     │       3            │
├──────────────┴──────────────┴──────────────┴────────────────────┤
│ [Bar Chart: Revenue vs Cost by Project Type]                    │
│  Home ████████████ ₹32.3L / Cost ₹6.4L = 80% Margin           │
│  Office ████████   ₹43.5L / Cost ₹8.5L = 65% Margin           │
│  Villa  ████████████████  ₹1.46Cr / Cost ₹4.5L = 70% Margin   │
├─────────────────────────────────────────────────────────────────┤
│ [Line Chart: Monthly Revenue Trend]                             │
│  Aug-2026: ₹9.2L | Sep-2026: ₹18.4L | Oct-2026: ₹9.3L        │
├─────────────────────────────────────────────────────────────────┤
│ [Table: Project Margin Detail — All Active Projects]            │
│  Designer | Project | Type | Contract | Billed | Margin%       │
│  ─────────────────────────────────────────────────────────────  │
│  R.Sharma | Kiran Patel Home | Home | 13.45L | 1.59L | 89.5%  │
│  R.Sharma | Nisha Iyer Villa | Villa| 1.13Cr | 22.7L | 71.2%  │
│  P.Nair   | Meera Rao Office | Off  | 43.5L  | 15.4L | 65.3%  │
└─────────────────────────────────────────────────────────────────┘
```

---

### 2.2 OTBI Analysis / Report Configuration

#### Analysis 1: Project Margin KPI Tile
- **Subject Area**: Custom (PA – Project Costing Real Time)
- **Measure**: `fn_get_project_margin(Project_ID)` → mapped as calculated measure
- **Filter**: Project Status = 'In Progress' OR 'Completed'
- **Display**: Gauge chart (0–100%)

#### Analysis 2: Revenue vs Material Cost Bar Chart
- **Subject Area**: PA – Project Billing Real Time
- **Columns**:
  - `Project_Type` (dimension)
  - `SUM(Invoice_Amount)` → Revenue
  - `SUM(Material_Order_Value)` → Cost
- **Chart Type**: Clustered Bar
- **Conditional Format**: Red if Margin < 20%

#### Analysis 3: Monthly Revenue Trend Line Chart
- **Subject Area**: AR – Customer Invoices Real Time
- **Columns**:
  - `TRUNC(Invoice_Date, 'MM')` → Month
  - `SUM(Invoice_Amount)` → Monthly Revenue
- **Chart Type**: Line with Markers
- **Time Filter**: Last 6 months

#### Analysis 4: Delayed Milestone Alert Table
- **Subject Area**: PA – Project Tasks Real Time
- **Filter**: `Planned_End_Date < SYSDATE AND Status NOT IN ('Complete')`
- **Display**: Traffic Light indicator (Red = Overdue, Amber = Due This Week)

---

### 2.3 Dashboard Filters (Prompted)
- **Designer**: Multi-select LOV
- **Project Type**: Home / Office / Villa / Retail
- **City**: Multi-select
- **Date Range**: Invoice Date range picker
- **Project Status**: In Progress / Completed / On Hold

---

## 3. EBS Integration Architecture

```
┌──────────────────────────────────────────────┐
│           CUSTOM ORACLE FORMS APP            │
│  (Forms + Reports + PL/SQL on Oracle DB)     │
└───────────────┬──────────────────────────────┘
                │  Database Link / API
                ▼
┌──────────────────────────────────────────────┐
│              ORACLE EBS 12.2                 │
├──────────────────────────────────────────────┤
│  PA Module  │  PO/AP Module  │  AR Module    │
│  (Projects) │  (P2P Vendors) │  (Invoices)   │
└──────────┬──┴────────────────┴───────────────┘
           │  OTBI / Oracle BI Publisher
           ▼
┌──────────────────────────────────────────────┐
│         OTBI DASHBOARD (Executive View)      │
│  Project Margin % | Revenue Trend | Delays   │
└──────────────────────────────────────────────┘
```

---

## 4. GST (Tax) Configuration in Oracle EBS

Since this is an Indian interior design firm:

| Tax | Rate | Oracle EBS Setup |
|-----|------|-----------------|
| CGST | 9% | Tax Code: GST_CGST_9 |
| SGST | 9% | Tax Code: GST_SGST_9 |
| IGST | 18% | Tax Code: GST_IGST_18 (inter-state) |

- Enable **E-Business Tax (ZX)** module
- Create Tax Regime: `IN_GST`
- Attach to all customer invoices (Milestone_Invoices)

---

## 5. Key Integration Points Summary

| Integration | Direction | Method |
|---|---|---|
| Customer → EBS AR | Outbound | API / DB Link |
| Material Order → EBS PO | Outbound | Oracle Open Interface |
| Milestone Invoice → EBS AR | Outbound | AutoInvoice Import |
| EBS Payment → Custom | Inbound | AR Receipt application |
| OTBI → Dashboard | Reporting | OBIEE / OTBI Subject Areas |

---

*Document prepared for Wipro Oracle Project — Interior Design Firm Project Management System*
