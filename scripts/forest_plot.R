# ==============================================
# FOREST PLOT - FINAL VERSION
# With parentheses around years, adjusted label positions
# ==============================================

rm(list = ls())
graphics.off()

# 1. Data (ordered ALPHABETICALLY A to Z) 
results <- data.frame(
  Study = c(
    "Andersen et al. (2019)",
    "Baker et al. (2017)",
    "Caliendo et al. (2023)",
    "Dayyat et al. (2009)",
    "Dékány et al. (2023)",
    "Fernandes do Prado et al. (2002)",
    "Gozal et al. (2009)",
    "Herttrich et al. (2020)",
    "Kang et al. (2012)",
    "Lam et al. (2006)",
    "Narayanan et al. (2019)",
    "Rudnick et al. (2007)",
    "Scott et al. (2016)",
    "Su et al. (2015a)",
    "Su et al. (2015b)",
    "Wang et al. (2019)",
    "Xu et al. (2008)"
  ),
  
  SMD = c(0.838, 0.376, 0.154, 0.139, 0.478, -0.103,
          -0.686, 0.271, 0.919, 0.622, 0.281, 0.089,
          0.174, 0.424, 0.854, 0.706, 1.160),
  
  Lower = c(0.448, 0.033, -0.379, -0.055, 0.322, -0.581,
            -1.089, -0.050, 0.520, 0.405, -0.016, -0.483,
            -0.138, 0.220, 0.693, 0.429, 0.667),
  
  Upper = c(1.228, 0.719, 0.687, 0.333, 0.634, 0.375,
            -0.283, 0.592, 1.318, 0.839, 0.578, 0.660,
            0.486, 0.628, 1.015, 0.983, 1.653)
)

# 2. Calculate pooled SMD
k <- nrow(results)
y_pos <- k:1

weights_fixed <- 1 / ((results$Upper - results$Lower) / (2 * 1.96))^2
SMD_fixed <- sum(results$SMD * weights_fixed) / sum(weights_fixed)
Q <- sum(weights_fixed * (results$SMD - SMD_fixed)^2)
df <- k - 1

if (Q > df) {
  tau2 <- (Q - df) / (sum(weights_fixed) - sum(weights_fixed^2)/sum(weights_fixed))
} else {
  tau2 <- 0
}

weights_random <- 1 / (((results$Upper - results$Lower) / (2 * 1.96))^2 + tau2)
SMD_random <- sum(results$SMD * weights_random) / sum(weights_random)
se_random <- sqrt(1 / sum(weights_random))
ci_lower_random <- SMD_random - 1.96 * se_random
ci_upper_random <- SMD_random + 1.96 * se_random
I2 <- max(0, (Q - df) / Q * 100)
q_pvalue <- pchisq(Q, df, lower.tail = FALSE)

# 3. Open graphics window
windows(width = 12, height = 9)

# 4. Plot with NO automatic x-axis
par(mar = c(5, 14, 4, 5), mgp = c(2.5, 0.6, 0), 
    cex.main = 1.2, cex.lab = 1.1, family = "serif")

plot(NA, xlim = c(-1.5, 2.2), ylim = c(0.5, k + 0.5),
     xlab = "Standardized Mean Difference (SMD)",
     ylab = "", yaxt = "n",
     xaxt = "n",
     main = "Forest Plot: Sleep Apnea Severity\nObese vs. Non-obese Children")

# 5. Draw X-axis MANUALLY
axis(side = 1, at = c(-1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2), 
     labels = c("-1.5", "-1", "-0.5", "0", "0.5", "1", "1.5", "2"),
     cex.axis = 0.9)

# 6. Vertical lines
abline(v = 0, lty = 2, col = "gray50", lwd = 1.5)
abline(v = SMD_random, lty = 1, col = "red", lwd = 2)

# 7. Draw studies
for (i in 1:k) {
  lines(x = c(results$Lower[i], results$Upper[i]), 
        y = c(y_pos[i], y_pos[i]), 
        lwd = 1.5, col = "gray40")
  
  points(x = results$SMD[i], y = y_pos[i], 
         pch = 15, col = "darkblue", cex = 1.2)
}

