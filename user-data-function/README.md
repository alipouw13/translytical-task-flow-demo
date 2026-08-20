# User data function

`write_emp_info_on_product_Review` — the writeback half of the translytical task flow.

| File | Purpose |
| --- | --- |
| `function_app.py` | The function. Deploy this one. |
| `function_app.original.py` | First-draft version, kept to illustrate the `rowcount` bug |
| `definition.json` | Item definition: Python runtime, SQL connection, published functions |
| `.platform` | Fabric item metadata |

## Parameters

| Parameter | Type | Supplied by |
| --- | --- | --- |
| `productid` | `int` | `[Selected ProductID]` measure |
| `ReviewID` | `int` | `[Selected ReviewID]` measure |
| `EmployeeID` | `int` | `[Selected EmployeeID]` measure |
| `employeeComments` | `str` | comment text slicer |

All four are required, so the Power BI button stays disabled until the report can supply every one.
The return type is `str` — a Power BI data function button will not accept a function that returns
anything else.

## Connection

`definition.json` declares a connected data source with alias **`SQLDemo2026`**, which must match the
`alias` in the `@udf.connection` decorator. If you name your connection differently, change it in
both places.

## Why the original is kept

`function_app.original.py` commits and returns `"Employee has inserted comments"` regardless of
whether the `UPDATE` matched anything. When the report bindings broke, it kept reporting success
while writing nothing — the failure was invisible for two weeks. The deployable version checks
`cursor.rowcount`, rolls back and raises a `UserThrownError` so the report shows a real message.

## Testing without the report

```powershell
$token = az account get-access-token --resource https://api.fabric.microsoft.com --query accessToken -o tsv
$uri = "https://api.fabric.microsoft.com/v1/workspaces/<WORKSPACE_ID>/userDataFunctions/<USER_DATA_FUNCTION_ID>/functions/write_emp_info_on_product_Review/invoke"
$body = @{ productid = 774; ReviewID = 21; EmployeeID = 10; employeeComments = 'test' } | ConvertTo-Json
Invoke-RestMethod -Uri $uri -Method Post -Body $body -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json'
```

Use `productid` / `ReviewID` / `EmployeeID` values that exist together in one
`dbo.product_review_feedback` row, otherwise the hardened function correctly refuses the write.
