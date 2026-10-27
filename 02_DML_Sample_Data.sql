/*
  Interior Design Firm - Quotation and Project Execution System
  Script 02 - DML Sample Data
  Run AFTER Script 01 (DDL Create Tables)
*/

-- Disable substitution variables (stops & from triggering popups)
SET DEFINE OFF;

-- ================================================================
-- TABLE 3: DESIGNERS (insert first — referenced by Leads FK)
-- ================================================================
INSERT INTO Designers (Designer_ID, Full_Name, Email, Phone, Specialization, Experience_Yrs, Status, Date_Joined)
VALUES (SEQ_DESIGNER_ID.NEXTVAL, 'Rahul Sharma',    'rahul.sharma@designfirm.com',   '9876543210', 'Modern Minimalist', 8,  'Active', DATE '2018-03-15');

INSERT INTO Designers (Designer_ID, Full_Name, Email, Phone, Specialization, Experience_Yrs, Status, Date_Joined)
VALUES (SEQ_DESIGNER_ID.NEXTVAL, 'Priya Nair',      'priya.nair@designfirm.com',     '9876543211', 'Contemporary',     6,  'Active', DATE '2019-07-01');

INSERT INTO Designers (Designer_ID, Full_Name, Email, Phone, Specialization, Experience_Yrs, Status, Date_Joined)
VALUES (SEQ_DESIGNER_ID.NEXTVAL, 'Aditya Verma',    'aditya.verma@designfirm.com',   '9876543212', 'Classic & Ethnic',  10, 'Active', DATE '2016-01-10');

INSERT INTO Designers (Designer_ID, Full_Name, Email, Phone, Specialization, Experience_Yrs, Status, Date_Joined)
VALUES (SEQ_DESIGNER_ID.NEXTVAL, 'Sneha Kulkarni',  'sneha.kulkarni@designfirm.com', '9876543213', 'Scandinavian',      4,  'Active', DATE '2022-05-20');

INSERT INTO Designers (Designer_ID, Full_Name, Email, Phone, Specialization, Experience_Yrs, Status, Date_Joined)
VALUES (SEQ_DESIGNER_ID.NEXTVAL, 'Arjun Mehta',     'arjun.mehta@designfirm.com',    '9876543214', 'Industrial Chic',   5,  'Active', DATE '2021-09-01');

COMMIT;

-- ================================================================
-- TABLE 1: LEADS
-- ================================================================
INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Kiran Patel',       '9123456701', 'kiran.patel@gmail.com',      'Mumbai',    'Home',   800000,  1500000, DATE '2026-08-10', 'WhatsApp',  3001, 'Converted',       '2BHK flat in Bandra');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Meera Rao',         '9123456702', 'meera.rao@gmail.com',        'Pune',      'Office', 2000000, 5000000, DATE '2026-07-20', 'Website',   3002, 'Converted',       'IT company office fit-out');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Suresh Joshi',      '9123456703', 'suresh.joshi@gmail.com',     'Nagpur',    'Villa',  5000000, 9000000, DATE '2026-08-01', 'Referral',  3003, 'Converted',       '4BHK villa full interior');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Anita Singh',       '9123456704', 'anita.singh@gmail.com',      'Hyderabad', 'Home',   600000,  1200000, DATE '2026-09-05', 'Instagram', 3001, 'Quotation Sent',  'Studio apartment redesign');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Rajesh Gupta',      '9123456705', 'rajesh.gupta@gmail.com',     'Delhi',     'Retail', 1500000, 3000000, DATE '2026-09-15', 'Walk-in',   3004, 'Contacted',       'Boutique store in Connaught Place');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Divya Menon',       '9123456706', 'divya.menon@gmail.com',      'Chennai',   'Home',   1000000, 2000000, DATE '2026-06-01', 'WhatsApp',  3002, 'Lost',            'Client chose another firm');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Vikram Choudhary',  '9123456707', 'vikram.c@gmail.com',         'Jaipur',    'Home',   700000,  1400000, DATE '2026-08-20', 'Referral',  3005, 'New',             'New inquiry, not called yet');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Pooja Desai',       '9123456708', 'pooja.desai@gmail.com',       'Ahmedabad', 'Office', 3000000, 6000000, DATE '2026-09-01', 'Website',   3003, 'Site Visit Done', 'Corporate headquarters redesign');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Arun Kumar',        '9123456709', 'arun.kumar@gmail.com',        'Bangalore', 'Home',   900000,  1800000, DATE '2026-07-05', 'Instagram', 3004, 'Converted',       '3BHK full home renovation');