# 8. Study names
axis(side = 2, at = y_pos, labels = results$Study, 
     las = 1, cex.axis = 0.55, tick = FALSE, line = -0.5)

# 9. Labels - WITH ADJUSTED POSITIONS
# "No effect" (from k + 0.2 to k + 0.6)
text(x = 0, y = k + 0.6, labels = "No effect", col = "gray50", cex = 0.8)

# "Pooled SMD" (from 0.8 to 0.4)
text(x = SMD_random, y = 0.4, 
     labels = paste("Pooled SMD =", round(SMD_random, 2), 
                    " (95% CI:", round(ci_lower_random, 2), "-", round(ci_upper_random, 2), ")"),
     col = "red", cex = 0.7)

# 10. I² and Q-test
text(x = 2.0, y = k - 1, 
     labels = paste("I² =", round(I2, 1), "%"), 
     col = "darkgreen", cex = 0.8, adj = 1)

text(x = 2.0, y = k - 1.6, 
     labels = "Q-test p < 0.001", 
     col = "darkgreen", cex = 0.7, adj = 1)

# 11. Legend
legend( x = 1.65, y = 2.65 , 
        legend = c("Individual studies", "Pooled effect", "No effect"),
        col = c("darkblue", "red", "gray50"),
        pch = c(15, NA, NA),
        lty = c(NA, 1, 2),
        bty = "n", cex = 0.7)

# 12. Save
if (!dir.exists("output/figures")) dir.create("output/figures", recursive = TRUE)

png(filename = "output/figures/forest_plot.png",
    width = 10, height = 8, units = "in", res = 300)

par(mar = c(4, 13, 4, 4), mgp = c(2.5, 0.5, 0), cex.main = 0.9)
plot(NA, xlim = c(-1.5, 2.2), ylim = c(0.5, k + 0.5),
     xlab = "Standardized Mean Difference (SMD)",
     ylab = "", yaxt = "n",
     xaxt = "n",
     main = "Forest Plot: Sleep Apnea Severity\nObese vs. Non-obese Children")
axis(side = 1, at = c(-1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2), 
     labels = c("-1.5", "-1", "-0.5", "0", "0.5", "1", "1.5", "2"),
     cex.axis = 0.9)
abline(v = 0, lty = 2, col = "gray50", lwd = 1.5)
abline(v = SMD_random, lty = 1, col = "red", lwd = 2)
for (i in 1:k) {
  lines(x = c(results$Lower[i], results$Upper[i]), y = c(y_pos[i], y_pos[i]), lwd = 1.5, col = "gray40")
  points(x = results$SMD[i], y = y_pos[i], pch = 15, col = "darkblue", cex = 1.2)
}
axis(side = 2, at = y_pos, labels = results$Study, las = 1, cex.axis = 0.55, tick = FALSE, line = -0.5)
text(x = 0, y = k + 0.6, labels = "No effect", col = "gray50", cex = 0.8)
text(x = SMD_random, y = 0.4, 
     labels = paste("Pooled SMD =", round(SMD_random, 2), 
                    " (95% CI:", round(ci_lower_random, 2), "-", round(ci_upper_random, 2), ")"),
     col = "red", cex = 0.7)
text(x = 2.0, y = k - 1, labels = paste("I² =", round(I2, 1), "%"), col = "darkgreen", cex = 0.8, adj = 1)
text(x = 2.0, y = k - 1.6, labels = "Q-test p < 0.001", col = "darkgreen", cex = 0.7, adj = 1)
legend("bottomright", legend = c("Individual studies", "Pooled effect", "No effect"),
       col = c("darkblue", "red", "gray50"), pch = c(15, NA, NA), lty = c(NA, 1, 2),
       bty = "n", cex = 0.7)

dev.off()

# 13. Summary
cat("\n========================================\n")
cat("Studies ordered alphabetically (A to Z):\n")
cat("========================================\n")
for (i in 1:k) {
  cat(paste(i, "-", results$Study[i], "\n"))
}
cat("\n")
cat(paste("Pooled SMD:", round(SMD_random, 3), "\n"))
cat(paste("95% CI:", round(ci_lower_random, 3), "to", round(ci_upper_random, 3), "\n"))
cat(paste("I-squared:", round(I2, 1), "%\n"))
cat("========================================\n")