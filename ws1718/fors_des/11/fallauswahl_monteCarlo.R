# preamble -------------------------------------------------
rm(list = ls())
library('ggplot2')
library('dplyr'); library('tidyr')

# definitions ----------------------------------------------
set.seed(1708995)
n_samples <- 500
n_size <- c(10, 100, 1000)

# execute experiment ---------------------------------------
results <- vapply(
  n_size,
  FUN = function(x) {
    replicate(n = n_samples, expr = mean(runif(x, 0, 1)))
  },
  FUN.VALUE = numeric(n_samples)
)

# data management for presentation -------------------------
colnames(results) <- n_size
results <- as.data.frame(results)
results <- gather(results, 'n_size', 'value', 1:ncol(results))

# output results -------------------------------------------
p <- ggplot(data = results, aes(x = value)) +
  geom_histogram(binwidth = .01) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, .25)) +
  labs(
    x = expression(bar(x)[Stichprobengröße]),
    y = "Wahrscheinlichkeitsdichte"
  ) +
  facet_wrap(~n_size, nrow = 1) +
  theme_grey(base_size = 24)
p

by(
  results[['value']], results[['n_size']],
  FUN = function(x){
    c(Mittelwert = mean(x), Standardabweichung = sd(x))
  }
)