INSERT INTO Leads (Lead_ID, Customer_Name, Contact_Number, Email, City, Project_Type, Budget_Min, Budget_Max, Inquiry_Date, Source, Designer_ID, Status, Remarks)
VALUES (SEQ_LEAD_ID.NEXTVAL, 'Nisha Iyer',        '9123456710', 'nisha.iyer@gmail.com',        'Kochi',     'Villa',  7000000, 12000000, DATE '2026-06-15', 'Referral', 3001, 'Converted',       'Beachside villa luxury interiors');

COMMIT;

-- ================================================================
-- TABLE 2: CUSTOMERS (converted from Leads 1001, 1002, 1003, 1009, 1010)
-- ================================================================
INSERT INTO Customers (Customer_ID, Lead_ID, Full_Name, Contact_Number, Email, Address, City, PAN_Number)
VALUES (SEQ_CUSTOMER_ID.NEXTVAL, 1001, 'Kiran Patel',    '9123456701', 'kiran.patel@gmail.com',   'A-402, Bandra West',  'Mumbai',    'ABCPK1234F');

INSERT INTO Customers (Customer_ID, Lead_ID, Full_Name, Contact_Number, Email, Address, City, PAN_Number)
VALUES (SEQ_CUSTOMER_ID.NEXTVAL, 1002, 'Meera Rao',      '9123456702', 'meera.rao@gmail.com',     'Hinjewadi Phase 2',   'Pune',      'DEFMR5678G');

INSERT INTO Customers (Customer_ID, Lead_ID, Full_Name, Contact_Number, Email, Address, City, PAN_Number)
VALUES (SEQ_CUSTOMER_ID.NEXTVAL, 1003, 'Suresh Joshi',   '9123456703', 'suresh.joshi@gmail.com',  'Civil Lines, Nagpur', 'Nagpur',    'GHISJ9101H');

INSERT INTO Customers (Customer_ID, Lead_ID, Full_Name, Contact_Number, Email, Address, City, PAN_Number)
VALUES (SEQ_CUSTOMER_ID.NEXTVAL, 1009, 'Arun Kumar',     '9123456709', 'arun.kumar@gmail.com',    'Indiranagar, HSR',    'Bangalore', 'JKLAK1121I');

INSERT INTO Customers (Customer_ID, Lead_ID, Full_Name, Contact_Number, Email, Address, City, PAN_Number)
VALUES (SEQ_CUSTOMER_ID.NEXTVAL, 1010, 'Nisha Iyer',     '9123456710', 'nisha.iyer@gmail.com',    'Marine Drive, Kochi', 'Kochi',     'MNONI1314J');

COMMIT;

-- ================================================================
-- TABLE 4: QUOTATIONS
-- ================================================================
INSERT INTO Quotations (Quotation_ID, Lead_ID, Customer_ID, Designer_ID, Project_Type, Quote_Date, Valid_Until, Current_Version, Subtotal_Amount, Discount_Pct, Discount_Amount, Tax_Amount, Total_Amount, Status, Notes)
VALUES (SEQ_QUOTATION_ID.NEXTVAL, 1001, 2001, 3001, 'Home',   DATE '2026-08-15', DATE '2026-09-15', 2, 1200000, 5, 60000, 205200,  1345200, 'Approved', 'Includes modular kitchen and wardrobes');

INSERT INTO Quotations (Quotation_ID, Lead_ID, Customer_ID, Designer_ID, Project_Type, Quote_Date, Valid_Until, Current_Version, Subtotal_Amount, Discount_Pct, Discount_Amount, Tax_Amount, Total_Amount, Status, Notes)
VALUES (SEQ_QUOTATION_ID.NEXTVAL, 1002, 2002, 3002, 'Office', DATE '2026-07-25', DATE '2026-08-25', 1, 3800000, 3, 114000, 664200,  4350200, 'Approved', 'Workstations, conference rooms, reception');

INSERT INTO Quotations (Quotation_ID, Lead_ID, Customer_ID, Designer_ID, Project_Type, Quote_Date, Valid_Until, Current_Version, Subtotal_Amount, Discount_Pct, Discount_Amount, Tax_Amount, Total_Amount, Status, Notes)
VALUES (SEQ_QUOTATION_ID.NEXTVAL, 1003, 2003, 3003, 'Villa',  DATE '2026-08-05', DATE '2026-09-05', 3, 7500000, 2, 150000, 1323000, 8673000, 'Approved', 'Premium Italian marble, custom woodwork');

