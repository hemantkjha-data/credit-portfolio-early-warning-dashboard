# Credit Portfolio Early Warning Dashboard

SQL + interactive dashboard project for **credit risk monitoring** — focused on early warning signals: DPD buckets, PAR trends, roll-rate/migration, and portfolio concentration.

## Business Problem
Lenders need to spot deterioration *before* accounts become NPAs. Monitoring **delinquency migration (30→60→90 DPD)**, PAR trends, and segment concentration enables early action (collections, restructuring, exposure caps).

## Dataset
Synthetic monthly loan-portfolio snapshots (`data/loan_portfolio.csv`, ~28.5k rows, 3,000 loans across 12 months).
- Fields: `loan_id, snapshot_month, vintage_month, region, product, segment, grade, disbursed_amount, outstanding_amount, dpd_bucket, dpd_days`
- Buckets: Current, 1-30, 31-60, 61-90, 90+ DPD

## Key Insights
- **PAR30/PAR90 trend** tracked month-on-month to surface deterioration early.
- **Roll-rate (migration) matrix** shows how accounts move between DPD buckets between consecutive months.
- **Exposure concentration** by grade and product highlights where risk is clustered.

## Analysis & Dashboard
- `sql/analysis.sql` — PAR metrics, DPD distribution, monthly trend, roll-rate migration, concentration queries.
- `dashboard/index.html` — interactive dashboard (Chart.js): KPI cards, PAR30/PAR90 trend, DPD exposure distribution, roll-rate matrix, grade & product concentration.

Open `dashboard/index.html` in a browser to view the dashboard.

## Tools
- SQL (aggregation logic for migration & PAR)
- HTML/CSS/JavaScript + Chart.js

## Repo Structure
```
credit-portfolio-early-warning-dashboard/
├── data/loan_portfolio.csv
├── sql/analysis.sql
├── dashboard/index.html
└── README.md
```
