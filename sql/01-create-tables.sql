/* ---------------------------------------------------------------------------
   01-create-tables.sql
   Schema for the translytical task flow demo.

   Prerequisite: a Fabric SQL database created with the AdventureWorksLT sample
   data. That supplies SalesLT.Product / ProductModel / ProductDescription /
   ProductModelProductDescription, which the semantic model also uses. The four
   tables below are the demo-specific additions.

   Run this first, then 02-seed-data.sql.
   --------------------------------------------------------------------------- */

SET NOCOUNT ON;
GO

/* Employees who own products and respond to reviews ------------------------ */
IF OBJECT_ID('dbo.employees', 'U') IS NOT NULL DROP TABLE dbo.employees;
GO
CREATE TABLE dbo.employees
(
    employee_ID int           IDENTITY(1,1) NOT NULL,
    FirstName   varchar(100)  NULL,
    LastName    varchar(100)  NULL,
    JobTitle    nvarchar(50)  NOT NULL,
    CONSTRAINT PK_employees PRIMARY KEY CLUSTERED (employee_ID)
);
GO

/* Which employee owns which product --------------------------------------- */
IF OBJECT_ID('dbo.Employee_Assigned_Products', 'U') IS NOT NULL DROP TABLE dbo.Employee_Assigned_Products;
GO
CREATE TABLE dbo.Employee_Assigned_Products
(
    Emp_Assigned_Pdct_ID int IDENTITY(1,1) NOT NULL,
    employee_ID          int NOT NULL,
    ProductID            int NOT NULL,
    CONSTRAINT PK_Employee_Assigned_Products PRIMARY KEY CLUSTERED (Emp_Assigned_Pdct_ID),
    CONSTRAINT FK_EAP_employee FOREIGN KEY (employee_ID) REFERENCES dbo.employees (employee_ID),
    CONSTRAINT FK_EAP_product  FOREIGN KEY (ProductID)   REFERENCES SalesLT.Product (ProductID)
);
GO
CREATE INDEX IX_EAP_employee ON dbo.Employee_Assigned_Products (employee_ID);
CREATE INDEX IX_EAP_product  ON dbo.Employee_Assigned_Products (ProductID);
GO

/* Customer reviews (read-only in the report) ------------------------------- */
IF OBJECT_ID('dbo.product_reviews', 'U') IS NOT NULL DROP TABLE dbo.product_reviews;
GO
CREATE TABLE dbo.product_reviews
(
    ReviewID       int            IDENTITY(1,1) NOT NULL,
    ProductID      int            NOT NULL,
    ReviewText     nvarchar(max)  NULL,
    SentimentLabel varchar(10)    NULL,   -- Positive | Neutral | Negative
    CreatedAt      datetime       NULL,
    CONSTRAINT PK_product_reviews PRIMARY KEY CLUSTERED (ReviewID),
    CONSTRAINT FK_reviews_product FOREIGN KEY (ProductID) REFERENCES SalesLT.Product (ProductID)
);
GO
CREATE INDEX IX_reviews_product ON dbo.product_reviews (ProductID);
GO

/* -----------------------------------------------------------------------------
   THE WRITEBACK TARGET
   One row per review. employee_comments starts NULL and is filled in by the
   user data function when someone submits a response from the Power BI report.

   ReviewID is the primary key: exactly one feedback row per review. Keep this
   constraint - the semantic model relates this table to Product Reviews on
   ReviewID, and the function's UPDATE targets a single row.
   ----------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.product_review_feedback', 'U') IS NOT NULL DROP TABLE dbo.product_review_feedback;
GO
CREATE TABLE dbo.product_review_feedback
(
    ProductID         int           NOT NULL,
    ReviewID          int           NOT NULL,
    employee_ID       int           NOT NULL,
    employee_comments varchar(max)  NULL,   -- written back from the report
    resolution        varchar(max)  NULL,
    created_date      datetime      NULL CONSTRAINT DF_prf_created DEFAULT (GETDATE()),
    updated_date      datetime      NULL,   -- stamped by the function on each write
    CONSTRAINT PK_product_review_feedback PRIMARY KEY CLUSTERED (ReviewID),
    CONSTRAINT FK_prf_review   FOREIGN KEY (ReviewID)    REFERENCES dbo.product_reviews (ReviewID),
    CONSTRAINT FK_prf_employee FOREIGN KEY (employee_ID) REFERENCES dbo.employees (employee_ID),
    CONSTRAINT FK_prf_product  FOREIGN KEY (ProductID)   REFERENCES SalesLT.Product (ProductID)
);
GO
CREATE INDEX IX_prf_employee ON dbo.product_review_feedback (employee_ID);
CREATE INDEX IX_prf_product  ON dbo.product_review_feedback (ProductID);
GO

PRINT 'Schema created.';
GO