INSERT INTO Quotations (Quotation_ID, Lead_ID, Customer_ID, Designer_ID, Project_Type, Quote_Date, Valid_Until, Current_Version, Subtotal_Amount, Discount_Pct, Discount_Amount, Tax_Amount, Total_Amount, Status, Notes)
VALUES (SEQ_QUOTATION_ID.NEXTVAL, 1009, 2004, 3004, 'Home',   DATE '2026-07-10', DATE '2026-08-10', 1, 1600000, 0, 0,      288000,  1888000, 'Approved', '3BHK complete renovation');

INSERT INTO Quotations (Quotation_ID, Lead_ID, Customer_ID, Designer_ID, Project_Type, Quote_Date, Valid_Until, Current_Version, Subtotal_Amount, Discount_Pct, Discount_Amount, Tax_Amount, Total_Amount, Status, Notes)
VALUES (SEQ_QUOTATION_ID.NEXTVAL, 1010, 2005, 3001, 'Villa',  DATE '2026-06-20', DATE '2026-07-20', 2, 10000000, 4, 400000, 1728000, 11328000, 'Approved', 'Luxury beachside villa - all rooms');

COMMIT;

-- ================================================================
-- TABLE 5: QUOTATION_REVISIONS
-- ================================================================
-- Quotation 4001: 2 revisions
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4001, 1, 3001, DATE '2026-08-15', 'Initial version',                     1200000, 5, 1140000, 'Superseded');
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4001, 2, 3001, DATE '2026-08-22', 'Client requested premium kitchen tiles', 1250000, 5, 1187500, 'Approved');

-- Quotation 4002: 1 revision
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4002, 1, 3002, DATE '2026-07-25', 'Initial version',                     3800000, 3, 3686000, 'Approved');

-- Quotation 4003: 3 revisions
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4003, 1, 3003, DATE '2026-08-05', 'Initial version',                     7000000, 2, 6860000, 'Superseded');
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4003, 2, 3003, DATE '2026-08-10', 'Added home theatre room',              7300000, 2, 7154000, 'Superseded');
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4003, 3, 3003, DATE '2026-08-14', 'Final approval with pool area',        7500000, 2, 7350000, 'Approved');

-- Quotation 4004: 1 revision
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4004, 1, 3004, DATE '2026-07-10', 'Initial version',                     1600000, 0, 1600000, 'Approved');

-- Quotation 4005: 2 revisions
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4005, 1, 3001, DATE '2026-06-20', 'Initial version',                     9500000, 4, 9120000, 'Superseded');
INSERT INTO Quotation_Revisions VALUES (SEQ_REVISION_ID.NEXTVAL, 4005, 2, 3001, DATE '2026-06-28', 'Added terrace landscaping',           10000000, 4, 9600000, 'Approved');

COMMIT;

-- ================================================================
-- TABLE 6: QUOTATION_ITEMS (for approved revisions)
-- ================================================================
-- Items for Revision 5002 (Quotation 4001, v2 - Home project)
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5002, 4001, 'Civil',       'Demolition and debris removal',          'Lumpsum', 1,    50000,  NULL);
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5002, 4001, 'Flooring',    'Vitrified tiles 800x800 (living+dining)', 'Sqft',   650,   250,    'Johnson tiles');
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5002, 4001, 'Kitchen',     'Modular kitchen - acrylic finish',        'Rft',    18,    15000,  'Hafele hardware');
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5002, 4001, 'Wardrobe',    'Sliding wardrobe 3-door with mirror',     'Nos',    3,     45000,  'Master + 2 bedrooms');
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5002, 4001, 'Electrical',  'Concealed wiring + modular switches',     'Point',  42,    1800,   'Legrand switches');
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5002, 4001, 'Paint',       'Luxury emulsion paint - 2 coats',         'Sqft',   1800,  65,     'Asian Paints Royale');

-- Items for Revision 5003 (Quotation 4002 - Office project)
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5003, 4002, 'Civil',       'False ceiling - grid system',             'Sqft',   3500,  180,    'Armstrong tiles');
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5003, 4002, 'Furniture',   'Workstation with partition (6-seater pod)', 'Nos', 20,    35000,  'Godrej Interio');
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5003, 4002, 'Furniture',   'Conference table 12-seater',              'Nos',    2,     85000,  'Custom fabricated');
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5003, 4002, 'Glass',       'Frameless glass partitions',              'Sqft',   800,   450,    'Tempered safety glass');
INSERT INTO Quotation_Items (Item_ID, Revision_ID, Quotation_ID, Item_Category, Item_Description, Unit, Quantity, Unit_Rate, Remarks)
VALUES (SEQ_ITEM_ID.NEXTVAL, 5003, 4002, 'Flooring',    'Carpet tiles - anti-static',              'Sqft',   2500,  120,    'Interface modular carpet');

