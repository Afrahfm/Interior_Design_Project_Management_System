-- ================================================================
-- STEP 1: CREATE SEQUENCES (Auto-increment IDs)
-- ================================================================
CREATE SEQUENCE SEQ_LEAD_ID        START WITH 1001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_CUSTOMER_ID    START WITH 2001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_DESIGNER_ID    START WITH 3001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_QUOTATION_ID   START WITH 4001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_REVISION_ID    START WITH 5001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ITEM_ID        START WITH 6001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_PROJECT_ID     START WITH 7001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_MILESTONE_ID   START WITH 8001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_VENDOR_ID      START WITH 9001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ORDER_ID       START WITH 10001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_SITE_UPDATE_ID START WITH 11001 INCREMENT BY 1;
CREATE SEQUENCE SEQ_INVOICE_ID     START WITH 12001 INCREMENT BY 1;

-- ================================================================
-- TABLE 1: LEADS
-- ================================================================
CREATE TABLE Leads (
    Lead_ID         NUMBER          DEFAULT SEQ_LEAD_ID.NEXTVAL,
    Customer_Name   VARCHAR2(100)   NOT NULL,
    Contact_Number  VARCHAR2(15)    NOT NULL,
    Email           VARCHAR2(100),
    City            VARCHAR2(50),
    Project_Type    VARCHAR2(20)    NOT NULL
                    CHECK (Project_Type IN ('Home','Office','Villa','Retail')),
    Budget_Min      NUMBER(12,2),
    Budget_Max      NUMBER(12,2),
    Inquiry_Date    DATE            DEFAULT SYSDATE NOT NULL,
    Source          VARCHAR2(30)
                    CHECK (Source IN ('WhatsApp','Website','Referral','Instagram','Walk-in','Other')),
    Designer_ID     NUMBER,
    Status          VARCHAR2(20)    DEFAULT 'New'
                    CHECK (Status IN ('New','Contacted','Site Visit Done','Quotation Sent','Converted','Lost')),
    Remarks         VARCHAR2(500),
    Created_At      TIMESTAMP       DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_leads PRIMARY KEY (Lead_ID)
);

-- ================================================================
-- TABLE 2: CUSTOMERS
-- ================================================================
CREATE TABLE Customers (
    Customer_ID     NUMBER          DEFAULT SEQ_CUSTOMER_ID.NEXTVAL,
    Lead_ID         NUMBER,
    Full_Name       VARCHAR2(100)   NOT NULL,
    Contact_Number  VARCHAR2(15)    NOT NULL,
    Email           VARCHAR2(100),
    Address         VARCHAR2(300),
    City            VARCHAR2(50),
    PAN_Number      VARCHAR2(15),
    GST_Number      VARCHAR2(20),
    Created_At      TIMESTAMP       DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_customers PRIMARY KEY (Customer_ID),
    CONSTRAINT uq_cust_lead UNIQUE (Lead_ID),
    CONSTRAINT fk_cust_lead FOREIGN KEY (Lead_ID) REFERENCES Leads(Lead_ID)
);

-- ================================================================
-- TABLE 3: DESIGNERS
-- ================================================================
CREATE TABLE Designers (
    Designer_ID     NUMBER          DEFAULT SEQ_DESIGNER_ID.NEXTVAL,
    Full_Name       VARCHAR2(100)   NOT NULL,
    Email           VARCHAR2(100)   NOT NULL,
    Phone           VARCHAR2(15),
    Specialization  VARCHAR2(50),
    Experience_Yrs  NUMBER(3),
    Status          VARCHAR2(10)    DEFAULT 'Active'
                    CHECK (Status IN ('Active','Inactive')),
    Date_Joined     DATE,
    CONSTRAINT pk_designers      PRIMARY KEY (Designer_ID),
    CONSTRAINT uq_designer_email UNIQUE (Email)
);

ALTER TABLE Leads
ADD CONSTRAINT fk_lead_designer FOREIGN KEY (Designer_ID) REFERENCES Designers(Designer_ID);

