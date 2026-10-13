# Prompt — LLM with Phoenix / Snowflake access

```text
Search our Snowflake account (via Phoenix) for every table needed to audit
performance marketing SPEND and BUDGET.

Known from Ninja (do not invent alternatives until verified):
- DWH.PROD.FACT_AMAZON_AD_ASINS  (Amazon PPC advertised-ASIN fact)
- DWH.RAW.RAW_AMC_PPC_SEARCH_TERM_NTB_ADHOC  (NTB; join on campaign name)

Also search ANALYTICS.AMAZON for ADS_SPONSORED_* / ADVERTISING_* and any
BUDGET / PACING / MEDIA_PLAN / OUT_OF_BUDGET tables across DWH + ANALYTICS.

Return a markdown table:
| audit_field | database.schema.table | key_columns | grain | notes |

Cover at least:
1) Amazon PPC spend (ASIN, campaign, day/week)
2) Budget targets / daily budgets / media plans
3) Pacing & out-of-budget
4) ACoS / ROAS / CAC / NTB
5) Non-Amazon channels if present (Meta, Google, DSP, retail media)
6) Brand / ASIN dimensions

Include DESCRIBE output for FACT_AMAZON_AD_ASINS and the NTB raw table.
Do not invent table names — only evidenced ones.
```