COMMIT;

-- ================================================================
-- TABLE 7: PROJECTS
-- ================================================================
INSERT INTO Projects (Project_ID, Quotation_ID, Customer_ID, Designer_ID, Project_Name, Project_Type, Site_Address, City, Start_Date, Planned_End_Date, Contract_Value, Status)
VALUES (SEQ_PROJECT_ID.NEXTVAL, 4001, 2001, 3001, 'Kiran Patel - Bandra 2BHK Renovation',   'Home',   'A-402 Palm Beach, Bandra West',  'Mumbai',    DATE '2026-09-01', DATE '2026-11-30', 1345200,  'In Progress');

INSERT INTO Projects (Project_ID, Quotation_ID, Customer_ID, Designer_ID, Project_Name, Project_Type, Site_Address, City, Start_Date, Planned_End_Date, Contract_Value, Status)
VALUES (SEQ_PROJECT_ID.NEXTVAL, 4002, 2002, 3002, 'Meera Rao - IT Office Fit-Out Pune',     'Office', 'Hinjewadi Phase 2, Block C',     'Pune',      DATE '2026-08-15', DATE '2026-11-15', 4350200,  'In Progress');

INSERT INTO Projects (Project_ID, Quotation_ID, Customer_ID, Designer_ID, Project_Name, Project_Type, Site_Address, City, Start_Date, Planned_End_Date, Contract_Value, Status)
VALUES (SEQ_PROJECT_ID.NEXTVAL, 4003, 2003, 3003, 'Suresh Joshi - Nagpur Villa Full Interiors', 'Villa', 'Civil Lines Bungalow No. 7',  'Nagpur',    DATE '2026-08-20', DATE '2027-02-28', 8673000,  'In Progress');

INSERT INTO Projects (Project_ID, Quotation_ID, Customer_ID, Designer_ID, Project_Name, Project_Type, Site_Address, City, Start_Date, Planned_End_Date, Contract_Value, Status)
VALUES (SEQ_PROJECT_ID.NEXTVAL, 4004, 2004, 3004, 'Arun Kumar - Bangalore 3BHK Renovation',  'Home',   'HSR Layout Sector 4, Flat 8A',   'Bangalore', DATE '2026-07-20', DATE '2026-10-20', 1888000,  'Completed');

INSERT INTO Projects (Project_ID, Quotation_ID, Customer_ID, Designer_ID, Project_Name, Project_Type, Site_Address, City, Start_Date, Planned_End_Date, Contract_Value, Status)
VALUES (SEQ_PROJECT_ID.NEXTVAL, 4005, 2005, 3001, 'Nisha Iyer - Kochi Luxury Villa',         'Villa',  'Marine Drive Residence, Kochi',  'Kochi',     DATE '2026-07-01', DATE '2027-03-31', 11328000, 'In Progress');

COMMIT;

-- ================================================================
-- TABLE 8: MILESTONES
-- ================================================================
-- Project 7001 - Kiran Patel Bandra Home (5 milestones)
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7001, 'Demolition & Site Clearing',    1, DATE '2026-09-01', DATE '2026-09-10', DATE '2026-09-09', 10, 'Complete',     100, NULL, TIMESTAMP '2026-09-09 17:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7001, 'Civil Work & Tiling',           2, DATE '2026-09-10', DATE '2026-09-30', NULL,              20, 'In Progress',   65, 'Tiling 65% done', NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7001, 'Electrical & Plumbing',         3, DATE '2026-10-01', DATE '2026-10-15', NULL,              15, 'Pending',        0, NULL, NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7001, 'Carpentry & Modular Furniture', 4, DATE '2026-10-16', DATE '2026-11-15', NULL,              35, 'Pending',        0, NULL, NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7001, 'Painting & Final Handover',     5, DATE '2026-11-16', DATE '2026-11-30', NULL,              20, 'Pending',        0, NULL, NULL);

-- Project 7002 - Meera Rao Office (4 milestones)
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7002, 'Site Measurement & Planning',   1, DATE '2026-08-15', DATE '2026-08-25', DATE '2026-08-24', 5,  'Complete',     100, NULL, TIMESTAMP '2026-08-24 18:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7002, 'Civil & False Ceiling',         2, DATE '2026-08-26', DATE '2026-09-20', DATE '2026-09-22', 25, 'Complete',     100, '2 days delay due to ceiling material', TIMESTAMP '2026-09-22 17:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7002, 'Furniture & Partition',         3, DATE '2026-09-23', DATE '2026-10-25', NULL,              45, 'In Progress',   40, 'Workstation delivery delayed', NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7002, 'AV, Lighting & Snag Fixing',   4, DATE '2026-10-26', DATE '2026-11-15', NULL,              25, 'Pending',        0, NULL, NULL);

