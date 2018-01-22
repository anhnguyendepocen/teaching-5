# Preamble
rm(list = ls())
set.seed(84420)

# Definitions ==============================================
# constants
n <- 30
reps <- 100
sigma <- c(.1, 1, 2)
beta <- c(2, 1.5)

# variables & output objects
X <- cbind(1, rnorm(n))
beta_estimates <- array(FALSE,
  dim = c(reps, length(beta), length(sigma), 2),
  dimnames = list(
    paste0('iteration_', 1:reps),
    c('intercept', 'slope'),
    paste0("sigma_", sigma),
    c("affects_y", "affects_x")
  )
)

# execute simulation =======================================
# (1) unsystematic error in y
for(s in 1:length(sigma)){         # for each level of error
  for(i in 1:reps) {      # for each round of the simulation
    assign("y", rnorm(n, X %*% beta, sigma[s]))
    beta_estimates[i, , s, 'affects_y'] <- coef(lm(y ~ X[, 2]))
  }
}
# (2) unsystematic error in x
y <- X %*% beta
for(j in 1:length(sigma)){       # for each level of error
  for(i in 1:reps){       # for each round of the simulation
    assign("X_e", rnorm(n, X[, 2], sigma[j]))
    beta_estimates[i, , j, 'affects_x'] <- coef(lm(y ~ X_e))
  }
}

# prepare results for plot =================================
pdta <- data.frame(
  sigma = rep(sigma, each = reps),
  affected = rep(c('y', 'x'), each = reps * length(sigma)),
  rbind.data.frame(
    data.frame(beta_estimates[, , 1, 'affects_y']),
    data.frame(beta_estimates[, , 2, 'affects_y']),
    data.frame(beta_estimates[, , 3, 'affects_y']),
    data.frame(beta_estimates[, , 1, 'affects_x']),
    data.frame(beta_estimates[, , 2, 'affects_x']),
    data.frame(beta_estimates[, , 3, 'affects_x'])
  )
)
pdta <- within(pdta, {
  sigma <- factor(
    sigma,
    levels = sort(unique(sigma)),
    labels = paste(
      "epsilon %~%
        italic(N)(
          group('', list(mu == 0, sigma == ", sort(unique(sigma)), "), '')
        )",
      sep = " "
    )
  )
  affected <- factor(
    as.character(affected),
    levels = c('y', 'x'),
    labels = c('Abhängige~~Var.', 'Unabhängige~~Var.')
  )
  }
)

# plot results =============================================
p <- ggplot(
  data = data.frame(y = X %*% beta, x = X[, 2]),
  aes(x = x, y = y)
) +
  geom_point(colour = 'transparent') + # set scales for plot
  geom_abline(
    data = pdta,
    aes(intercept = intercept, slope = slope),
    alpha = .2
  ) +
  geom_abline(intercept = beta[1], slope = beta[2], colour = 'red') +
  facet_grid(affected ~ sigma, labeller = label_parsed) +
  # labs(
  #   title = "Effekt unsystematischer Messfehler auf kausale Inferenz",
  #   subtitle = expression('"Wahres" Modell:' ~~ y == 2 + 1.5 * x)
  # ) +
  ggthemes::theme_fivethirtyeight(base_family = 'Times') +
  theme(axis.title = element_text())
# ggsave(plot = p, file = "messfehler.pdf", width = 7, height = 7 / 1.618)

## END