-- ================================================================
-- TABLE 4: QUOTATIONS
-- ================================================================
CREATE TABLE Quotations (
    Quotation_ID        NUMBER      DEFAULT SEQ_QUOTATION_ID.NEXTVAL,
    Lead_ID             NUMBER      NOT NULL,
    Customer_ID         NUMBER,
    Designer_ID         NUMBER      NOT NULL,
    Project_Type        VARCHAR2(20)
                        CHECK (Project_Type IN ('Home','Office','Villa','Retail')),
    Quote_Date          DATE        DEFAULT SYSDATE,
    Valid_Until         DATE,
    Current_Version     NUMBER(3)   DEFAULT 1,
    Subtotal_Amount     NUMBER(14,2) DEFAULT 0,
    Discount_Pct        NUMBER(5,2)  DEFAULT 0,
    Discount_Amount     NUMBER(14,2) DEFAULT 0,
    Tax_Amount          NUMBER(14,2) DEFAULT 0,
    Total_Amount        NUMBER(14,2) DEFAULT 0,
    Status              VARCHAR2(20) DEFAULT 'Draft'
                        CHECK (Status IN ('Draft','Sent','Under Revision','Approved','Rejected')),
    Notes               VARCHAR2(1000),
    Created_At          TIMESTAMP   DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_quotations    PRIMARY KEY (Quotation_ID),
    CONSTRAINT fk_quot_lead     FOREIGN KEY (Lead_ID)     REFERENCES Leads(Lead_ID),
    CONSTRAINT fk_quot_cust     FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    CONSTRAINT fk_quot_designer FOREIGN KEY (Designer_ID) REFERENCES Designers(Designer_ID)
);

-- ================================================================
-- TABLE 5: QUOTATION_REVISIONS
-- ================================================================
CREATE TABLE Quotation_Revisions (
    Revision_ID         NUMBER      DEFAULT SEQ_REVISION_ID.NEXTVAL,
    Quotation_ID        NUMBER      NOT NULL,
    Version_Number      NUMBER(3)   NOT NULL,
    Revised_By          NUMBER,
    Revision_Date       DATE        DEFAULT SYSDATE,
    Reason_For_Revision VARCHAR2(500),
    Subtotal_Amount     NUMBER(14,2) DEFAULT 0,
    Discount_Pct        NUMBER(5,2)  DEFAULT 0,
    Total_Amount        NUMBER(14,2) DEFAULT 0,
    Status              VARCHAR2(20) DEFAULT 'Draft'
                        CHECK (Status IN ('Draft','Sent','Approved','Superseded')),
    CONSTRAINT pk_quot_revisions  PRIMARY KEY (Revision_ID),
    CONSTRAINT uq_quot_version    UNIQUE (Quotation_ID, Version_Number),
    CONSTRAINT fk_rev_quotation   FOREIGN KEY (Quotation_ID) REFERENCES Quotations(Quotation_ID),
    CONSTRAINT fk_rev_designer    FOREIGN KEY (Revised_By)   REFERENCES Designers(Designer_ID)
);

-- ================================================================
-- TABLE 6: QUOTATION_ITEMS
-- ================================================================
CREATE TABLE Quotation_Items (
    Item_ID             NUMBER      DEFAULT SEQ_ITEM_ID.NEXTVAL,
    Revision_ID         NUMBER      NOT NULL,
    Quotation_ID        NUMBER      NOT NULL,
    Item_Category       VARCHAR2(50),
    Item_Description    VARCHAR2(300) NOT NULL,
    Unit                VARCHAR2(20),
    Quantity            NUMBER(10,3) DEFAULT 1,
    Unit_Rate           NUMBER(12,2) NOT NULL,
    Amount              NUMBER(14,2),
    Remarks             VARCHAR2(300),
    CONSTRAINT pk_quot_items     PRIMARY KEY (Item_ID),
    CONSTRAINT fk_item_revision  FOREIGN KEY (Revision_ID)  REFERENCES Quotation_Revisions(Revision_ID),
    CONSTRAINT fk_item_quotation FOREIGN KEY (Quotation_ID) REFERENCES Quotations(Quotation_ID)
);