-- Project 7003 - Suresh Joshi Villa (6 milestones)
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7003, 'Design Finalization & BOQ',     1, DATE '2026-08-20', DATE '2026-09-05', DATE '2026-09-04', 5,  'Complete',     100, NULL, TIMESTAMP '2026-09-04 16:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7003, 'Demolition & Structural',       2, DATE '2026-09-05', DATE '2026-09-25', DATE '2026-09-28', 10, 'Complete',     100, '3 days delay - additional wall removal', TIMESTAMP '2026-09-28 17:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7003, 'Flooring - Italian Marble',     3, DATE '2026-09-29', DATE '2026-10-31', NULL,              20, 'In Progress',   30, 'Italian marble import delay', NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7003, 'Woodwork & Carpentry',          4, DATE '2026-11-01', DATE '2026-12-15', NULL,              25, 'Pending',        0, NULL, NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7003, 'Electrical, AV & Automation',  5, DATE '2026-12-16', DATE '2027-01-31', NULL,              25, 'Pending',        0, NULL, NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7003, 'Painting, Decor & Handover',   6, DATE '2027-02-01', DATE '2027-02-28', NULL,              15, 'Pending',        0, NULL, NULL);

-- Project 7004 - Arun Kumar (completed project - all milestones done)
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7004, 'Demolition',                    1, DATE '2026-07-20', DATE '2026-07-28', DATE '2026-07-28', 10, 'Complete',     100, NULL, TIMESTAMP '2026-07-28 17:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7004, 'Civil & Flooring',              2, DATE '2026-07-29', DATE '2026-08-20', DATE '2026-08-19', 25, 'Complete',     100, NULL, TIMESTAMP '2026-08-19 17:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7004, 'Electrical & Carpentry',        3, DATE '2026-08-20', DATE '2026-09-15', DATE '2026-09-16', 40, 'Complete',     100, '1 day delay', TIMESTAMP '2026-09-16 16:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7004, 'Final Handover',                4, DATE '2026-09-17', DATE '2026-10-15', DATE '2026-10-10', 25, 'Complete',     100, 'Client happy, early completion!', TIMESTAMP '2026-10-10 12:00:00');

-- Project 7005 - Nisha Iyer Luxury Villa (5 milestones)
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7005, 'Concept Design & Approval',    1, DATE '2026-07-01', DATE '2026-07-20', DATE '2026-07-18', 5,  'Complete',     100, NULL, TIMESTAMP '2026-07-18 17:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7005, 'Demolition & Civil',           2, DATE '2026-07-21', DATE '2026-08-31', DATE '2026-09-02', 15, 'Complete',     100, '2 days overrun', TIMESTAMP '2026-09-02 17:00:00');
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7005, 'Premium Flooring & Tiling',   3, DATE '2026-09-03', DATE '2026-10-31', NULL,              20, 'In Progress',   55, NULL, NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7005, 'Luxury Woodwork & Kitchen',   4, DATE '2026-11-01', DATE '2027-01-31', NULL,              35, 'Pending',        0, NULL, NULL);
INSERT INTO Milestones VALUES (SEQ_MILESTONE_ID.NEXTVAL, 7005, 'Final Decor & Handover',      5, DATE '2027-02-01', DATE '2027-03-31', NULL,              25, 'Pending',        0, NULL, NULL);

COMMIT;

