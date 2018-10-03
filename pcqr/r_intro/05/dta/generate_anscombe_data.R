library("tidyr")
anscombe_data <- data.frame(
  x = gather(anscombe, key = "id", value = "x",  1:4)[["x"]],
  y = gather(anscombe, key = "id", value = "y",  5:8)[["y"]],
  row = factor(rep(1:2, each = 22), 1:2, c("Nonlinearity", "Outlier")),
  column = factor(rep(1:2, each = 11), 1:2, paste("Set", 1:2))
)
ggplot(data = anscombe_data, aes(x = x, y = y)) +
  geom_smooth(method = 'lm') +
  geom_point() +
  facet_grid(row ~ column) +
  labs(title = "The Anscombe Quartett") +
  theme_minimal()
