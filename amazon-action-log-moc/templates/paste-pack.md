# Paste pack — first user message for any LLM

1. Set system prompt from `prompts/00-system.md`.
2. Copy everything below into the chat.
3. Replace bracketed placeholders / example rows with your data.
4. Send, then run `prompts/05-full-brief.md` (or prompts 01→04).

---

```text
# Amazon Action Log Intelligence Pack

## Context
- Seller / brand: [BRAND]
- Marketplace: [US / UK / DE / ...]
- Analysis window: [YYYY-MM-DD] → [YYYY-MM-DD]
- Goal: inspect ALL own listing actions and compare to top competitors; recommend ≤5 next actions.
- Hero own ASINs: [B0..., B0...]

## OWN_ACTION_LOG (YAML or table)
marketplace: US
window_start: YYYY-MM-DD
window_end: YYYY-MM-DD
actions:
  - timestamp: 2026-04-01T14:22:00Z
    asin: B0XXXXXXXX
    sku: SKU-1
    actor: you@brand.com
    action_type: price
    field: list_price
    before: 29.99
    after: 27.99
    source: seller_central_action_log
    notes: ""
  # add all rows...

metrics:
  - asin: B0XXXXXXXX
    buy_box_pct: 82
    sessions: 4100
    unit_session_pct: 12.4
    ordered_units: 508

## COMPETITOR_WATCHLIST
watchlist:
  - asin: B0AAAAAAAA
    brand: BrandA
    maps_to_own_asin: B0XXXXXXXX
    why_peer: same main keyword, similar feature set
    price_band: 25-35
  - asin: B0BBBBBBBB
    brand: BrandB
    maps_to_own_asin: B0XXXXXXXX
    why_peer: page-1 overlap
    price_band: 25-35
  - asin: B0CCCCCCCC
    brand: BrandC
    maps_to_own_asin: B0XXXXXXXX
    why_peer: coupon aggressor
    price_band: 22-30

signals:
  - timestamp: 2026-04-02T09:00:00Z
    asin: B0AAAAAAAA
    signal_type: price_change
    before: 29.99
    after: 24.99
    source: keepa
    confidence: high
    notes: undercut after our price drop
  # add all rows...

## Constraints
- Do not invent missing numbers; mark unknown.
- Separate OWN vs COMPETITOR evidence.
- Use severity P0–P3.
- End with ≤5 actions in:
  [P#] ASIN | action | owner_role | deadline | success_metric
```