-- ================================================================
-- TABLE 9: VENDORS
-- ================================================================
INSERT INTO Vendors VALUES (SEQ_VENDOR_ID.NEXTVAL, 'Kajaria Ceramics Ltd',     'Rajiv Shah',    '9988776655', 'sales@kajaria.com',      'Tiles District, Delhi',       'Delhi',     'Tiles',       '07AABCK1234Q', 'Net 30 days',   4.5, 'Active', SYSTIMESTAMP);
INSERT INTO Vendors VALUES (SEQ_VENDOR_ID.NEXTVAL, 'Asian Paints Ltd',         'Sunil Kumar',   '9988776656', 'trade@asianpaints.com',  'Lower Parel, Mumbai',         'Mumbai',    'Paint',       '27AAACA5678R', 'Advance 50%',   4.8, 'Active', SYSTIMESTAMP);
INSERT INTO Vendors VALUES (SEQ_VENDOR_ID.NEXTVAL, 'Godrej Interio',           'Anita Menon',   '9988776657', 'b2b@godrejinterio.com',  'Pirojshanagar, Vikhroli',     'Mumbai',    'Furniture',   '27AABCG2345S', 'Net 45 days',   4.3, 'Active', SYSTIMESTAMP);
INSERT INTO Vendors VALUES (SEQ_VENDOR_ID.NEXTVAL, 'Havells India Ltd',        'Sanjay Tiwari', '9988776658', 'projects@havells.com',   'Sector 59, Noida',            'Noida',     'Electrical',  '09AABCH3456T', 'Net 30 days',   4.6, 'Active', SYSTIMESTAMP);
INSERT INTO Vendors VALUES (SEQ_VENDOR_ID.NEXTVAL, 'Stone Italia (Imports)',   'Priti Jain',    '9988776659', 'info@stoneitalia.in',    'Mahim West, Mumbai',          'Mumbai',    'Marble',      '27AABCS4567U', 'Advance 70%',   4.9, 'Active', SYSTIMESTAMP);
INSERT INTO Vendors VALUES (SEQ_VENDOR_ID.NEXTVAL, 'Merino Laminates',         'Deepak Rao',    '9988776660', 'sales@merinolam.com',    'Baddi Industrial Area',       'Himachal',  'Laminates',   '02AABCM5678V', 'Net 30 days',   4.1, 'Active', SYSTIMESTAMP);
INSERT INTO Vendors VALUES (SEQ_VENDOR_ID.NEXTVAL, 'Finolex Cables',           'Ramesh Nair',   '9988776661', 'projects@finolex.com',   'Pimpri-Chinchwad, Pune',      'Pune',      'Electrical',  '27AABCF6789W', 'Net 30 days',   4.4, 'Active', SYSTIMESTAMP);
INSERT INTO Vendors VALUES (SEQ_VENDOR_ID.NEXTVAL, 'Supreme Sanitaryware',     'Kavita Singh',  '9988776662', 'trade@supreme-san.com',  'Chhattisgarh',                'Raipur',    'Plumbing',    '22AABCS7890X', 'Advance 30%',   3.8, 'Active', SYSTIMESTAMP);

COMMIT;

-- ================================================================
-- TABLE 10: MATERIAL_ORDERS
-- ================================================================
INSERT INTO Material_Orders VALUES (SEQ_ORDER_ID.NEXTVAL, 7001, 8002, 9001, 'Vitrified Floor Tiles 800x800 (Ivory)',    'Tiles',      700,  'Sqft', 250,  175000, DATE '2026-09-05', DATE '2026-09-12', DATE '2026-09-13', 'Delivered',   'INV-KAJ-2289', '1 day late',  SYSTIMESTAMP);
INSERT INTO Material_Orders VALUES (SEQ_ORDER_ID.NEXTVAL, 7001, 8003, 9002, 'Asian Paints Royale - Off White 20L',      'Paint',      15,   'Nos',  4200, 63000,  DATE '2026-10-10', DATE '2026-10-20', NULL,             'Ordered',     NULL,           NULL,          SYSTIMESTAMP);
INSERT INTO Material_Orders VALUES (SEQ_ORDER_ID.NEXTVAL, 7001, 8004, 9006, 'Merino Laminate Sheets - 1mm Sand Oak',    'Laminates',  50,   'Nos',  1800, 90000,  DATE '2026-10-15', DATE '2026-10-22', NULL,             'Ordered',     NULL,           NULL,          SYSTIMESTAMP);
INSERT INTO Material_Orders VALUES (SEQ_ORDER_ID.NEXTVAL, 7002, 8007, 9003, 'Godrej Interio L-Shape Workstation Set',   'Furniture',  20,   'Nos',  35000,700000, DATE '2026-09-01', DATE '2026-09-20', NULL,             'Delayed',     NULL,           'Production delay at factory', SYSTIMESTAMP);
INSERT INTO Material_Orders VALUES (SEQ_ORDER_ID.NEXTVAL, 7002, 8006, 9001, 'Armstrong Grid False Ceiling Tiles',        'Ceiling',    3600, 'Sqft', 180,  648000, DATE '2026-08-20', DATE '2026-09-01', DATE '2026-09-01','Delivered',   'INV-KAJ-2301', NULL,          SYSTIMESTAMP);
INSERT INTO Material_Orders VALUES (SEQ_ORDER_ID.NEXTVAL, 7003, 8012, 9005, 'Italian Botticino Marble 600x600',          'Marble',     2500, 'Sqft', 1800, 4500000,DATE '2026-09-10', DATE '2026-09-30', NULL,             'In Transit',  NULL,           'Customs clearance pending', SYSTIMESTAMP);
INSERT INTO Material_Orders VALUES (SEQ_ORDER_ID.NEXTVAL, 7005, 8022, 9005, 'Statuario White Marble Slabs',              'Marble',     1800, 'Sqft', 2200, 3960000,DATE '2026-09-15', DATE '2026-10-05', NULL,             'Ordered',     NULL,           NULL,          SYSTIMESTAMP);
INSERT INTO Material_Orders VALUES (SEQ_ORDER_ID.NEXTVAL, 7004, 8017, 9004, 'Havells Concealed Wiring 4mm sq 90m',       'Electrical', 10,   'Roll', 3200, 32000,  DATE '2026-08-01', DATE '2026-08-07', DATE '2026-08-07','Delivered',   'INV-HAV-0091', NULL,          SYSTIMESTAMP);

