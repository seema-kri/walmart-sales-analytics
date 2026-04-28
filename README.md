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

Raw transactional data cannot directly answer these questions.

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
- Handled nulls, duplicates, and inconsistent formats  
- Ensured **high data quality before analysis**

### 2. Data Warehouse
- Designed **star schema** (1 fact + 4 dimension tables)  
- Enabled **scalable and efficient analytical queries**

### 3. SQL Analytics
- Developed **15 business-driven queries**  
- Used:
  - CTEs for modular logic  
  - Window functions (`LAG`, `RANK`, `DENSE_RANK`)  
  - Time-series analysis (YoY, MoM, rolling trends)  

### 4. Executive Dashboard
- Built **3-page Power BI dashboard**  
- Created **20+ DAX measures** (YoY growth, rolling metrics)  
- Designed for **business decision-making**

---

## Key Business Insights → Actions

### Revenue Stagnation
Revenue remained flat at **$14M–$17M monthly over 4 years**

- **Action:** Shift focus to high-growth categories and regions  
- **Impact:** Estimated **+$8M–$12M annual revenue uplift**

---

### $59M Regional Gap
Central: $221M vs West: $162M

- **Action:** Replicate Central region strategies in West  
- **Impact:** Potential to recover **$50M+ revenue gap**

---

### Category Performance Shift
Books: +3.6% YoY | Clothing: –1.3%

- **Action:** Reallocate budget from Clothing → Books  
- **Impact:** Expected **3–5% revenue growth**

---

### Untapped B2B Opportunity
Consumer: $519M | Corporate: $153M

- **Action:** Build a dedicated B2B acquisition strategy  
- **Impact:** **$300M+ expansion opportunity**

---

### Employee Performance Gap
Top performer = **2.25× average output**

- **Action:** Introduce performance incentives and training  
- **Impact:** Increased team productivity and revenue contribution  

---

## Business Recommendations

- Expand high-performing regional strategies  
- Invest in high-growth product categories  
- Build a B2B revenue channel  
- Optimize employee performance through incentives  

---

## Project Structure
walmart-bi-analytics-platform/
├── data/ # Schema & data files
├── images/ # Dashboard screenshots
├── notebooks/ # Data cleaning, ETL, EDA
├── sql/ # Business analysis queries
├── dashboard.pbix # Power BI dashboard
├── dashboard_pdf.pdf # Dashboard report (PDF)
├── requirements.txt # Dependencies
└── README.md

---

## Tech Stack

- **Python (pandas)** — data processing  
- **PostgreSQL** — data warehouse  
- **SQL** — analytics (CTEs, window functions)  
- **Power BI** — visualization & reporting  

---

## Performance & Scalability

- Star schema improves query performance  
- Handles **550K+ rows efficiently**  
- Modular design supports scalability  

---

## Future Work

- Revenue forecasting model (6–12 months prediction)  
- Customer segmentation (high vs low value)  
- Real-time data pipeline  
- Dashboard deployment (Power BI Service)  

---

## About

I build data systems that drive **business decisions, not just dashboards**.

🔗 [LinkedIn](https://www.linkedin.com/in/seema-kumari-375763308/)  
💻 [GitHub](https://github.com/seema-kri)
