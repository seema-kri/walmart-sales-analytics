# 🛒 Walmart Sales Analysis — End-to-End BI Project

> **Stack:** Python · PostgreSQL · SQLAlchemy · Power BI  
> **Scale:** $764M revenue · 550,000 transactions · 5 tables · 2020–2023  
> **Deliverable:** 3-page interactive Power BI dashboard with 20+ DAX measures

---

## 📌 Project Summary

Built a complete business intelligence pipeline — from raw, dirty CSV files to a published Power BI executive dashboard — simulating a real-world BI analyst role at a large retail organisation.

The project answers **15 business questions** across revenue trends, product performance, customer lifetime value, employee productivity, and regional analysis using SQL window functions, Python EDA, and Power BI time intelligence.

---

## 🗂️ Project Structure

```
walmart-sales-analysis/
│
├── 📓 Data_Cleaning.ipynb          # Phase 1: Profiling + cleaning all 5 tables
├── 📓 Connection_ETL.ipynb         # Phase 2: Load clean data into PostgreSQL
├── 📓 EDA.ipynb                    # Phase 3: 12 business questions via SQL + Python charts
├── 📄 sql_business_analysis.sql    # Phase 4: 15 advanced SQL queries (CTEs, window functions)
├── 📊 dashboard.pbix               # Phase 5: Power BI 3-page dashboard
├── 📄 dashboard_pdf.pdf            # Dashboard export (preview)
└── 📁 data/
    ├── Customer_Dim.csv
    ├── Employee_Dim.csv
    ├── Product_Dim.csv
    ├── Store_Dim.csv
    └── Sales_Fact.csv              # 561,000 raw rows
```

---

## 🔧 Phase 1 — Data Cleaning (Python · pandas)

**Raw data had 6 categories of quality issues across 5 tables.**

| Table | Issue Found | Fix Applied |
|---|---|---|
| Sales_Fact | 11,000 duplicate rows | `drop_duplicates()` → 550,000 clean rows |
| Sales_Fact | 44,486 null Shipping_Cost (7.9%) | Filled → 0.0 (business rule: no record = no charge) |
| Sales_Fact | 3 mixed date formats (`YYYY-MM-DD`, `MM/DD/YYYY`, `DD-Mon-YY`) | `pd.to_datetime(format='mixed')` |
| Sales_Fact | 12 variants of Payment_Method (`cash`, `CASH`, ` Cash `) | `.str.strip().str.title()` → 4 clean values |
| Customer_Dim | 80 duplicate Customer_IDs, 87 null City/State | Dedup on ID, fill → `'Unknown'` |
| Employee_Dim | Mixed dept names (`sales`, ` Sales `, `SALES`) | `.str.strip().str.title()` + regex `\bIt\b → IT` |
| Product_Dim | 25 duplicate Product_IDs, `Kitchen Ware` inconsistency | Dedup + `.replace()` |
| Store_Dim | Mixed State casing (`ca`, `CA`, ` CA`) | `.str.strip().str.upper()` |

**Validation steps added (what separates senior from junior analysts):**
- Referential integrity check — confirmed all Sales foreign keys exist in dimension tables
- Cross-validation: `Total_Price = Quantity × Unit_Price` — 0 mismatches found
- Added derived time columns (`Year`, `Month`, `Quarter`, `Weekday`) for Power BI

---

## 🔌 Phase 2 — ETL to PostgreSQL (SQLAlchemy)

```python
from sqlalchemy import create_engine

engine = create_engine('postgresql://user:password@localhost:5432/walmart_sales_db')

for table, df in tables.items():
    df.to_sql(table, engine, if_exists='replace', index=False)
```

All 5 clean tables loaded into PostgreSQL `walmart_sales_db`. This enables full SQL analytics with joins, CTEs, and window functions.

---

## 📊 Phase 3 — EDA (Python · SQLAlchemy · matplotlib · seaborn)

12 business questions answered with SQL queries executed via SQLAlchemy and visualised in Python:

| # | Business Question | Technique |
|---|---|---|
| Q1 | Executive KPI snapshot | Aggregates |
| Q2 | Monthly revenue trend + MoM% | `LAG()` window function |
| Q3 | Revenue by region and store type | `JOIN` + `SUM() OVER()` |
| Q4 | Product category performance | `RANK() OVER (PARTITION BY)` |
| Q5 | Top customers by lifetime value | Double `RANK()` — overall + per segment |
| Q6 | Customer segment analysis | `GROUP BY` + revenue per customer |
| Q7 | Age group revenue breakdown | `pd.cut()` binning + grouped aggregation |
| Q8 | Payment method split | Grouped aggregates + ratio calculation |
| Q9 | Shipping cost vs order value | Correlation analysis + scatter |
| Q10 | Employee performance scorecard | `RANK() OVER (PARTITION BY department)` |
| Q11 | YoY category growth | `LAG() OVER (PARTITION BY category)` |
| Q12 | Day of week + basket size | `dt.day_name()` + grouped scatter |

---

## 🗃️ Phase 4 — SQL Business Analytics (PostgreSQL)

**15 production-grade SQL queries** covering every business dimension.

Key SQL techniques used:

```sql
-- YoY Growth with LAG window function
WITH yearly_cat AS (
    SELECT EXTRACT(YEAR FROM "Sale_Date"::date) AS year,
           p."Category",
           ROUND(SUM("Total_Price")::numeric, 2) AS revenue
    FROM clean_sales s
    JOIN clean_product p ON s."Product_ID" = p."Product_ID"
    GROUP BY year, p."Category"
)
SELECT *,
    LAG(revenue) OVER (PARTITION BY "Category" ORDER BY year) AS prev_year,
    ROUND((revenue - LAG(revenue) OVER (PARTITION BY "Category" ORDER BY year))
          / LAG(revenue) OVER (PARTITION BY "Category" ORDER BY year) * 100, 2
    ) AS yoy_growth_pct
FROM yearly_cat ORDER BY "Category", year;
```

