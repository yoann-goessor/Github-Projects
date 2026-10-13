# Snowflake sources for spend + budget audit

Evidence sources:

1. **Ninja Amazon PPC UI footnotes** (live artifact family, Snowflake-backed)
2. **Prior ANALYTICS catalog dump** (OCR from Amazon Action Log MOC session)
3. **Not yet confirmed live** — anything marked *candidate* needs Phoenix verification

---

## Evidenced tables (high confidence)

### DWH — Ninja production facts

| Fully qualified name | Role for spend/budget audit | Evidence |
|----------------------|----------------------------|----------|
| `DWH.PROD.FACT_AMAZON_AD_ASINS` | Primary Amazon PPC fact at advertised-ASIN grain: spend, ACoS, campaign, type, weeks | Ninja footnote: “Source: `DWH.PROD.FACT_AMAZON_AD_ASINS`” |
| `DWH.RAW.RAW_AMC_PPC_SEARCH_TERM_NTB_ADHOC` | New-to-brand / search-term NTB for CAC | Ninja footnote: joined to fact **on campaign name** |

Implied grain from Ninja UI (not DESCRIBE’d yet):

- Brand / product (ASIN) / campaign / week
- Metrics: spend, ACoS, CAC, NTB customers, impressions/clicks likely present

### ANALYTICS — warehouse dump (stems; confirm exact names)

| Stem | Schema | Role |
|------|--------|------|
| `ADS_SPONSORED_*` | `ANALYTICS.AMAZON`, `ANALYTICS.STAGING` | Sponsored Products / Brands / Display raw-ish spend |
| `ADVERTISING_*` | `ANALYTICS.AMAZON`, `ANALYTICS.STAGING` | Broader advertising reports; `SPEND` / `SPEND_US` columns seen |
| `ORDERS_*` | `ANALYTICS.AMAZON` | Organic + attributed sales context for ACoS/ROAS |
| `GOOGLE_*` schemas / tables | `ANALYTICS` | Google Ads spend (cross-channel audit) |
| `MARKETING_*` | various | Candidate brand marketing ops / spend rollups |
| `ITEM_MASTER` / `ITEM_SALES` | `ANALYTICS.NETSUITE` | ASIN ↔ SKU / brand mapping |

No **budget** table was present in the truncated ANALYTICS dump. Budget targets are the main discovery gap.

---

## Audit field → source map

| Audit need | Preferred source | Status |
|------------|------------------|--------|
| Amazon PPC spend by ASIN / campaign / week | `DWH.PROD.FACT_AMAZON_AD_ASINS` | Evidenced |
| Campaign type (SP / SB / SBV / SD) | same fact (Ninja “Type” column) | Evidenced in UI |
| ACoS | same fact | Evidenced |
| NTB customers + CAC | fact ⨝ `DWH.RAW.RAW_AMC_PPC_SEARCH_TERM_NTB_ADHOC` on campaign name | Evidenced join |
| Search-term brand share | AMC / Brand Analytics tables (search discovery) | Candidate |
| Budget target (daily/weekly/monthly) by brand/channel/campaign | `%BUDGET%` / `%PACING%` / media-plan tables | **Missing — run discovery** |
| Out-of-budget / limited | Amazon ads budget usage reports | Candidate (`%OUT_OF_BUDGET%`, `%BUDGET_USAGE%`) |
| Meta / Google / DSP / retail media spend | channel facts or `ANALYTICS` ads schemas | Partial (Google stems only) |
| Brand ↔ ASIN hierarchy | NetSuite `ITEM_MASTER` or brand dim | Candidate |

---

## Databases to search in Phoenix

Prioritize in this order:

1. `DWH` — Ninja already reads `PROD` + `RAW`
2. `ANALYTICS` — Amazon + Google ads stems
3. Any `PHOENIX`, `SMART`, `MART`, `FINANCE`, `MEDIA` catalogs
4. `snowflake.account_usage.tables` for account-wide name search

---

## Gaps to close with Phoenix

1. Exact columns on `DWH.PROD.FACT_AMAZON_AD_ASINS`
2. Exact columns + grain on `DWH.RAW.RAW_AMC_PPC_SEARCH_TERM_NTB_ADHOC`
3. **Budget / media-plan / pacing** table names (none evidenced yet)
4. Non-Amazon channel facts (Meta, Google Ads, Amazon DSP, RMNs)
5. Brand / portfolio dimension for rollups across FreshCap and other brands