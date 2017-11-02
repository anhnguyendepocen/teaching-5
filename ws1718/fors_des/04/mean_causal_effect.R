rm(list = ls())
set.seed(12345)

normal_density <- function(x, mu = 0, sigma = 1){
  (1 / (sigma * sqrt(2 * pi))) * exp(-1 * (x - mu)^2 / (2 * sigma^2))
}

N <- 30
x <- rnorm(N)

pdf(file = "test.pdf", width = 7, height = 7/1.618)
par(bg = '#F0F0F0', mfrow = c(1, 3))
plot(
  x, dnorm(x), xlim = c(-3, 3), ylim = c(0, .5), typ = 'n',
  xaxt = "n", yaxt = 'n', xlab = '', ylab = '', bty = 'n', bg = 'black',
  main = "Realized causal effect:"
)
points(min(x), dnorm(min(x)), pch = 16, col = 'black', cex = 1.5)
text(x = min(x), y = dnorm(min(x)), label = expression(y[i]^T - y[i]^C), adj = c(1.05, 0))

plot(
  x, dnorm(x), xlim = c(-3, 3), ylim = c(0, .5), typ = 'n',
  xaxt = "n", yaxt = 'n', xlab = '', ylab = '', bty = 'n', bg = 'black',
  main = "Random causal effect:"
)
curve(normal_density, from = -3, to = 3, add = TRUE, col = 'grey65')
points(x, dnorm(x), pch = 16, col = 'grey65')
points(min(x), dnorm(min(x)), pch = 16, col = 'black', cex = 1.5)
text(x = min(x), y = dnorm(min(x)), label = expression(y[i]^T - y[i]^C), adj = c(1.05, 0))

plot(
  x, dnorm(x), xlim = c(-3, 3), ylim = c(0, .5), typ = 'n',
  xaxt = "n", yaxt = 'n', xlab = '', ylab = '', bty = 'n', bg = 'black',
  main = "Random causal effect:"
)
curve(normal_density, from = -3, to = 3, add = TRUE, col = 'grey65')
points(x, dnorm(x), pch = 16, col = 'grey65')
points(min(x), dnorm(min(x)), pch = 16, col = 'black', cex = 1.5)
text(x = min(x), y = dnorm(min(x)), label = expression(y[i]^T - y[i]^C), adj = c(1.05, 0))

segments(x0 = 0, y0 = 0, x1 = 0, y1 = dnorm(0), lty = "dashed")
points(0, dnorm(0), pch = 16, col = "red", cex = 1.5)

axis(side = 1, at = 0, labels = expression("Mean causal effect:"~mu[i]^T - mu[i]^"C"))
text(x = -1.2, y = dnorm(-1.2), label = "Random causal effect", srt = 53, adj = c(.2, -.6))
dev.off()
