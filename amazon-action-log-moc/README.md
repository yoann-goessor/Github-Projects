# Amazon Action Log MOC (LLM-portable)

A Map of Content + prompt pack for analyzing **your Amazon listing action log** against **top competitors**, designed so you can paste it into ChatGPT, Claude, Gemini, or any other LLM.

## What this is for

You (or an assistant) feed in:

1. Your Seller Central / catalog **action log** (price, inventory, content, keywords, variations, offers).
2. A **competitor watchlist** with observed signals (price moves, Buy Box, title/image/A+ changes, reviews, BSR).

The LLM then produces a structured comparison: what you changed, what they changed, who moved first, and what to do next.

## Quick start (any LLM)

1. Open [`prompts/00-system.md`](prompts/00-system.md) → paste as **system / custom instructions**.
2. Open [`templates/paste-pack.md`](templates/paste-pack.md) → fill the data blocks with your ASINs and logs.
3. Paste the filled pack as the **first user message**.
4. Run analysis prompts from [`prompts/`](prompts/) in order, or jump to what you need.

One-shot: use [`prompts/05-full-brief.md`](prompts/05-full-brief.md) after the paste pack.

## Folder map

| Path | Role |
|------|------|
| [`MOC.md`](MOC.md) | Index / navigation |
| [`workflow.md`](workflow.md) | End-to-end operating cadence |
| [`prompts/`](prompts/) | Copy-paste LLM prompts |
| [`schemas/`](schemas/) | JSON shapes for structured I/O |
| [`templates/`](templates/) | Blank forms to fill before prompting |
| [`fixtures/`](fixtures/) | Sample data to dry-run the prompts |

## Data you need

**Own listings (required)**

- ASIN, SKU, marketplace
- Action log rows: timestamp, actor, action type, field, before/after
- Optional: Buy Box %, conversion, sessions for the same window

**Competitors (required for comparison)**

- Top 3–5 ASINs in the same niche
- Observed changes over the same date range (price, coupon, content, reviews, BSR, stock)

Sources that work: Seller Central Action Log / Activity, Inventory reports, Keepa charts, Helium 10 Alerts, SellerSprite, manual screenshots. Normalize into the schemas before prompting for best results.

## Suggested cadence

- **Daily (5 min):** ingest new actions → run threat scan
- **Weekly:** full competitor brief
- **After any big own-listing change:** before/after + competitor reaction window (48–72h)

See [`workflow.md`](workflow.md).
