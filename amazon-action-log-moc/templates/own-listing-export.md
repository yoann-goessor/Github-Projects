# Own listing action log (fill this)

```yaml
marketplace: US # or ATVPDKIKX0DER
window_start: YYYY-MM-DD
window_end: YYYY-MM-DD
own_asins:
  - ASIN: B0XXXXXXXX
    sku: YOUR-SKU
    title_short: "short product name"
```

## Actions (one row per change)

| timestamp (ISO) | asin | sku | actor | action_type | field | before | after | source | notes |
|-----------------|------|-----|-------|-------------|-------|--------|-------|--------|-------|
| 2026-04-01T14:22:00Z | B0XXXXXXXX | SKU-1 | you@brand.com | price | list_price | 29.99 | 27.99 | seller_central_action_log | matched promo week |
| | | | | | | | | | |

## Optional metrics (same window)

| asin | buy_box_pct | sessions | unit_session_pct | ordered_units | notes |
|------|-------------|----------|------------------|---------------|-------|
| B0XXXXXXXX | 82 | 4100 | 12.4 | 508 | |
