# Demo paste pack (uses fixtures)

Use this to dry-run the prompts before connecting your live Seller Central data.

1. System prompt: `prompts/00-system.md`
2. Paste the block below as the first user message.
3. Then paste `prompts/05-full-brief.md`.

---

```text
# Amazon Action Log Intelligence Pack (DEMO FIXTURES)

## Context
- Seller / brand: Example Mat Co
- Marketplace: US (ATVPDKIKX0DER)
- Analysis window: 2026-03-27 → 2026-04-10
- Goal: inspect ALL own listing actions and compare to top competitors; recommend ≤5 next actions.
- Hero own ASINs: B0OWNHERO01, B0OWNHERO02
- IMPORTANT: Label all findings as DEMO.

## OWN_ACTION_LOG
<<paste contents of fixtures/sample-own-actions.json>>

## COMPETITOR_WATCHLIST
<<paste contents of fixtures/sample-competitors.json>>

## Constraints
- Do not invent missing numbers; mark unknown.
- Separate OWN vs COMPETITOR evidence.
- Use severity P0–P3.
- End with ≤5 actions in:
  [P#] ASIN | action | owner_role | deadline | success_metric
```

Replace the two `<<paste ...>>` markers with the actual JSON from the fixture files.
