# Prompt 01 — Ingest & normalize

Paste after your data pack. Use when raw exports are messy.

---

Normalize the pasted OWN action log and COMPETITOR watchlist into clean structured records.

Tasks:
1. List every ASIN involved (own + competitor) with marketplace.
2. Map each own row to the action taxonomy from your system instructions.
3. Map each competitor observation to a signal type.
4. Flag rows that are incomplete (missing timestamp, before/after, or ASIN).
5. Propose a comparison window (start/end) based on the data present.
6. Return two JSON arrays matching:
   - own actions → `own-action-log` schema fields
   - competitor signals → `competitor-signals` schema fields

Do not analyze strategy yet. Only clean and structure.
