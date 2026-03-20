# DHIS2 Health Analytics Project – Sierra Leone
### INFO B585 – Biomedical Analytics | Indiana University Indianapolis

A biomedical analytics project applying descriptive, predictive, geospatial, and NLP methods to real DHIS2 routine health data from Sierra Leone, covering referral patterns, immunization coverage, maternal health indicators, supply estimation, and dashboard design.

---

## 📋 Project Overview

This project analyzes data from Sierra Leone's national DHIS2 instance to evaluate health system performance across multiple domains. All analyses follow DHIS2 data quality principles — prioritizing transparency, methodological appropriateness, and interpretability over forcing techniques that may distort RHIS data.

**Live Dashboard:** [View on DHIS2](https://b585.info/dhis-web-dashboard/#/HlORe8Z9c3b)

---

## 🔍 Analysis Components

### Q1a – Referral Pattern Comparison
- Compared monthly referral volumes and causes across **Jembe CHC (Baoma)** and **Ngelehun CHC (Badija)** in Bo District over 24 months
- Used stacked column charts to visualize referral volume and cause composition simultaneously
- Findings: Jembe CHC showed consistently higher referral volumes across malaria, anemia, diarrheal diseases, and other infectious conditions; Ngelehun CHC showed sparse, irregular referral activity

### Q1b – Referral Volume Forecasting
- Applied **ETS (Exponential Smoothing)** and **ARIMA** models to forecast monthly referral volumes
- Evaluated using MAE, RMSE, MAPE, and R²
- Key finding: High variability and irregular patterns in RHIS data limit traditional forecasting; models serve to illustrate uncertainty ranges rather than precise predictions

### Q2 – Reporting Rate Trends
- Analyzed district-level reporting rate trends in the Reproductive Health dataset (Jan 2024 – Jun 2025)
- Applied time-series decomposition to identify trend, seasonal, cyclical, and irregular components
- Findings: Generally stable, high reporting rates with a system-wide dip in late 2024; seasonal patterns modestly evident

### Q3 – Cross-Dataset Reporting Rate Comparison
- Compared reporting rates across **Reproductive Health (RH)**, **Child Health (CH)**, and **PMTCT** datasets
- Used line charts and correlation analysis
- Findings: RH and CH exhibited nearly identical trends; PMTCT showed lower average rates and higher variability

### Q4a – Diarrhea Incidence Indicator
- Examined the construction of the *Diarrhea <5 years incidence rate* indicator in DHIS2
- Extracted district-level numerator and denominator values via pivot table
- Tonkolili district showed the highest average incidence across the 12-month period

### Q4b – ORS Stock Estimation
- Translated incidence data into operational resource planning for Tonkolili
- Calculated ORS packet requirements using: 3 packets/day × 5–14 day episode duration
- Produced both minimum and buffer-adjusted stock estimates

### Q5 – OPV1 Coverage by Chiefdom
- Visualized OPV1 coverage among children under one year using a **thematic choropleth map**
- High-coverage chiefdoms: **Gbo, Badija, Niawa Lenga, Komboyo, Simbaru**
- Spatial clustering identified as indicative of localized immunization delivery strength

### Q6 – Facility-Level OPV1 Coverage (Sherbro Island)
- Compared OPV1 coverage across facilities in Sherbro Island using the DHIS2 Maps and Data Visualizer tools
- **Tissana CHC** demonstrated the highest coverage (38.98); **St. Joseph's Clinic** showed lower coverage (6.73)
- Missing values treated as non-reporting, not zero delivery — no interpolation applied

### Q7 – Facility Type and OPV1 Coverage
- Described facility types associated with high/low OPV1 coverage in Sherbro Island
- Limited to two reporting facilities; remaining facilities had missing indicator values

### Q8 – ANC3 Coverage & PHU Delivery Rate
- Compared ANC3 coverage and PHU delivery rates across Sherbro Island facilities using a **clustered column chart**
- **Delken MCHP** showed strongest performance across both indicators; Tissana CHC moderate
- Other facilities had missing values, highlighting reporting gaps

### Q9 – Sentiment Analysis & NLP
- Applied NLP techniques to analytical discourse text from Q8 interpretations
- **Sentiment Analysis**: Pre-trained DistilBERT model → predominantly negative sentiment (reflecting data completeness concerns)
- **Topic Extraction**: BERT-based NER model → key entities: ANC, Delken MCHP, Tissana CHC

### Q10 – Integrated DHIS2 Dashboard
- Consolidated all visualizations, tables, and indicators into a single DHIS2 dashboard
- Structured to support analytical storytelling and interpretability
- **[View Dashboard →](https://b585.info/dhis-web-dashboard/#/HlORe8Z9c3b)**

---

## 🛠️ Tools & Methods

| Category | Tools / Methods |
|---|---|
| Data Platform | DHIS2 (Data Visualizer, Maps, Pivot Tables) |
| Forecasting | ETS, ARIMA (with MAE, RMSE, MAPE, R² evaluation) |
| Visualization | Stacked column charts, line charts, thematic maps, clustered bar charts |
| NLP | DistilBERT (sentiment), BERT-NER (topic/entity extraction) |
| Supply Estimation | Epidemiological indicator → operational resource calculation |

---

## 📁 Repository Structure
```
├── reflections/          # Written reflection document (PDF/DOCX)
├── figures/              # All charts and visualizations
│   ├── figure1_jembe_referrals.png
│   ├── figure2_ngelehun_referrals.png
│   ├── figure3_reporting_rates.png
│   ├── figure4_cross_dataset_comparison.png
│   ├── figure5_opv1_chiefdom_map.png
│   └── figure6_anc3_phu_delivery.png
├── analysis/             # Analysis scripts / notebooks (if applicable)
└── README.md
```

---

## 📚 References

Purkayastha, S. (2025). *Biomedical analytics* (INFO-B585 lecture slides). Luddy School of Informatics, Computing, and Engineering, Indiana University Indianapolis.

---

## 👤 Author

**Bhavana Devi Korlagunta**  
INFO B585 – Biomedical Analytics  
Indiana University Indianapolis
