# This script simulates R^2 from 100 linear regression on
# 101 normal random variables. All random variables are
# uncorrelated by design.
# Preamble =================================================
rm(list = ls())
library(MASS)
library(ggplot2)
library(ggthemes)

# Definitions ==============================================
set.seed(40353)
n <- 100 # gives n_obs & n_predictors!
r2 <- vector(length = n)
adj_r2 <- vector(length = n)
dta <- mvrnorm(
  n = n + 1, mu = rep(0, length = n + 1),
  Sigma = diag(rep(1, n + 1))
)

# Generate R^2 distributions ===============================
for(i in 2:ncol(dta)){
  assign("fit", lm(dta[, 1] ~ dta[, 2:i]))
  r2[(i-1)] <- 1 - var(resid(fit))/var(dta[, 1])
  df_corr <- (length(resid(fit) - 1)) /
    (length(resid(fit)) - (length(coef(fit) - 1)))
  adj_r2[(i-1)] <- 1 - (1 - r2[(i-1)]) * df_corr
}

# generate plot ============================================
ggplot(
  data = data.frame(x = 1:length(r2), y1 = r2, y2 = adj_r2),
  aes(x = x, y = y1)
) +
  geom_point() +
  scale_x_continuous(
    limits = c(1, length(r2)),
    breaks = c(1, seq(10, 100, 10))
  ) +
  labs(
    x = "Anzahl erklärender Variablen",
    y = expression("Determinantionskoeffizient"~R^2)
  ) +
  theme_fivethirtyeight(
    base_family = "CMU Sans Serif", base_size = 1.5 * 12
  ) +
  theme(axis.title = element_text())

# housekeeping =============================================
rm(list = ls())
detach(package:MASS)
detach(package:ggthemes)
detach(package:ggplot2)
