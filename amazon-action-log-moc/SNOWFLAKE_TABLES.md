# Snowflake tables found (from warehouse column dump)

Source: screenshot of `INFORMATION_SCHEMA`-style result  
Catalog: **`ANALYTICS`**  
Note: no `SMART.PHOENIX` / `PHOENIX` schema appeared in this dump. Closest “product intelligence” schema is **`RIGEL`** (plus `ANALYTICS.AMAZON` Seller Central feeds).

OCR truncated some names; stems below are recovered from the image. Confirm exact names with:

```sql
SHOW TABLES IN SCHEMA ANALYTICS.AMAZON;
SHOW TABLES IN SCHEMA ANALYTICS.RIGEL;
SHOW TABLES IN SCHEMA ANALYTICS.STAGING;
```

## Schemas present

| Schema | Role (inferred) |
|--------|-----------------|
| `AMAZON` | Seller Central / Daton Amazon feeds |
| `STAGING` | Staging copies of Amazon + ads |
| `RIGEL` | Ops / SCS account metrics / brand replenishment |
| `NETSUITE` | ERP inventory / item master |
| `PUBLIC` / `PUBLIC1` | Shared brand / inventory reports |
| `GOOGLE_*` | Google Ads |
| `SHOPIFY_*` | Shopify |
| `REPORTS` / `RAW_LOG` / `DATALAKE` / `COMMON` | Audits, reports, shared |

## Tables / stems in `ANALYTICS.AMAZON`

| Stem (OCR) | Likely full name | Useful for MOC? |
|------------|------------------|-----------------|
| `ADS_SPONSORED_*` | Sponsored Products ads | Ad pressure context |
| `ADVERTISING_*` | Ads performance | Ad spend / units |
| `AMAZON_*` | Generic Amazon feed tables | Maybe |
| `ORDERS_C/E/F/L/P/R/S` | Order report variants | Own sales volume |
| `INVENTORY_*` | FBA inventory | Own stock actions |
| `FEE_PREVIEW_*` | Fee preview | Margin, not listing actions |
| `FBA_RETURNS_*` | Returns | Secondary |
| `SETTLEMENT_*` | Settlements | Finance |
| `RECEIVED_*` | Received inventory | Inbound |
| `UNIFIED_*` | Unified Amazon view | Maybe |
| `AUDIT_DB*` | Pipeline audit | Not listing audit |
| `NETSUITE_*` | Amazon↔NetSuite bridge | SKU map |

## Tables / stems in `ANALYTICS.RIGEL` (highest value for this use case)

| Stem | Columns seen in dump | Use |
|------|----------------------|-----|
| **`SCS_ACCOUNT_*`** | `ACCOUNT`, `CHILD_ASIN`, `PARENT_ASIN`, `SKU`, `MARKETPLACE`, `COUNTRY`, `SNAPSHOT_DATE`, `BUY_BOX_%`, `SESSIONS`, `PAGE_VIEWS`, `UNIT_SESSION_%`, `ORDERED_UNITS`, `TOTAL_ORDER_ITEMS`, `CRAWL_ID`, `RIGEL_INGESTED_AT` | **Own metrics** (BB%, traffic, CVR) |
| `BRAND_RE*` | inventory / OOS / weeks of cover style fields | Ops health |
| `OPERATIONS_*` | partner, snapshot | Ops |
| `SUPPLIER_*` | supplier, sku, qty, snapshot | Supply |

## Staging mirrors

`STAGING` also has: `ADVERTISING_*`, `AMAZON_*`, `BRAND_IN*`, `BRAND_OI*`, `FEE_PREVIEW_*`, `INVENTORY_*`, `GA_ADVER*`, `BILL_INFO`, `ADDITIONS_*`.

## Mapping to MOC data points

| Needed data point | Best table(s) from this dump | Status |
|-------------------|------------------------------|--------|
| Own Buy Box % | `RIGEL.SCS_ACCOUNT_*` (`BUY_BOX_*`) | Found |
| Own sessions / page views / unit session % / ordered units | `RIGEL.SCS_ACCOUNT_*` | Found |
| Own inventory level changes | `AMAZON.INVENTORY_*` (+ staging) | Found (levels, not full action audit) |
| Own orders / units | `AMAZON.ORDERS_*` | Found |
| Own ads | `AMAZON.ADS_SPONSORED_*`, `ADVERTISING_*` | Found |
| Own listing **content/price action log** (who changed title/images/price) | — | **MISSING in this dump** |
| Competitor ASIN watchlist | — | **MISSING** |
| Competitor price / coupon / content / BSR / reviews | — | **MISSING** |

## Practical SQL starting points

### Own metrics pack (from Rigel SCS)

```sql
SELECT *
FROM ANALYTICS.RIGEL.SCS_ACCOUNT -- confirm exact table name
WHERE snapshot_date BETWEEN :start AND :end
  AND child_asin IN (:hero_asins)
ORDER BY snapshot_date, child_asin;
```

### Own inventory snapshots

```sql
SELECT *
FROM ANALYTICS.AMAZON.INVENTORY -- confirm exact table name
WHERE /* date column */ BETWEEN :start AND :end
ORDER BY 1;
```

### Discover exact names

```sql
SELECT table_schema, table_name
FROM ANALYTICS.INFORMATION_SCHEMA.TABLES
WHERE table_schema IN ('AMAZON','RIGEL','STAGING')
ORDER BY 1,2;
```

## Gaps to chase next

Ask your data team / search Snowflake for tables matching:

```sql
SELECT table_schema, table_name
FROM ANALYTICS.INFORMATION_SCHEMA.TABLES
WHERE table_name ILIKE ANY (
  '%LISTING%','%CATALOG%','%CONTENT%','%COMPETITOR%','%KEEPA%',
  '%BUYBOX%','%BUY_BOX%','%PRICE_HISTORY%','%ASIN_SNAPSHOT%',
  '%ACTION%','%AUDIT_LOG%','%PHOENIX%'
)
ORDER BY 1,2;
```

Without those, Phoenix/Rigel can power **own performance + inventory + ads**, but not a true **listing action log vs competitor moves** brief.
