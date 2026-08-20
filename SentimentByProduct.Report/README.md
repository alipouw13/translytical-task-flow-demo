# Report (PBIR)

Two pages, dark navy / teal theme, with the data function button that drives the writeback.

| Page | Purpose |
| --- | --- |
| Product Reviews Sentiment | KPIs, sentiment split by product, full review detail |
| Employee Product Ownership | Review selection, comment input, **Submit** button |

## The button

`SentimentByProduct.Report/definition/pages/95eee6190be6f8d348af/visuals/25384b33804bc9d07bf9/visual.json`

Its action is stored under `visualContainerObjects.visualLink` and holds an explicit reference to a
workspace and user data function. **It does not rebind automatically** when the report moves to a
different workspace — re-pick the workspace and function after deploying, then check the four
parameter bindings.

## Theme

`StaticResources/RegisteredResources/TransanalyticalDark.json`, registered from `definition/report.json`.

A custom theme only loads when **all three** of these match exactly, including the `.json` extension:

- `themeCollection.customTheme.name`
- the resource package item `name`
- the item `path`

Get one wrong and Power BI silently falls back to the base theme with no error.

## Editing formatting

Visual formatting objects are **not** schema-validated on upload. Setting a property that doesn't
exist for that visual type is accepted by the API and then breaks the visual at render time (it
appears as an error tile with a "See details" link). Only set properties that already exist on that
visual, or copy the shape of an existing entry.

