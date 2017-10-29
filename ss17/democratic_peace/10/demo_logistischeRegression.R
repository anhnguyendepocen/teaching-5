set.seed(23501)
N <- 1000
x <- rnorm(N)
y_logit <- 1.6 * x
pr_y <- boot::inv.logit(y_logit)
y_bin <- rbinom(N, 1, prob = pr_y)
summary(y_bin)

lm_fit <- lm(y_bin ~ x)
yhat <- predict(lm_fit)
yhat_glm <- predict(glm(y_bin ~ x, family = binomial(link = 'logit')), type = "response")
ggplot(data = data.frame(x, yhat, y_bin, yhat_glm), aes(x = x)) +
  geom_point(
    aes(
      y = y_bin,
      colour = factor(
        ifelse(yhat > 0 & yhat < 1, 1, 0),
        labels = c("Nein", "Ja")
      )
    )
  ) +
  geom_rug() +
  geom_line(aes(y = yhat), linetype = 'dashed') +
  geom_line(aes(y = yhat_glm)) +
  labs(
    x = "x",
    y = "Pr(y = 1 | x)",
    color = expression(
      "Vorhersagewert" %in% group("[",list(0, 1),"]"))
  ) +
  theme(legend.position = "top")
