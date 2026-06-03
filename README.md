# Systematic Review and Meta-Analysis: Sleep Apnea Severity in Obese vs. Non-obese Children and Adolescents

> Research code for: **"Comparison of Sleep Apnea Severity in Obese and Non-Obese Children and Adolescents: A Systematic Review and Meta-Analysis"**  
> *Manuscript in preparation*

---

## 📄 Abstract

**Background:** Obstructive sleep apnea (OSA) is a common sleep-disordered breathing condition in children and adolescents, characterized by respiratory pauses and decreased blood oxygen levels. The rising prevalence of obesity in this age group has established it as a major risk factor for OSA severity. Despite its clinical significance, previous studies comparing OSA severity between obese and non-obese children have yielded conflicting results.

**Methods:** This systematic review and meta-analysis aimed to quantitatively assess the difference in OSA severity between obese and non-obese children and adolescents (aged 1–18 years), following PRISMA and Cochrane guidelines. Six reputable databases were searched for studies published from 2000 to 2025. From an initial pool of 178 articles, 16 studies were included. Data were analyzed using a random-effects model (DerSimonian-Laird).

**Results:** OSA severity was significantly higher in obese children and adolescents compared to non-obese counterparts (SMD = 0.41, 95% CI: 0.23–0.58, p < 0.001), with considerable heterogeneity (I² = 84.1%).

**Conclusion:** This meta-analysis confirms that obese children and adolescents experience greater OSA severity, underscoring the importance of early screening and intervention in this high-risk population.

---

## 🎯 Key Findings

| Question | Finding |
|----------|---------|
| How different is OSA severity between obese and non-obese children? | Pooled SMD = **0.41** (95% CI: 0.23–0.58, p < 0.001) |
| How consistent are findings across studies? | I² = **84.1%** — considerable heterogeneity |
| Is there publication bias? | Egger's test (t = 1.1, p = 0.288) — no strong evidence of bias |
| Are results robust? | Leave-one-out sensitivity analysis — results stable across all iterations |

---

## 📊 Study Characteristics

| Characteristic | Value |
|----------------|-------|
| Databases searched | 6 (PubMed, Scopus, Web of Science, ...) |
| Publication period | 2000–2025 |
| Initial articles screened | 178 |
| Studies included | 16 |
| Total participants | 4,239 |
| Age range | 1–18 years |
| Outcome measure | OSA severity (AHI-based SMD) |
| Guidelines | PRISMA & Cochrane |

---

## 📁 Repository Structure

```
OSA-Obesity-MetaAnalysis/
├── README.md
├── .gitignore
├── report/
│   └── meta_analysis_report.Rmd        # Full reproducible analysis report
├── output/
│   └── figures/
│       ├── forest_plot.png             # Forest plot (random-effects model)
│       ├── funnel_plot.png             # Funnel plot (publication bias)
│       └── sensitivity_plot.png        # Leave-one-out sensitivity analysis
└── scripts/
    ├── meta_analysis.Rmd               # Pooled effect size and heterogeneity
    ├── forest_plot.Rmd                 # Forest plot generation
    └── funnel_plot.Rmd                 # Funnel plot generation
```

---

## 🔧 Requirements & Reproduction

### R version
R ≥ 4.0.0

### Required packages
```r
install.packages(c("metafor", "dplyr", "ggplot2", "knitr", "rmarkdown"))
```

| Package | Purpose |
|---------|---------|
| `metafor` | Meta-analysis models, heterogeneity, publication bias |
| `ggplot2` | Forest plot, funnel plot, sensitivity plot |
| `dplyr` | Data wrangling |
| `knitr` / `rmarkdown` | Reproducible report generation |

### How to run
1. Clone the repository:
```bash
git clone https://github.com/yourusername/OSA-Obesity-MetaAnalysis.git
```
2. Open `report/meta_analysis_report.Rmd` in RStudio
3. Knit the file to generate the full report:
```r
rmarkdown::render("report/meta_analysis_report.Rmd")
```

> **Note:** The analysis scripts in `scripts/` can also be run individually for each figure.

---

## 🔒 Data Availability

The extracted study data used in this meta-analysis are not publicly available pending manuscript submission.

Upon acceptance for publication, the complete extracted dataset will be deposited in a public repository and linked here.

> For replication inquiries or collaboration requests, please contact the corresponding author.

---

## 📊 Statistical Methods

| Method | Details |
|--------|---------|
| Effect size | Standardized Mean Difference (Cohen's d / Hedges' g) |
| Pooling model | Random-effects (DerSimonian-Laird) |
| Heterogeneity | I² statistic and Cochran's Q-test |
| Publication bias | Funnel plot, Egger's test, Kendall's Tau (Begg's test) |
| Sensitivity analysis | Leave-one-out meta-analysis |
| Software | R (metafor package) |

---

## 📧 Contact

**Fatemeh Sadat Hosseini**  
📧 fateme.sadat.hosseini2000@gmail.com

---

## 📜 Citation

*To be updated upon publication.*

---

*⭐ If this code was useful for your research, please consider starring the repository.*
