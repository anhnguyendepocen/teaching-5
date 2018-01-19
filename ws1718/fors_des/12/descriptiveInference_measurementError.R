rm(list = ls())
library('ggplot2')
library('dplyr')
library('extrafont')
loadfonts(quiet = TRUE)

n <- 1000
mu <- 0
bias <- 2
sigma_e <- c(.5, 1, 2)

mu_error <- vapply(
  sigma_e, FUN = function(s){rnorm(n, mu, s)}, numeric(n)
)
mu_bias <- mu_error + bias
pdta <- data.frame(
  type = 'unsystematic',
  mu_error
)
pdta <- rbind.data.frame(
  pdta, data.frame(type = 'systematic', mu_bias)
)
names(pdta) <- c('type', paste0('sigma', 1:length(sigma_e)))
pdta <- gather(pdta, "sigma", "value", 2:ncol(pdta))
pdta <- within(pdta, {
  sigma <- factor(sigma,
    levels = sort(unique(sigma)),
    labels = paste0("epsilon %~% italic(N)(group('', list(mu == Bias, sigma == ", sigma_e, "), ''))")
  )
  type <- factor(type,
    levels = c("unsystematic", "systematic"),
    labels = c(0, bias)
  )
  }
)


p <- ggplot(data = pdta, aes(x = value, fill = type)) +
  geom_vline(xintercept = mu, colour = 'red', width = .3) +
  geom_histogram(binwidth = .2, alpha = .75, position = 'identity') +
  facet_grid(~ sigma, labeller = label_parsed) +
  labs(
    title = "Effekt von Messfehlern auf deskriptive Inferenz",
    y = "Absolute Häufigkeit",
    fill = "Bias"
  ) +
  ggthemes::theme_fivethirtyeight(base_family = 'Times') +
  theme(axis.title = element_text(), axis.title.x = element_blank())
ggsave(plot = p, file = "messfehler.pdf", width = 7, height = 7 / 1.618)

# housekeeping =============================================
rm(list = ls())
detach(package:ggplot2)
detach(package:extrafont)