-- ================================================================
-- TABLE 7: PROJECTS
-- ================================================================
CREATE TABLE Projects (
    Project_ID          NUMBER      DEFAULT SEQ_PROJECT_ID.NEXTVAL,
    Quotation_ID        NUMBER      NOT NULL,
    Customer_ID         NUMBER      NOT NULL,
    Designer_ID         NUMBER      NOT NULL,
    Project_Name        VARCHAR2(200) NOT NULL,
    Project_Type        VARCHAR2(20)
                        CHECK (Project_Type IN ('Home','Office','Villa','Retail')),
    Site_Address        VARCHAR2(400),
    City                VARCHAR2(50),
    Start_Date          DATE,
    Planned_End_Date    DATE,
    Actual_End_Date     DATE,
    Contract_Value      NUMBER(14,2),
    Status              VARCHAR2(20) DEFAULT 'Initiated'
                        CHECK (Status IN ('Initiated','In Progress','On Hold','Completed','Cancelled')),
    Notes               VARCHAR2(1000),
    Created_At          TIMESTAMP   DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_projects       PRIMARY KEY (Project_ID),
    CONSTRAINT fk_proj_quotation FOREIGN KEY (Quotation_ID) REFERENCES Quotations(Quotation_ID),
    CONSTRAINT fk_proj_customer  FOREIGN KEY (Customer_ID)  REFERENCES Customers(Customer_ID),
    CONSTRAINT fk_proj_designer  FOREIGN KEY (Designer_ID)  REFERENCES Designers(Designer_ID)
);

-- ================================================================
-- TABLE 8: MILESTONES
-- ================================================================
CREATE TABLE Milestones (
    Milestone_ID        NUMBER      DEFAULT SEQ_MILESTONE_ID.NEXTVAL,
    Project_ID          NUMBER      NOT NULL,
    Milestone_Name      VARCHAR2(100) NOT NULL,
    Milestone_Order     NUMBER(3),
    Planned_Start_Date  DATE,
    Planned_End_Date    DATE        NOT NULL,
    Actual_End_Date     DATE,
    Payment_Percentage  NUMBER(5,2),
    Status              VARCHAR2(20) DEFAULT 'Pending'
                        CHECK (Status IN ('Pending','In Progress','Complete','On Hold')),
    Completion_Pct      NUMBER(5,2)  DEFAULT 0
                        CHECK (Completion_Pct BETWEEN 0 AND 100),
    Notes               VARCHAR2(500),
    Completed_At        TIMESTAMP,
    CONSTRAINT pk_milestones     PRIMARY KEY (Milestone_ID),
    CONSTRAINT fk_milestone_proj FOREIGN KEY (Project_ID) REFERENCES Projects(Project_ID)
);

-- ================================================================
-- TABLE 9: VENDORS
-- ================================================================
CREATE TABLE Vendors (
    Vendor_ID           NUMBER      DEFAULT SEQ_VENDOR_ID.NEXTVAL,
    Vendor_Name         VARCHAR2(100) NOT NULL,
    Contact_Person      VARCHAR2(100),
    Phone               VARCHAR2(15),
    Email               VARCHAR2(100),
    Address             VARCHAR2(300),
    City                VARCHAR2(50),
    Category            VARCHAR2(50),
    GST_Number          VARCHAR2(20),
    Payment_Terms       VARCHAR2(100),
    Rating              NUMBER(2,1) CHECK (Rating BETWEEN 1 AND 5),
    Status              VARCHAR2(10) DEFAULT 'Active'
                        CHECK (Status IN ('Active','Inactive','Blacklisted')),
    Created_At          TIMESTAMP   DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_vendors PRIMARY KEY (Vendor_ID)
);

-- ================================================================
-- TABLE 10: MATERIAL_ORDERS
-- ================================================================
CREATE TABLE Material_Orders (
    Order_ID            NUMBER      DEFAULT SEQ_ORDER_ID.NEXTVAL,
    Project_ID          NUMBER      NOT NULL,
    Milestone_ID        NUMBER,
    Vendor_ID           NUMBER      NOT NULL,
    Material_Name       VARCHAR2(200) NOT NULL,
    Category            VARCHAR2(50),
    Quantity            NUMBER(10,3) NOT NULL,
    Unit                VARCHAR2(20),
    Unit_Price          NUMBER(12,2),
    Total_Price         NUMBER(14,2),
    Order_Date          DATE        DEFAULT SYSDATE,
    Expected_Delivery   DATE,
    Actual_Delivery     DATE,
    Delivery_Status     VARCHAR2(20) DEFAULT 'Ordered'
                        CHECK (Delivery_Status IN ('Ordered','In Transit','Delivered','Cancelled','Delayed')),
    Invoice_Number      VARCHAR2(50),
    Remarks             VARCHAR2(500),
    Created_At          TIMESTAMP   DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_material_orders  PRIMARY KEY (Order_ID),
    CONSTRAINT fk_order_project    FOREIGN KEY (Project_ID)  REFERENCES Projects(Project_ID),
    CONSTRAINT fk_order_milestone  FOREIGN KEY (Milestone_ID) REFERENCES Milestones(Milestone_ID),
    CONSTRAINT fk_order_vendor     FOREIGN KEY (Vendor_ID)   REFERENCES Vendors(Vendor_ID)
);

