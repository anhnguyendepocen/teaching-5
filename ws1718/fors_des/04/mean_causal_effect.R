rm(list = ls())
set.seed(12345)

normal_density <- function(x, mu = 0, sigma = 1){
  (1 / (sigma * sqrt(2 * pi))) * exp(-1 * (x - mu)^2 / (2 * sigma^2))
}

mu <- 0
sigma <- 1

N <- 1
x <- rnorm(N)
plot(
  x, dnorm(x), xlim = c(-3, 3), ylim = c(0, .5),
  xaxt = "n", bty = 'n'
)
curve(normal_density, from = -3, to = 3, add = TRUE)
points(0, dnorm(0), pch = 21, bg = "red")
segments(x0 = 0, y0 = 0, x1 = 0, y1 = dnorm(0), lty = "dashed")
axis(side = 1, at = 0, labels = expression(mu[i]^T - mu[i]^"C"))
text(x = x[1], y = dnorm(x[1]), label = expression("Realized causal effect":~y[i]^T - y[i]^C), adj = c(-.1, 0))

