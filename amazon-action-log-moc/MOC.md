# MOC — Amazon Own Listing Action Log vs Competitors

```text
Amazon Action Log Intelligence
├── 0. Setup
│   ├── README.md
│   ├── workflow.md
│   └── prompts/00-system.md          ← system prompt for any LLM
├── 1. Ingest
│   ├── templates/own-listing-export.md
│   ├── templates/competitor-watchlist.md
│   ├── templates/paste-pack.md       ← fill + paste once
│   ├── schemas/own-action-log.schema.json
│   └── schemas/competitor-signals.schema.json
├── 2. Analyze (prompts)
│   ├── 01-ingest-normalize.md
│   ├── 02-own-timeline.md
│   ├── 03-competitor-compare.md
│   ├── 04-threat-response.md
│   └── 05-full-brief.md              ← one-shot weekly brief
├── 3. Output contract
│   └── schemas/comparison-report.schema.json
└── 4. Dry run
    ├── fixtures/sample-own-actions.json
    └── fixtures/sample-competitors.json
```

## How to use this MOC

1. **Calibrate the LLM** with `prompts/00-system.md`.
2. **Load data** with `templates/paste-pack.md` (or the JSON fixtures to practice).
3. **Ask** using prompts `01` → `05`.
4. **Lock outputs** to `schemas/comparison-report.schema.json` when you want machine-readable notes.

## Core questions this MOC answers

- What did *we* change on our listings, when, and by whom?
- What did top competitors change in the same window?
- Did we lead, follow, or ignore competitor moves?
- Which competitor actions threaten Buy Box, conversion, or share?
- What is the next concrete listing action (price, content, offer, ads)?
