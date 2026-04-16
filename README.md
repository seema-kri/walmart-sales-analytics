# Walmart Sales Analytics — End-to-End BI Platform

> Engineered a production-grade BI system analyzing **$764M in retail transactions** — from raw data ingestion to executive decision dashboards.

| Metric | Value |
|---|---|
| Revenue analyzed | $764M |
| Transactions processed | 550K+ |
| Business SQL queries | 15 |
| DAX measures | 20+ |
| Pipeline stages | 5 |

---

## 📊 Dashboard Preview

### Executive Summary
![Executive Summary](images/Excecutive%20Summary.png)

### Product & Store Insights
![Product & Store](images/Product%20%26%20Store.png)

### Customer & Employee Insights
![Customer & Employee](images/Customer%20%26%20Employee.png)

---

## Pipeline

```
Raw CSV → Python (pandas) → PostgreSQL star schema → SQL analytics → Power BI dashboard
```

---

## What I Built

**Data engineering** — Cleaned 550K+ rows of raw retail data across 5 tables: removed duplicates, resolved nulls, standardized formats, and enforced referential integrity before any analysis ran.

**Data warehouse** — Designed a star schema (1 fact table + 4 dimension tables) in PostgreSQL. Enables scalable analytical joins without query rewrites as data volume grows.

**SQL analytics** — Wrote 15 business-critical queries using CTEs, window functions (LAG, RANK, DENSE_RANK), and time-series aggregations. Each query answers a specific executive question — not a generic data dump.

**Executive dashboard** — Built a 3-page Power BI dashboard with 20+ DAX measures and time intelligence (YoY, MoM, Rolling 12M). Designed for leadership decision-making, not data exploration.

---

## Business Insights Uncovered

**🚩 Revenue stagnation** — Monthly revenue flat at $14M–$17M for 4 years despite 550K transactions. Indicates market saturation; incremental optimization won't fix this.

**🌍 $59M regional gap** — Central region generates $221M vs West's $162M. Central outperforms West by $12–13M in every product category — largest single growth lever in the data.

**📚 Books is the only growing category** — +3.6% YoY in 2023 (Fiction +8.5%, Non-Fiction +5.2%). Clothing dropped –1.3%. Budget reallocation from Clothing to Books is data-backed.

**👥 B2B channel underdeveloped** — Consumer segment: $519M. Corporate: $153M. Zero Corporate presence in top 10 customers by LTV. $367M gap represents an untapped revenue channel.

**🧑‍💼 Employee performance spread** — Top performer generates 2.25× the average. Only 33 of 93 employees exceed average revenue contribution — structured coaching program has measurable ROI.

---

## Tech Stack

| Layer | Tools |
|---|---|
| Data processing | Python, pandas |
| Database | PostgreSQL |
| Data access | SQLAlchemy, psycopg2 |
| Analytics | SQL — CTEs, window functions, aggregations |
| Visualization | Power BI, DAX |

---

## Project Structure

```
walmart-bi-analytics-platform/
│
├── notebooks/
│   ├── Data_Cleaning.ipynb       # 550K+ row cleaning pipeline
│   ├── Connection_ETL.ipynb      # PostgreSQL load via SQLAlchemy
│   └── EDA.ipynb                 # Exploratory analysis
│
├── sql/
│   └── sql_bussiness_analysis.sql  # 15 business-critical queries
│
├── images/                       # Dashboard screenshots
├── dashboard.pbix                # Power BI file (open in Power BI Desktop)
└── README.md
```

---

## Run It Yourself

```bash
# Clone the repo
git clone https://github.com/seema-kri/walmart-bi-analytics-platform
cd walmart-bi-analytics-platform

# Install dependencies
pip install pandas sqlalchemy psycopg2 matplotlib seaborn

# Create PostgreSQL database
psql -U postgres -c "CREATE DATABASE walmart_sales_db;"

# Run notebooks in order
jupyter notebook notebooks/Data_Cleaning.ipynb
jupyter notebook notebooks/Connection_ETL.ipynb
jupyter notebook notebooks/EDA.ipynb
```

Then open `dashboard.pbix` in Power BI Desktop.

---

## Why This Project

Most portfolios show analysis. This project demonstrates **end-to-end ownership** — messy raw data goes in, boardroom-ready decisions come out.

- ✅ Business thinking embedded at every step — not just code
- ✅ SQL that answers questions executives actually ask
- ✅ Dashboard designed to surface decisions, not display numbers
- ✅ Pipeline architecture that scales beyond tutorial datasets

---

## About

I build data systems that surface decisions — not just charts.

🔗 **LinkedIn** — https://www.linkedin.com/in/seema-kumari-375763308/  
🔗 **GitHub** — https://github.com/seema-kri
