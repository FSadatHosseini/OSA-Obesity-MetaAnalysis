# ==============================================
# 01_meta_analysis.R
# Meta-analysis: Sleep Apnea Severity
# (16 studies)
# ==============================================

rm(list = ls())

# 1. Set working directory 
setwd("C:/Users/Pentium/Desktop/Meta_Apnea_Project")

# 2. Load data
data <- read.csv("data/raw_data.csv")

# 3. Show data
cat("📊 Data loaded successfully:\n")
print(data)

# 4. Calculate SE from 95% CI
data$se <- (data$upper - data$lower) / (2 * 1.96)
data$variance <- data$se^2

# 5. Random-effects model (DerSimonian-Laird)
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
se_random <- sqrt(1 / sum(weights_random))
ci_lower <- SMD_random - 1.96 * se_random
ci_upper <- SMD_random + 1.96 * se_random
I2 <- max(0, (Q - df) / Q * 100)
q_pvalue <- pchisq(Q, df, lower.tail = FALSE)

# 6. Results
cat("\n========================================\n")
cat("     RANDOM-EFFECTS META-ANALYSIS\n")
cat("========================================\n")
cat(paste("Number of studies:", nrow(data), "\n"))
cat(paste("Pooled SMD (Cohen's d):", round(SMD_random, 3), "\n"))
cat(paste("95% CI:", round(ci_lower, 3), "to", round(ci_upper, 3), "\n"))
cat(paste("I-squared:", round(I2, 2), "%\n"))
cat(paste("Q-statistic:", round(Q, 2), "\n"))
cat(paste("Q-test p-value:", round(q_pvalue, 4), "\n"))
cat(paste("Tau-squared:", round(tau2, 4), "\n"))
cat("========================================\n")

# 7. Save results
if (!dir.exists("output/tables")) dir.create("output/tables", recursive = TRUE)
write.csv(data[, c("study", "smd", "lower", "upper", "se", "variance")], 
          "output/tables/smd_results.csv", row.names = FALSE)

cat("\n✅ Results saved to: output/tables/smd_results.csv\n")