COMMIT;

-- ================================================================
-- TABLE 11: SITE_UPDATES
-- ================================================================
INSERT INTO Site_Updates VALUES (SEQ_SITE_UPDATE_ID.NEXTVAL, 7001, 8001, DATE '2026-09-02', 'Rahul Sharma',    'Demolition started. Old flooring removed in living room and kitchen.', 'Dust settling near window sills', 6, 'site_7001_02Sep.jpg', 'Clear',   'Continue demolition in bedrooms', SYSTIMESTAMP);
INSERT INTO Site_Updates VALUES (SEQ_SITE_UPDATE_ID.NEXTVAL, 7001, 8001, DATE '2026-09-08', 'Rahul Sharma',    'Demolition 95% complete. Debris removed. Site ready for civil work.',   NULL,                              8, 'site_7001_08Sep.jpg', 'Clear',   'Start floor leveling tomorrow',   SYSTIMESTAMP);
INSERT INTO Site_Updates VALUES (SEQ_SITE_UPDATE_ID.NEXTVAL, 7001, 8002, DATE '2026-09-15', 'Site Supervisor', 'Floor leveling done. Tiling started in living room - 200 sqft done.', NULL,                              10,'site_7001_15Sep.jpg', 'Cloudy',  'Continue tiling - dining area',   SYSTIMESTAMP);
INSERT INTO Site_Updates VALUES (SEQ_SITE_UPDATE_ID.NEXTVAL, 7001, 8002, DATE '2026-09-22', 'Site Supervisor', 'Tiling 65% complete. Living + dining done. Bedroom 1 in progress.',   'Grout colour mismatch in corner - will redo', 10, 'site_7001_22Sep.jpg', 'Clear', 'Bedroom 2 tiling + kitchen slab', SYSTIMESTAMP);
INSERT INTO Site_Updates VALUES (SEQ_SITE_UPDATE_ID.NEXTVAL, 7002, 8006, DATE '2026-09-05', 'Priya Nair',      'False ceiling grid installation 60% complete. 2100 sqft done.',        'Ceiling height variation in corner zone', 12,'site_7002_05Sep.jpg','Clear', 'Complete false ceiling tomorrow', SYSTIMESTAMP);
INSERT INTO Site_Updates VALUES (SEQ_SITE_UPDATE_ID.NEXTVAL, 7002, 8007, DATE '2026-10-05', 'Priya Nair',      'Workstation delivery pending from Godrej. Electrical rough-in done.',  'Vendor delivery delayed by 3 weeks',       8, 'site_7002_05Oct.jpg','Clear', 'Follow up with vendor urgently',  SYSTIMESTAMP);
INSERT INTO Site_Updates VALUES (SEQ_SITE_UPDATE_ID.NEXTVAL, 7003, 8013, DATE '2026-10-10', 'Aditya Verma',    'Italian marble awaited. Started washroom tiling with local granite.',  'Import marble stuck at Mumbai port',       15,'site_7003_10Oct.jpg','Rainy', 'Continue washroom work',          SYSTIMESTAMP);
INSERT INTO Site_Updates VALUES (SEQ_SITE_UPDATE_ID.NEXTVAL, 7005, 8022, DATE '2026-10-08', 'Rahul Sharma',    'Floor polishing 40% done. Marble installation ongoing in foyer.',      NULL,                              20,'site_7005_08Oct.jpg', 'Clear',   'Continue foyer and living area',  SYSTIMESTAMP);

COMMIT;

-- ================================================================
-- TABLE 12: MILESTONE_INVOICES
-- (auto-created by trigger for complete milestones; manually inserted here for seed data)
-- ================================================================
-- Invoice for Project 7001, Milestone 1 (Demolition - Complete)
INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8001, 7001, 2001,
    'INV-7001-M1', DATE '2026-09-10', DATE '2026-09-25',
    1345200, 10, 134520, 18, 24213.60, 158733.60,
    'Paid', DATE '2026-09-20', 158733.60, 'Milestone 1 completed - paid on time', SYSTIMESTAMP);

