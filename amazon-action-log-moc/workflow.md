# Operating workflow

## One-time setup

1. Pick marketplaces and your hero ASINs (start with 1–3).
2. Build a competitor watchlist of 3–5 ASINs per hero ASIN (same category, overlapping keywords, similar price band).
3. Decide your lookback window (default: **14 days**, plus **48h reaction window** after each major own change).
4. Paste `prompts/00-system.md` into the LLM’s system / custom instructions.

## Recurring loop

```text
Export → Normalize → Compare → Decide → Log decision
```

### 1. Export

| Side | Pull |
|------|------|
| Own | Seller Central Action / Activity Log, pricing history, inventory edits, content publish events |
| Competitor | Keepa / Helium 10 / SellerSprite alerts, or manual notes: price, coupon, title, images, A+, reviews, BSR, stock |

### 2. Normalize

Map raw rows into:

- `schemas/own-action-log.schema.json`
- `schemas/competitor-signals.schema.json`

Or fill markdown templates under `templates/` if you prefer pasteable prose.

### 3. Compare

Run prompts in order (or `05-full-brief` for a one-shot):

1. Ingest / validate
2. Own timeline
3. Competitor compare
4. Threat + response plan

### 4. Decide

Every brief must end with **max 5 actions**, each with:

- owner (you / VA / agency)
- ASIN
- action type
- deadline
- success metric (BB%, CVR, rank, margin)

### 5. Log the decision

Append a short note to your paste pack or notes:

```text
DECISION | 2026-04-10 | ASIN B0XXXX | match competitor coupon 10% for 7d | owner: you | review: 2026-04-17
```

## Severity rubric (use in every prompt)

| Level | Meaning |
|-------|---------|
| P0 | Active Buy Box loss, OOS, suppressed listing, major price undercut on hero ASIN |
| P1 | Competitor content/price move likely to steal conversion this week |
| P2 | Watch — drift in reviews, BSR, or secondary fields |
| P3 | Noise / seasonal / irrelevant ASIN |

## Anti-patterns

- Dumping screenshots without dates or ASINs
- Mixing marketplaces in one pack without labels
- Comparing to “top sellers” outside your price/feature band
- Asking the LLM for strategy without pasting the action log
