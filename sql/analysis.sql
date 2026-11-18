-- Credit Portfolio Early Warning Analysis
-- Table: loan_portfolio(loan_id, snapshot_month, vintage_month, region, product, segment, grade, disbursed_amount, outstanding_amount, dpd_bucket, dpd_days)

-- 1) Portfolio snapshot & PAR metrics (latest month)
WITH latest AS (SELECT MAX(snapshot_month) m FROM loan_portfolio)
SELECT snapshot_month,
  SUM(outstanding_amount) AS total_outstanding,
  ROUND(SUM(CASE WHEN dpd_bucket IN ('1-30','31-60','61-90','90+') THEN outstanding_amount ELSE 0 END) * 100.0 / SUM(outstanding_amount), 2) AS par30_pct,
  ROUND(SUM(CASE WHEN dpd_bucket = '90+' THEN outstanding_amount ELSE 0 END) * 100.0 / SUM(outstanding_amount), 2) AS par90_pct
FROM loan_portfolio, latest WHERE snapshot_month = latest.m GROUP BY snapshot_month;

-- 2) DPD bucket distribution (exposure) - latest month
WITH latest AS (SELECT MAX(snapshot_month) m FROM loan_portfolio)
SELECT dpd_bucket, COUNT(DISTINCT loan_id) AS accounts, SUM(outstanding_amount) AS exposure
FROM loan_portfolio, latest WHERE snapshot_month = latest.m
GROUP BY dpd_bucket
ORDER BY CASE dpd_bucket WHEN 'Current' THEN 1 WHEN '1-30' THEN 2 WHEN '31-60' THEN 3 WHEN '61-90' THEN 4 ELSE 5 END;

-- 3) Monthly PAR30 / PAR90 trend
SELECT snapshot_month,
  SUM(outstanding_amount) AS total_outstanding,
  ROUND(SUM(CASE WHEN dpd_bucket IN ('1-30','31-60','61-90','90+') THEN outstanding_amount ELSE 0 END) * 100.0 / SUM(outstanding_amount), 2) AS par30_pct,
  ROUND(SUM(CASE WHEN dpd_bucket = '90+' THEN outstanding_amount ELSE 0 END) * 100.0 / SUM(outstanding_amount), 2) AS par90_pct
FROM loan_portfolio GROUP BY snapshot_month ORDER BY snapshot_month;

-- 4) Roll-rate / migration matrix (previous month -> latest month)
WITH months AS (SELECT DISTINCT snapshot_month m FROM loan_portfolio ORDER BY m DESC LIMIT 2),
bounds AS (SELECT MAX(m) AS curr_m, MIN(m) AS prev_m FROM months),
prev AS (SELECT loan_id, dpd_bucket AS prev_bucket FROM loan_portfolio, bounds WHERE snapshot_month = prev_m),
curr AS (SELECT loan_id, dpd_bucket AS curr_bucket FROM loan_portfolio, bounds WHERE snapshot_month = curr_m)
SELECT prev_bucket, curr_bucket, COUNT(*) AS accounts
FROM prev JOIN curr USING (loan_id) GROUP BY prev_bucket, curr_bucket ORDER BY prev_bucket, curr_bucket;

-- 5) Exposure concentration by grade and product (latest month)
WITH latest AS (SELECT MAX(snapshot_month) m FROM loan_portfolio)
SELECT grade, product, SUM(outstanding_amount) AS exposure
FROM loan_portfolio, latest WHERE snapshot_month = latest.m GROUP BY grade, product ORDER BY exposure DESC;
