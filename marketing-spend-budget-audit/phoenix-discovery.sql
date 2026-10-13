-- =============================================================================
-- Phoenix discovery SQL — performance marketing spend + budget audit
-- Artifact: https://artifact.goessor.com/artifacts/cmv58086g000801ngkq0iy9mz
-- Run in Phoenix (artifact.goessor.com/phoenix or ninja.goessor.com/phoenix)
-- Paste result grids back to the agent.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1) Account-wide: spend / budget / ads / media / pacing tables
-- -----------------------------------------------------------------------------
SELECT
  table_catalog,
  table_schema,
  table_name,
  row_count,
  bytes,
  comment
FROM snowflake.account_usage.tables
WHERE deleted IS NULL
  AND (
       table_catalog ILIKE ANY ('%DWH%', '%ANALYTICS%', '%PHOENIX%', '%SMART%', '%MART%', '%FINANCE%', '%MEDIA%', '%RAW%')
    OR table_schema  ILIKE ANY (
         '%PROD%', '%RAW%', '%AMAZON%', '%ADS%', '%ADVERT%', '%MARKETING%', '%MEDIA%',
         '%BUDGET%', '%FINANCE%', '%GOOGLE%', '%META%', '%FACEBOOK%', '%DSP%', '%AMC%'
       )
    OR table_name ILIKE ANY (
         '%BUDGET%', '%PACING%', '%SPEND%', '%MEDIA_PLAN%', '%AD_ASIN%',
         '%AMAZON_AD%', '%ADS_SPONSORED%', '%ADVERTISING%', '%PPC%',
         '%AMC%', '%NTB%', '%NEW_TO_BRAND%', '%CAC%', '%ACOS%', '%ROAS%',
         '%OUT_OF_BUDGET%', '%BUDGET_USAGE%', '%CAMPAIGN%BUDGET%',
         '%META%', '%FACEBOOK%', '%GOOGLE_AD%', '%DSP%', '%RETAIL_MEDIA%',
         '%SPONSORED_PRODUCT%', '%SPONSORED_BRAND%', '%SPONSORED_DISPLAY%'
       )
  )
ORDER BY table_catalog, table_schema, table_name;

-- -----------------------------------------------------------------------------
-- 2) Confirm the two Ninja-evidenced tables exist + columns
-- -----------------------------------------------------------------------------
SHOW TABLES LIKE 'FACT_AMAZON_AD_ASINS' IN SCHEMA DWH.PROD;
SHOW TABLES LIKE 'RAW_AMC_PPC_SEARCH_TERM_NTB_ADHOC' IN SCHEMA DWH.RAW;

DESCRIBE TABLE DWH.PROD.FACT_AMAZON_AD_ASINS;
DESCRIBE TABLE DWH.RAW.RAW_AMC_PPC_SEARCH_TERM_NTB_ADHOC;

-- -----------------------------------------------------------------------------
-- 3) Budget-specific column hunt (targets, caps, daily budgets)
-- -----------------------------------------------------------------------------
SELECT
  table_catalog,
  table_schema,
  table_name,
  column_name,
  data_type
FROM snowflake.account_usage.columns
WHERE deleted IS NULL
  AND column_name ILIKE ANY (
    '%BUDGET%', '%DAILY_BUDGET%', '%MONTHLY_BUDGET%', '%TARGET_SPEND%',
    '%PLANNED_SPEND%', '%PACING%', '%MEDIA_PLAN%', '%ALLOCATION%',
    '%SPEND_CAP%', '%COST_CAP%', '%OUT_OF_BUDGET%'
  )
ORDER BY 1, 2, 3, 4;

-- -----------------------------------------------------------------------------
-- 4) Sample grain check on the ASIN ad fact (last 28 days if date col exists)
--    Adjust date column after DESCRIBE (common: REPORT_DATE, DATE, WEEK_START)
-- -----------------------------------------------------------------------------
SELECT *
FROM DWH.PROD.FACT_AMAZON_AD_ASINS
LIMIT 20;

SELECT
  COUNT(*) AS row_cnt,
  COUNT(DISTINCT campaign_name) AS campaigns,
  MIN(week_start) AS min_week,          -- rename if needed
  MAX(week_start) AS max_week,
  SUM(spend) AS total_spend             -- rename if needed
FROM DWH.PROD.FACT_AMAZON_AD_ASINS;

-- -----------------------------------------------------------------------------
-- 5) ANALYTICS Amazon ads stems (exact names)
-- -----------------------------------------------------------------------------
SHOW TABLES LIKE 'ADS%' IN SCHEMA ANALYTICS.AMAZON;
SHOW TABLES LIKE 'ADVERTISING%' IN SCHEMA ANALYTICS.AMAZON;
SHOW TABLES LIKE '%BUDGET%' IN DATABASE ANALYTICS;
SHOW TABLES LIKE '%BUDGET%' IN DATABASE DWH;