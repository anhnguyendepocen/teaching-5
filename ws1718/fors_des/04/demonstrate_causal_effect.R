# This script generates a graphical explanation of KKV's notion
# of causality. It returns a pdf.
# setup workspace ==========================================
rm(list = ls())
set.seed(12345)
library(extrafont)
loadfonts()

# definitions ----------------------------------------------
o_par <- par()
N <- 30
x <- runif(N, min = 0, max = 1)
realized_x <- quantile(x, .1)

# generate plot --------------------------------------------
#dev.new()
pdf(
  file = "~/github/teaching/ws1718/fors_des/04/demonstrate_causal_effect.pdf",
  width = 4.5, height = 1.2, family = "CMU Sans Serif"
)
# dev.off(); dev.new()
par(
  bg = '#F0F0F0', mfrow = c(1, 3),
  mai = c(0, 0, .5, .1), mar = rep(1, 4), tcl = -.4
)

# (1) realized causal effect
plot(
  x, dunif(x), xlim = c(0, 1), ylim = c(.9, 1), typ = 'n',
  xaxt = "n", yaxt = 'n', xlab = '', ylab = '', bty = 'n',
  main = "Realized causal effect"
)
points(realized_x, dunif(realized_x), pch = 16, col = 'black')
text(
  x = realized_x, y = dunif(realized_x),
  label = expression(y[i]^T - y[i]^C), adj = c(.5, 1.4)
)

# (2) random causal effect
plot(
  x, dunif(x), xlim = c(0, 1), ylim = c(.9, 1), typ = 'n',
  xaxt = "n", yaxt = 'n', xlab = '', ylab = '', bty = 'n',
  main = "Random causal effect"
)

points(x, dunif(x), pch = 16, col = 'grey65', cex = .8)
points(realized_x, dunif(realized_x), pch = 16, col = 'black')
text(
  x = 0.5, y = dunif(0.5),
  label = expression(Y[i]^T - Y[i]^"C"), adj = c(0.5, 1.4)
)

# (3) mean causal effect
plot(
  x, dunif(x), xlim = c(0, 1), ylim = c(.9, 1), typ = 'n',
  xaxt = "n", yaxt = 'n', xlab = '', ylab = '', bty = 'n',
  main = "Mean causal effect"
)
points(x, dunif(x), pch = 16, col = 'grey65', cex = .8)
points(realized_x, dunif(realized_x), pch = 16, col = 'black')
points(.5, dunif(.5), pch = 16, col = "red")
text(x = 0.5, y = dunif(0.5),
  label = expression(mu[i]^T - mu[i]^"C"), adj = c(0.5, 1.4)
)
dev.off()
## housekeeping ============================================
par(o_par)
rm(list = ls())

