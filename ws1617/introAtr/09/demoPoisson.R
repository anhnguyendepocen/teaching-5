# preamble =================================================
library('ggplot2'); library('tidyr')
# Poisson regression models count data
# count data = realization of a discrete random variable, e.g. n \in N
# log of y is modeled as a linear function of x and beta
# often also log-linear model (contingency table analysis)
# E(Y | x) = e^{\alpha + x\beta'}

# population parameters ====================================
n <- 1000
lambda <- c(1, 5 , 9)

lambda <- seq(0, 10, length.out = 1000)
plot(lambda, log(lambda), type = 'l')

# Regular poisson distribution =============================
x <- vapply(
  lambda,
  FUN = function(l){rpois(n = n, lambda = l)},
  numeric(n)
)
colnames(x) <- paste0('l', lambda)
x <- as.data.frame(x)

# plot distributions ---------------------------------------
pdta <- gather(x, 'lambda', 'value', 1:3)
ggplot(data = pdta, aes(x = value)) +
  geom_bar() +
  facet_grid(~lambda)

# summarize ------------------------------------------------
apply(x, 2, function(y){cbind(mean = mean(y), var = var(y))})

# simulate mu != var ---------------------------------------
# overdispersion: var > mean
# underdispersion: var < mean
size <- lambda; lambda <- 5
x <- vapply(
  size,
  FUN = function(s){rnbinom(n = n, mu = lambda, size = s)},
  numeric(n)
)
colnames(x) <- paste0('d', size)
x <- as.data.frame(x)

pdta <- gather(x, 'disp', 'value', 1:3)
ggplot(data = pdta, aes(x = value)) +
  geom_bar() +
  facet_grid(~disp)

apply(x, 2, function(y){cbind(mean = mean(y), var = var(y))})
