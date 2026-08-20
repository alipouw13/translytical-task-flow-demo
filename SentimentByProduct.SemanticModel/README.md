# Semantic model (TMDL)

Eight tables, **DirectQuery** over the Fabric SQL database. DirectQuery is what makes the writeback
appear instantly — switch to Import and the report shows stale data until the next refresh.

## Relationships

| From (many) | To (one) | Cross-filter |
| --- | --- | --- |
| `Product Reviews[ProductID]` | `Products[ProductID]` | single |
| `Product Review Feedback[ReviewID]` | `Product Reviews[ReviewID]` | **both** |
| `Product Review Feedback[employee_ID]` | `Employees[employee_ID]` | single |
| `Assigned Products[employee_ID]` | `Employees[employee_ID]` | single |
| `Assigned Products[ProductID]` | `Products[ProductID]` | single |
| `Products[ProductModelID]` | `Product Model[ProductModelID]` | single |
| `Product Model Description[ProductModelID]` | `Product Model[ProductModelID]` | single |
| `Product Model Description[ProductDescriptionID]` | `Product Description[ProductDescriptionID]` | single |

Keep the writeback table (`Product Review Feedback`) on the **many** side. A one-to-one relationship
demands permanent uniqueness on both sides, and the writeback table is the one that changes.

## Measures

| Measure | Table | Expression |
| --- | --- | --- |
| `Reviews` | Product Reviews | `COUNTROWS('Product Reviews')` |
| `Products` | Products | `COUNTROWS(Products)` |
| `Responded` | Product Review Feedback | `SUMX(...)` over non-blank `employee_comments` |
| `Selected ReviewID` | Product Review Feedback | `SELECTEDVALUE('Product Review Feedback'[ReviewID])` |
| `Selected EmployeeID` | Product Review Feedback | `SELECTEDVALUE('Product Review Feedback'[employee_ID])` |
| `Selected ProductID` | Product Review Feedback | `SELECTEDVALUE('Product Review Feedback'[ProductID])` |

The three `Selected ...` measures exist so the button's parameters resolve from any selection. They
read the writeback table directly rather than depending on a filter path reaching a dimension table.

## Connection

Each table's partition uses:

```
Sql.Database("<SQL_SERVER_FQDN>,1433", "<SQL_DATABASE_NAME>")
```

Run `scripts/Set-Environment.ps1` to substitute your own values, then set data source credentials in
the semantic model settings after publishing.
