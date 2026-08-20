# SQL

Run in order against your Fabric SQL database:

1. **`01-create-tables.sql`** — creates the four demo tables.
2. **`02-seed-data.sql`** — loads sample data.

## Prerequisite

The database must already contain the **AdventureWorksLT** sample data. Both scripts reference
`SalesLT.Product`, and the semantic model also reads `SalesLT.ProductModel`,
`SalesLT.ProductDescription` and `SalesLT.ProductModelProductDescription`.

## Tables

| Table | Role | Rows seeded |
| --- | --- | --- |
| `dbo.employees` | Product owners who respond to reviews | 20 |
| `dbo.Employee_Assigned_Products` | Which employee owns which product | 295 |
| `dbo.product_reviews` | Customer reviews (read-only in the report) | 30 |
| `dbo.product_review_feedback` | **Writeback target** — one row per review | 30 |

`product_review_feedback.employee_comments` is seeded as `NULL` on purpose. It is populated by the
user data function when someone submits a response from the report, and `updated_date` is stamped at
the same time.

`ReviewID` is the primary key on the feedback table: exactly one feedback row per review. Keep that
constraint — the semantic model relates the two tables on `ReviewID`, and the function's `UPDATE`
is written to affect a single row.