**Window functions used:** `LAG`, `RANK`, `DENSE_RANK`, `SUM() OVER()`, `PARTITION BY`, `DATESINPERIOD`  
**Other techniques:** CTEs, multi-table JOINs, running totals, revenue share %, Top N filtering

---

## 📈 Phase 5 — Power BI Dashboard (3 Pages)

### Setup
- Star schema with 5 tables (1 fact + 4 dimensions)
- Dynamic Calendar table created in DAX (`CALENDAR` + `ADDCOLUMNS`)
- All measures in dedicated `_Measures` table

### DAX Measures (20+)

```dax
-- Time Intelligence
Revenue LY       = CALCULATE([Total Revenue], SAMEPERIODLASTYEAR(Calendar[Date]))
YoY Revenue %    = DIVIDE([Total Revenue] - [Revenue LY], [Revenue LY]) * 100
Revenue YTD      = CALCULATE([Total Revenue], DATESYTD(Calendar[Date]))
Rolling 12M      = CALCULATE([Total Revenue], DATESINPERIOD(Calendar[Date], LASTDATE(Calendar[Date]), -12, MONTH))
MoM Revenue %    = VAR curr = [Total Revenue]
                   VAR prev = CALCULATE([Total Revenue], DATEADD(Calendar[Date], -1, MONTH))
                   RETURN DIVIDE(curr - prev, prev) * 100

-- Rankings
Customer LTV Rank = RANKX(ALLSELECTED(clean_customer[Customer_Name]), [Total Revenue], , DESC, DENSE)
```

### Page 1 — Executive Summary
KPI cards · Monthly revenue trend · Revenue by region · Store type donut · US state map · Insight text box

### Page 2 — Product & Store
Revenue by category · Top 10 sub-categories · YoY matrix with conditional formatting (green/red) · Regional donut · Insight text box

### Page 3 — Customer & Employee
Revenue by segment · Revenue by age group · Payment method donut · Top 20 customers LTV table with rank · Top employees bar chart · Insight text box

---

## 🔍 Key Business Findings

| Finding | Data Point | Business Implication |
|---|---|---|
| Revenue plateau | $14M–$17M/month, flat for 4 years | Market saturation — organic growth strategy needed |
| Central leads all categories | $221M vs West $162M | West region = $59M untapped opportunity |
| Books only growing category | +3.6% YoY in 2023 | Expand Books assortment — Fiction +8.5% |
| Clothing reversing | +0.8% → -1.3% | Fastest declining category — intervention needed |
| Top 10 customers = 100% Consumer | Zero Corporate/Home Office in top 10 | B2B segment underdeveloped — $367M gap vs Consumer |
| 18–30 age group leads | $217M vs 61+ at $131M | Senior segment $86M behind — targeted opportunity |
| Sales dept ranks last | $79.9M vs Marketing $95M | Counter-intuitive — warrants operational review |
| Specialty stores underperform | Only 5.77% revenue share | Format issue, not product issue — all 5 categories affected |
| Top employee 2.25x average | Eve Smith $18.5M vs avg $8.2M | 33 of 93 employees below average — coaching gap |
| Payment methods equal split | ~25% each of 4 methods | No dominant preference — healthy, low processing-fee risk |

---

## 🛠️ Tech Stack

| Tool | Version | Purpose |
|---|---|---|
| Python | 3.12 | Data cleaning, EDA, ETL |
| pandas | 2.2 | Data manipulation |
| SQLAlchemy | 2.0 | Python ↔ PostgreSQL connection |
| psycopg2 | 2.9 | PostgreSQL driver |
| PostgreSQL | 16 | Data warehouse + SQL analytics |
| matplotlib / seaborn | latest | EDA visualisations |
| Power BI Desktop | 2024 | Dashboard + DAX |

---

## 🚀 How to Run

**Prerequisites:** Python 3.10+, PostgreSQL 14+, Power BI Desktop

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/walmart-sales-analysis
cd walmart-sales-analysis

# 2. Install dependencies
pip install pandas sqlalchemy psycopg2 matplotlib seaborn

# 3. Create PostgreSQL database
psql -U postgres -c "CREATE DATABASE walmart_sales_db;"

# 4. Run notebooks in order
jupyter notebook Data_Cleaning.ipynb       # Clean raw CSVs
jupyter notebook Connection_ETL.ipynb      # Load into PostgreSQL
jupyter notebook EDA.ipynb                 # Run EDA analysis

# 5. Open SQL file in pgAdmin or DBeaver
# Run sql_business_analysis.sql

# 6. Open dashboard.pbix in Power BI Desktop
# Update connection string to your local PostgreSQL
```

---

## 📁 Dataset

| Table | Rows | Key Columns |
|---|---|---|
| Sales_Fact | 561,000 raw / 550,000 clean | Sale_Date, Total_Price, Quantity, Payment_Method |
| Customer_Dim | 1,000 | Segment, Age, City, State |
| Product_Dim | 500 | Category, Sub_Category, Brand |
| Store_Dim | 50 | Region, Store_Type, City |
| Employee_Dim | 200 | Department, Position, Hire_Date |

---

## 👤 About

Built as an end-to-end portfolio project simulating a real BI analyst workflow — from raw messy data to executive dashboard with business recommendations.

**Connect:** [LinkedIn](https://www.linkedin.com/in/seema-kumari-375763308/) · [Portfolio](https://github.com/seema-kri)