-- Invoice for Project 7002, Milestone 1 (Site Measurement - Complete)
INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8006, 7002, 2002,
    'INV-7002-M1', DATE '2026-08-25', DATE '2026-09-10',
    4350200, 5, 217510, 18, 39151.80, 256661.80,
    'Paid', DATE '2026-09-05', 256661.80, 'Advance milestone paid', SYSTIMESTAMP);

-- Invoice for Project 7002, Milestone 2 (Civil & False Ceiling - Complete)
INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8007, 7002, 2002,
    'INV-7002-M2', DATE '2026-09-23', DATE '2026-10-08',
    4350200, 25, 1087550, 18, 195759, 1283309,
    'Unpaid', NULL, 0, 'Awaiting client payment', SYSTIMESTAMP);

-- Invoice for Project 7003, Milestone 1 (Design Finalization - Complete)
INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8012, 7003, 2003,
    'INV-7003-M1', DATE '2026-09-05', DATE '2026-09-20',
    8673000, 5, 433650, 18, 78057, 511707,
    'Paid', DATE '2026-09-15', 511707, NULL, SYSTIMESTAMP);

-- Invoices for completed Project 7004 (all 4 milestones)
INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8017, 7004, 2004,
    'INV-7004-M1', DATE '2026-07-29', DATE '2026-08-13',
    1888000, 10, 188800, 18, 33984, 222784,
    'Paid', DATE '2026-08-10', 222784, NULL, SYSTIMESTAMP);

INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8018, 7004, 2004,
    'INV-7004-M2', DATE '2026-08-20', DATE '2026-09-04',
    1888000, 25, 472000, 18, 84960, 556960,
    'Paid', DATE '2026-08-30', 556960, NULL, SYSTIMESTAMP);

INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8019, 7004, 2004,
    'INV-7004-M3', DATE '2026-09-17', DATE '2026-10-02',
    1888000, 40, 755200, 18, 135936, 891136,
    'Paid', DATE '2026-09-30', 891136, NULL, SYSTIMESTAMP);

INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8020, 7004, 2004,
    'INV-7004-M4', DATE '2026-10-11', DATE '2026-10-26',
    1888000, 25, 472000, 18, 84960, 556960,
    'Paid', DATE '2026-10-20', 472000, 'Final payment received', SYSTIMESTAMP);

-- Invoice for Project 7005, Milestone 1 & 2 (Complete)
INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8021, 7005, 2005,
    'INV-7005-M1', DATE '2026-07-19', DATE '2026-08-03',
    11328000, 5, 566400, 18, 101952, 668352,
    'Paid', DATE '2026-07-28', 668352, NULL, SYSTIMESTAMP);

INSERT INTO Milestone_Invoices VALUES (SEQ_INVOICE_ID.NEXTVAL, 8022, 7005, 2005,
    'INV-7005-M2', DATE '2026-09-03', DATE '2026-09-18',
    11328000, 15, 1699200, 18, 305856, 2005056,
    'Partially Paid', NULL, 1000000, 'Partial payment received; balance pending', SYSTIMESTAMP);

COMMIT;

-- ================================================================
-- VERIFY ROW COUNTS
-- ================================================================
SELECT 'DESIGNERS'          AS table_name, COUNT(*) AS row_count FROM Designers          UNION ALL
SELECT 'LEADS',                            COUNT(*)              FROM Leads               UNION ALL
SELECT 'CUSTOMERS',                        COUNT(*)              FROM Customers           UNION ALL
SELECT 'QUOTATIONS',                       COUNT(*)              FROM Quotations          UNION ALL
SELECT 'QUOTATION_REVISIONS',              COUNT(*)              FROM Quotation_Revisions UNION ALL
SELECT 'QUOTATION_ITEMS',                  COUNT(*)              FROM Quotation_Items     UNION ALL
SELECT 'PROJECTS',                         COUNT(*)              FROM Projects            UNION ALL
SELECT 'MILESTONES',                       COUNT(*)              FROM Milestones          UNION ALL
SELECT 'VENDORS',                          COUNT(*)              FROM Vendors             UNION ALL
SELECT 'MATERIAL_ORDERS',                  COUNT(*)              FROM Material_Orders     UNION ALL
SELECT 'SITE_UPDATES',                     COUNT(*)              FROM Site_Updates        UNION ALL
SELECT 'MILESTONE_INVOICES',               COUNT(*)              FROM Milestone_Invoices;

-- ============================================================
-- END OF SCRIPT 02_DML_Sample_Data.sql
-- ============================================================
