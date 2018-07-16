rm(list = ls())
library("plotrix")
library("scales")

# defintions -----------------------------------------------
root <- matrix(c(0,1,0,1), nrow = 2, byrow = FALSE)
actor_symbol <- 19
sq <- matrix(c(.5, .7), ncol = 2)
actors <- matrix(
  c(
    .7, .4,
    .2, .7,
    .2, .2
  ), nrow = 3, byrow = TRUE
)

# generate empty plot --------------------------------------
par(mar = rep(0, 4), bg = 'gray95')
plot(root,
  type = 'n', xlim = c(0,1), ylim = c(0,1), asp = 1,
  xaxt = 'n', xlab = '',
  yaxt = 'n', ylab = '', bty = 'n'
)

# place ideal points ---------------------------------------
points(actors, pch = actor_symbol)
text(x = actors, labels = LETTERS[1:nrow(actors)], pos = 4)

# add unanimity core ---------------------------------------
segments(actors[1, 1], actors[1, 2], actors[2, 1], actors[2, 2], lty = "dashed")
segments(actors[2, 1], actors[2, 2], actors[3, 1], actors[3, 2], lty = "dashed")
segments(actors[1, 1], actors[1, 2], actors[3, 1], actors[3, 2], lty = "dashed")

# draw preference sets -------------------------------------
points(sq, pch = actor_symbol)
text(x = sq, labels = "sq", pos = 3)
for(i in 1:(nrow(actors))){
  draw.circle(
    actors[i, 1], actors[i, 2], sqrt(sum((actors[i, ] - sq)^2)),
    lty = 'blank', col = alpha("blue", alpha = .25)
  )
}

# add players ----------------------------------------------
n <- 2
new_actors <- matrix(runif(2 * n), ncol = 2, byrow = TRUE)
points(new_actors, pch = 19)
for(i in 1:(nrow(new_actors))){
  draw.circle(
    new_actors[i, 1], new_actors[i, 2], sqrt(sum((new_actors[i, ] - sq)^2)),
    lty = 'blank', col = alpha("blue", alpha = .25)
  )
}

# increase polarization ------------------------------------
magnifier <- matrix(
  c(0.1, 0, -.1, .1, -.1, -.1),
  nrow = nrow(actors),
  byrow = TRUE
)
actors_prime <- actors + magnifier

# add new ideal points & preference sets -------------------
points(actors_prime, pch = 19)
text(
    x = (actors_prime)[, 1],
    y = (actors_prime)[, 2],
    labels = paste0(LETTERS[1:nrow(actors)], "'"),
    pos = 4
)

segments(actors_prime[1, 1], actors_prime[1, 2], actors_prime[2, 1], actors_prime[2, 2], lty = "dotted")
segments(actors_prime[2, 1], actors_prime[2, 2], actors_prime[3, 1], actors_prime[3, 2], lty = "dotted")
segments(actors_prime[1, 1], actors_prime[1, 2], actors_prime[3, 1], actors_prime[3, 2], lty = "dotted")

for(i in 1:(nrow(actors))){
  draw.circle(
    (actors_prime)[i, 1],
    (actors_prime)[i, 2],
    sqrt(sum(((actors_prime)[i, ] - sq)^2)),
    lty = 'blank', col = alpha("red", alpha = .25)
  )
}

