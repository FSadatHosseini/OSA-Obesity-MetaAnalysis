# ==============================================
# 03_funnel_plot.R
# FUNNEL PLOT - FINAL VERSION
# Egger and Kendall LOWER POSITION
# ==============================================

rm(list = ls())
graphics.off()

# 1. Set working directory
setwd("C:/Users/Pentium/Desktop/Meta_Apnea_Project")

# 2. Load data (17 studies from thesis)
data <- data.frame(
  study = c("Andersen et al. (2019)", "Baker et al. (2017)", "Caliendo et al. (2023)",
            "Dayyat et al. (2009)", "Dékány et al. (2023)", "Fernandes do Prado et al. (2002)",
            "Gozal et al. (2009)", "Herttrich et al. (2020)", "Kang et al. (2012)",
            "Lam et al. (2006)", "Narayanan et al. (2019)", "Rudnick et al. (2007)",
            "Scott et al. (2016)", "Su et al. (2015a)", "Su et al. (2015b)",
            "Wang et al. (2019)", "Xu et al. (2008)"),
  
  smd = c(0.838, 0.376, 0.154, 0.139, 0.478, -0.103, -0.686, 0.271, 0.019,
          0.022, 0.281, 0.089, 0.174, 0.424, 0.054, 0.706, 1.160),
  
  lower = c(0.449, -0.013, -0.379, -0.055, 0.322, -0.581, -1.090, -0.050, 0.520,
            0.407, -0.016, -0.483, -0.138, 0.220, 0.693, 0.429, 0.667),
  
  upper = c(1.228, 0.765, 0.638, 0.332, 0.634, 0.376, -0.233, 0.592, 1.318,
            0.838, 0.578, 0.660, 0.485, 0.627, 1.015, 0.983, 1.652)
)

# 3. Calculate standard error
data$se <- (data$upper - data$lower) / (2 * 1.96)

# 4. Calculate pooled SMD (random-effects)
data$variance <- data$se^2
weights_fixed <- 1 / data$variance
SMD_fixed <- sum(data$smd * weights_fixed) / sum(weights_fixed)
Q <- sum(weights_fixed * (data$smd - SMD_fixed)^2)
df <- nrow(data) - 1

if (Q > df) {
  tau2 <- (Q - df) / (sum(weights_fixed) - sum(weights_fixed^2)/sum(weights_fixed))
} else {
  tau2 <- 0
}

weights_random <- 1 / (data$variance + tau2)
SMD_random <- sum(data$smd * weights_random) / sum(weights_random)

# 5. MANUAL VALUES for Egger and Kendall (from your thesis)
egger_t <- 1.10
egger_p <- 0.288
kendall_tau <- 0.09
kendall_p <- 0.621

# 6. Format p-values for display
if (egger_p < 0.001) {
  egger_text <- paste("Egger's t =", egger_t, ", p < 0.001")
} else {
  egger_text <- paste("Egger's t =", egger_t, ", p =", egger_p)
}

if (kendall_p < 0.001) {
  kendall_text <- paste("Kendall's Tau =", kendall_tau, ", p < 0.001")
} else {
  kendall_text <- paste("Kendall's Tau =", kendall_tau, ", p =", kendall_p)
}

# ==============================================
# 7. ULTRA HIGH QUALITY FUNNEL PLOT (1200 DPI)
# ==============================================
if (!dir.exists("output/figures")) dir.create("output/figures", recursive = TRUE)

png(filename = "output/figures/funnel_plot.png",
    width = 10, height = 9, units = "in", res = 1200)

# Plot parameters
par(mar = c(5, 5, 5.5, 4), mgp = c(2.5, 0.6, 0), 
    cex.main = 1.1, family = "serif")

# Create blank plot (inverted y-axis: SE 0 at top)
plot(NA, 
     xlim = c(-1.5, 2.2), 
     ylim = rev(c(0, max(data$se) * 1.15)),
     xlab = "Standardized Mean Difference (SMD)",
     ylab = "Standard Error",
     main = "Figure 4-1. Funnel Plot for Publication Bias Assessment\nSleep Apnea Severity: Obese vs. Non-obese Children",
     xaxt = "n")

# X-axis
axis(side = 1, at = c(-1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2), 
     labels = c("-1.5", "-1", "-0.5", "0", "0.5", "1", "1.5", "2"),
     cex.axis = 0.85)

# 8. Funnel lines (95% pseudo confidence intervals)
se_seq <- seq(0, max(data$se) * 1.15, length.out = 100)
upper_line <- SMD_random + 1.96 * se_seq
lower_line <- SMD_random - 1.96 * se_seq

lines(upper_line, se_seq, lty = 2, col = "gray50", lwd = 1.5)
lines(lower_line, se_seq, lty = 2, col = "gray50", lwd = 1.5)

# 9. Vertical lines
abline(v = SMD_random, lty = 1, col = "#D55E00", lwd = 2.5)
abline(v = 0, lty = 3, col = "gray60", lwd = 1.5)

# 10. Plot individual studies (NO labels)
points(x = data$smd, y = data$se, 
       pch = 16, col = "#0072B2", cex = 1.3)

# ==============================================
# 11. EGGER'S TEST AND KENDALL'S TAU AT BOTTOM LEFT (LOWER POSITION)
# ==============================================
# Bottom left of the plot
text(x = -1.4, y = 0.290,   
     labels = egger_text, 
     col = "#009E73", cex = 0.75, adj = 0, font = 1)

text(x = -1.4, y = 0.275,   
     labels = kendall_text, 
     col = "#009E73", cex = 0.75, adj = 0, font = 1)


# ==============================================
# 12. Legend (at top right)
# ==============================================
legend("topright",
       legend = c("Individual studies", "Pooled SMD (random-effects)", 
                  "95% pseudo CI", "No effect"),
       col = c("#0072B2", "#D55E00", "gray50", "gray60"),
       pch = c(16, NA, NA, NA),
       lty = c(NA, 1, 2, 3),
       lwd = c(NA, 2.5, 1.5, 1.5),
       bty = "n", cex = 0.7)

dev.off()

# ==============================================
# 13. Print results
# ==============================================
cat("\n========================================\n")
cat("     FUNNEL PLOT - PUBLICATION BIAS\n")
cat("========================================\n")
cat(paste("Number of studies:", nrow(data), "\n"))
cat(paste("Pooled SMD (random-effects):", round(SMD_random, 3), "\n\n"))

cat("--- Publication Bias Tests (from thesis) ---\n")
cat(paste("Egger's test: t =", egger_t, ", p =", egger_p, "\n"))
cat(paste("Kendall's Tau:", kendall_tau, ", p =", kendall_p, "\n\n"))

cat("✓ Both tests are non-significant (p > 0.05)\n")
cat("  Interpretation: No evidence of publication bias\n")

cat("\n✅ Funnel plot saved to: output/figures/funnel_plot.png (1200 DPI)\n")
cat("========================================\n")