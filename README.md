# Walmart BI Platform: Revenue Intelligence & Decision System

> Walmart's leadership lacked a unified view of revenue drivers across regions, categories, and customer segments.  
> This project builds a **production-grade BI system** that transforms 550K+ raw transactions into **actionable business decisions and revenue growth opportunities**.

---

## 🎯 Business Impact Snapshot

- Identified **$59M regional revenue gap** → expansion strategy for underperforming regions  
- Discovered **$367M untapped B2B opportunity** → new high-value revenue channel  
- Recommended category shift (Clothing → Books) → potential **+3–5% revenue uplift**  
- Built scalable BI pipeline analyzing **$764M revenue across 4 years**

---

## Dashboard Preview

| Executive Summary | Product & Store | Customer & Employee |
|---|---|---|
| ![Executive Summary](images/Excecutive%20Summary.png) | ![Product & Store](images/Product%20%26%20Store.png) | ![Customer & Employee](images/Customer%20%26%20Employee.png) |

---

## Problem Statement

Retail leaders need clear answers to:
- Where is revenue declining or stagnating?
- Which segments are underperforming?
- What actions can drive measurable growth?

Raw transactional data cannot answer these questions directly.

This project builds an **end-to-end BI system** that converts raw data into **executive-level insights and strategic recommendations**.

**Scope:**  
550K+ transactions · $764M revenue · 4 years · 5 categories · 4 regions · 93 employees

---

## Pipeline Architecture
Raw CSV → Python (pandas) → PostgreSQL (Star Schema) → SQL Analytics → Power BI Dashboard


---

## What I Built

### 1. Data Engineering
- Cleaned 550K+ rows across 5 datasets  
- Handled nulls, duplicates, inconsistent formats  
- Ensured **data integrity before analysis**

### 2. Data Warehouse
- Designed **star schema** (1 fact + 4 dimension tables)  
- Enabled **scalable, high-performance analytical queries**

### 3. SQL Analytics
- Developed **15 business-driven queries**  
- Used:
  - CTEs for modular logic  
  - Window functions (`LAG`, `RANK`, `DENSE_RANK`)  
  - Time-series analysis (YoY, MoM, rolling trends)  

### 4. Executive Dashboard
- Built **3-page Power BI dashboard**  
- Created **20+ DAX measures** (YoY growth, rolling metrics)  
- Designed for **decision-making, not just visualization**

---

## Key Business Insights → Actions

### 1. Revenue Stagnation
Revenue remained flat at **$14M–$17M monthly over 4 years**

- **Action:** Shift focus from saturated segments to growth categories  
- **Impact:** Estimated **+$8M–$12M annual uplift** through reallocation strategy  

---

### 2. $59M Regional Gap
Central: $221M vs West: $162M

- **Action:** Replicate Central region strategies in West  
- **Impact:** Potential to recover **$50M+ revenue gap**  

---

### 3. Category Performance Shift
Books: +3.6% YoY | Clothing: –1.3%

- **Action:** Reallocate budget from Clothing → Books  
- **Impact:** Expected **3–5% increase in overall revenue growth**  

---

### 4. Untapped B2B Opportunity
Consumer: $519M | Corporate: $153M

- **Action:** Launch B2B acquisition strategy  
- **Impact:** **$300M+ expansion opportunity** in underserved segment  

---

### 5. Employee Performance Gap
Top performer = **2.25× average output**

- **Action:** Introduce performance-based incentives & training  
- **Impact:** Improved team productivity and revenue contribution  

---

## Business Recommendations (Executive Summary)

- Expand high-performing regional strategies  
- Invest in high-growth product categories  
- Build dedicated B2B sales channel  
- Implement employee performance optimization programs  

---

## Project Structure
walmart-bi-analytics-platform/
├── notebooks/
├── sql/
├── data/
├── images/
├── dashboard.pbix
├── requirements.txt
└── README.md

---

## Tech Stack

- **Python (pandas)** — data cleaning & transformation  
- **PostgreSQL** — data warehouse (star schema)  
- **SQL** — analytical queries (CTEs, window functions)  
- **Power BI** — dashboard & business reporting  

---

## Performance & Scalability

- Star schema improves query efficiency for large datasets  
- Handles **550K+ rows with scalable design**  
- Modular SQL queries enable easy business question expansion  

---

## Future Work

- Revenue **forecasting model** (predict next 6–12 months)  
- Customer segmentation (high vs low value users)  
- Real-time data pipeline (streaming ingestion)  
- Dashboard deployment (Power BI Service / web embedding)  

---

## About

I build data systems that drive **business decisions, not just dashboards**.

[LinkedIn](https://www.linkedin.com/in/seema-kumari-375763308/)  
[GitHub](https://github.com/seema-kri)