-- ================================================================
-- TABLE 11: SITE_UPDATES
-- ================================================================
CREATE TABLE Site_Updates (
    Site_Update_ID      NUMBER      DEFAULT SEQ_SITE_UPDATE_ID.NEXTVAL,
    Project_ID          NUMBER      NOT NULL,
    Milestone_ID        NUMBER,
    Update_Date         DATE        DEFAULT SYSDATE NOT NULL,
    Updated_By          VARCHAR2(100),
    Work_Done           VARCHAR2(1000) NOT NULL,
    Issues_Observed     VARCHAR2(500),
    Workers_Present     NUMBER(5),
    Photo_Reference     VARCHAR2(300),
    Weather_Condition   VARCHAR2(30),
    Next_Day_Plan       VARCHAR2(500),
    Created_At          TIMESTAMP   DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_site_updates  PRIMARY KEY (Site_Update_ID),
    CONSTRAINT fk_su_project    FOREIGN KEY (Project_ID)  REFERENCES Projects(Project_ID),
    CONSTRAINT fk_su_milestone  FOREIGN KEY (Milestone_ID) REFERENCES Milestones(Milestone_ID)
);

-- ================================================================
-- TABLE 12: MILESTONE_INVOICES
-- ================================================================
CREATE TABLE Milestone_Invoices (
    Invoice_ID          NUMBER      DEFAULT SEQ_INVOICE_ID.NEXTVAL,
    Milestone_ID        NUMBER      NOT NULL,
    Project_ID          NUMBER      NOT NULL,
    Customer_ID         NUMBER      NOT NULL,
    Invoice_Number      VARCHAR2(30) NOT NULL,
    Invoice_Date        DATE        DEFAULT SYSDATE,
    Due_Date            DATE,
    Contract_Value      NUMBER(14,2),
    Payment_Percentage  NUMBER(5,2),
    Invoice_Amount      NUMBER(14,2) NOT NULL,
    Tax_Rate            NUMBER(5,2)  DEFAULT 18,
    Tax_Amount          NUMBER(14,2),
    Total_Payable       NUMBER(14,2),
    Payment_Status      VARCHAR2(20) DEFAULT 'Unpaid'
                        CHECK (Payment_Status IN ('Unpaid','Partially Paid','Paid','Overdue')),
    Payment_Date        DATE,
    Amount_Received     NUMBER(14,2) DEFAULT 0,
    Notes               VARCHAR2(500),
    Created_At          TIMESTAMP   DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_milestone_invoices PRIMARY KEY (Invoice_ID),
    CONSTRAINT uq_milestone_invoice  UNIQUE (Milestone_ID),
    CONSTRAINT fk_inv_milestone  FOREIGN KEY (Milestone_ID) REFERENCES Milestones(Milestone_ID),
    CONSTRAINT fk_inv_project    FOREIGN KEY (Project_ID)   REFERENCES Projects(Project_ID),
    CONSTRAINT fk_inv_customer   FOREIGN KEY (Customer_ID)  REFERENCES Customers(Customer_ID)
);

-- ================================================================
-- VERIFY: Count all 12 tables
-- ================================================================
SELECT table_name
FROM user_tables
WHERE table_name IN (
    'LEADS','CUSTOMERS','DESIGNERS','QUOTATIONS',
    'QUOTATION_REVISIONS','QUOTATION_ITEMS','PROJECTS',
    'MILESTONES','VENDORS','MATERIAL_ORDERS',
    'SITE_UPDATES','MILESTONE_INVOICES'
)
ORDER BY table_name;
