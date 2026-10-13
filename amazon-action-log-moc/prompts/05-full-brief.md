# Prompt 05 — Full weekly brief (one-shot)

Use this after pasting `templates/paste-pack.md` when you want a single complete answer.

---

Produce a full Amazon Action Log intelligence brief for my own listings vs top competitors.

Follow this exact structure:

## 1. Snapshot
- Marketplaces, date window, own ASINs, competitor ASINs
- One-sentence status

## 2. Own action timeline
- Chronological, per ASIN
- Highlight high-impact edits and unfinished work

## 3. Competitor moves
- What each competitor changed in-window
- Who moved first on price/content/stock

## 4. Side-by-side deltas
- Table: price/coupon, Buy Box, content freshness, reviews, stock, BSR
- Led / matched / lagged / ignored for each major event

## 5. Threats (P0–P3)
- Evidence-linked; no invented numbers

## 6. Recommended actions (≤5)
```text
[P#] ASIN | action | owner_role | deadline | success_metric
```

## 7. Data gaps
- What to export next time to improve confidence

If sample fixtures were used, label findings as **DEMO** so I do not treat them as live account truth.
