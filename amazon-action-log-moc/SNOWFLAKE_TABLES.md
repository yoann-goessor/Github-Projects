# Snowflake tables for Amazon action-log MOC

## What’s in the dump you shared

Catalog: **`ANALYTICS`** only (screenshot truncated at PNG max height).

**No hits** for: `PHOENIX`, `CATALOG`, `PDP`, `SCRAP%`, `KEEPA`, `COMPET%`, `LISTING`, `CONTENT`, `REVIEW`, `BSR`, `KEYWORD`, `TRAFFIC`, `PRICE_HIST`.

### Closest “scraper” signal present

| Table stem | Schema | Why it matters |
|------------|--------|----------------|
| **`SCS_ACCOUNT_*`** | `RIGEL` | Has `CRAWL_ID`, `SNAPSHOT_DATE`, `CHILD_ASIN`/`PARENT_ASIN`, `BUY_BOX_%`, `SESSIONS`, `PAGE_VIEWS`, `UNIT_SESSION_%`, `ORDERED_UNITS` — **own-account SCS crawl**, not competitor PDP |

### Other useful tables present

| Stem | Schema | Use |
|------|--------|-----|
| `INVENTORY_*` | `AMAZON`, `STAGING` | Own stock snapshots (`SNAPSHOT` timestamp) |
| `ORDERS_*` (`C/E/F/L/P/R/S`) | `AMAZON` | Own order/units |
| `ADS_SPONSORED_*`, `ADVERTISING_*` | `AMAZON`, `STAGING` | Ad pressure |
| `FEE_PREVIEW_*`, `FBA_RETURNS_*`, `SETTLEMENT_*` | `AMAZON` | Finance/returns |
| `BRAND_RE*`, `BRAND_IN*`, `BRAND_OI*` | `RIGEL`, `PUBLIC`, `STAGING` | Brand inventory / ops |
| `ITEM_MASTER`, `ITEM_SALES` | `NETSUITE` | ASIN↔SKU map (`AMZ_ASIN`) |
| `OPERATIONS_*`, `SUPPLIER_*` | `RIGEL` | Ops snapshots |

These cover **own performance + inventory + ads**. They do **not** cover listing content action history or competitor PDP changes.

---

## Find catalog / PDP scraper tables (run this)

Your dump likely missed other databases or names. Run **unfiltered** across the account:

```sql
-- 1) Every table that looks like catalog / PDP / scrape / competitor
SELECT
  table_catalog,
  table_schema,
  table_name,
  row_count,
  comment
FROM snowflake.account_usage.tables
WHERE deleted IS NULL
  AND (
       table_catalog ILIKE ANY ('%PHOENIX%','%SMART%','%RAW%','%SCRAP%','%CRAWL%','%CATALOG%','%DATALAKE%','%ANALYTICS%')
    OR table_schema  ILIKE ANY ('%PHOENIX%','%SMART%','%SCRAP%','%CRAWL%','%CATALOG%','%PDP%','%COMPET%','%KEEPA%','%ASIN%','%MARKET%')
    OR table_name    ILIKE ANY (
         '%CATALOG%','%PDP%','%SCRAP%','%CRAWL%','%COMPET%','%KEEPA%',
         '%LISTING%','%CONTENT%','%PRODUCT_PAGE%','%ASIN_SNAP%','%PRICE_HIST%',
         '%BUYBOX%','%BUY_BOX%','%OFFER%','%REVIEW%','%RATING%','%BSR%',
         '%KEYWORD%','%SEARCH_TERM%','%SERP%','%WATCHLIST%','%PEER%'
       )
  )
ORDER BY table_catalog, table_schema, table_name;
```

```sql
-- 2) Columns that scream PDP scraper / listing change log
SELECT
  table_catalog,
  table_schema,
  table_name,
  column_name,
  data_type
FROM snowflake.account_usage.columns
WHERE deleted IS NULL
  AND column_name ILIKE ANY (
    '%TITLE%','%BULLET%','%IMAGE%','%A_PLUS%','%A+%','%BACKEND_KEYWORD%',
    '%LIST_PRICE%','%LANDED_PRICE%','%COUPON%','%BUY_BOX%',
    '%REVIEW_COUNT%','%RATING%','%BSR%','%BEST_SELLER%',
    '%CRAWL%','%SCRAP%','%SNAPSHOT%','%BEFORE%','%AFTER%',
    '%COMPETITOR%','%WATCHLIST%','%PEER_ASIN%'
  )
ORDER BY 1,2,3,4;
```

```sql
-- 3) Confirm exact Rigel SCS table name + columns
SHOW TABLES IN SCHEMA ANALYTICS.RIGEL;
DESCRIBE TABLE ANALYTICS.RIGEL.<scs_account_table>;
```

Paste the result of query **1** (and **2** if short) and we can map every MOC field to `database.schema.table.column`.

---

## Target mapping (once catalog/PDP tables exist)

| MOC need | Look for table patterns |
|----------|-------------------------|
| Own listing action log | `%LISTING%HISTORY%`, `%CATALOG%AUDIT%`, `%CONTENT%CHANGE%`, SP-API listings items changelog |
| Competitor PDP snapshots | `%PDP%`, `%SCRAP%`, `%CRAWL%ASIN%`, `%PRODUCT_PAGE%` |
| Competitor price/BB | `%PRICE%`, `%BUY_BOX%`, `%OFFER%`, `%FEATURED_OFFER%` |
| Reviews / BSR | `%REVIEW%`, `%RATING%`, `%BSR%` |
| Peer set | `%COMPETITOR%`, `%WATCHLIST%`, `%PEER%` |
| Own metrics (already found) | `ANALYTICS.RIGEL.SCS_ACCOUNT_*` |

---

## Prompt for another LLM with Snowflake access

```text
Search our Snowflake account for catalog + PDP scraper tables needed for:
1) own Amazon listing action log (title/bullets/images/A+/price/coupon/inventory changes with before/after)
2) competitor PDP signals (price, coupon, buy box, stock, title/images, reviews, BSR)

Run account_usage.tables / columns filters for:
CATALOG, PDP, SCRAP, CRAWL, COMPET, KEEPA, LISTING, CONTENT, BUY_BOX, PRICE_HIST, REVIEW, BSR, WATCHLIST.

Also include ANALYTICS.RIGEL.SCS_ACCOUNT* (own crawl metrics) and ANALYTICS.AMAZON.INVENTORY* / ORDERS*.

Return:
| data_point | catalog.schema.table | columns | grain |
plus one SQL that builds the LLM paste-pack for a date window + hero ASINs + competitor ASINs.

Do not invent tables — only evidenced names.
```
