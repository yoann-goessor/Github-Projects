# Marketing spend & budget — Snowflake source map

Companion pack for the Goessor artifact  
https://artifact.goessor.com/artifacts/cmv58086g000801ngkq0iy9mz

Goal: identify every Snowflake table Phoenix can see that powers a **performance marketing spend + budget audit** (actuals, targets, pacing, efficiency).

## Status

| Access path | Result |
|-------------|--------|
| Phoenix UI (`artifact.goessor.com/phoenix`, `ninja.goessor.com/phoenix`) | Blocked — Google SSO → GoEssorApp |
| Direct Snowflake credentials / snowsql | Not in this environment |
| Agency MCP | Ads platforms only — **not** Snowflake |

## What to do next

1. Open Phoenix while signed into GoEssorApp.
2. Run `phoenix-discovery.sql` (queries 1 → 4).
3. Paste the result grids here (or screenshot them).
4. We will lock each audit field to `database.schema.table.column`.

## Pack contents

| File | Purpose |
|------|---------|
| `SNOWFLAKE_SOURCES.md` | Evidenced tables + audit field map |
| `phoenix-discovery.sql` | Account-wide discovery SQL for Phoenix |
| `PROMPT_FOR_PHOENIX.md` | Copy-paste prompt if another LLM has Phoenix access |