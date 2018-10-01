# c = sqrt(a^2 + b^2)
# π = a_r / a_q

n_of_trials <- 1e7
r <- 1 # radius

# Solution 1: For loop
hit <- vector('logical', length = n_of_trials)
for(k in 1:n_of_trials){
  hit[k] <- sqrt(sum(runif(2, min = 0,  max  = r)^2)) <= r
}
4 * mean(hit)

# Solution 2: apply like functions
darts <- matrix(
    runif(2 * n_of_trials, max = r),
    ncol = 2,
    dimnames = list(NULL, c("x", "y"))
)
hit <- apply(
    darts, 1, FUN = function(i, radius = r){
        sqrt(sum(i^2)) <= radius
    }
)
4 * mean(hit)

# Solution 3: replicate
throw_dart <- function(radius = 1){
    sqrt(sum(runif(2, max = radius)^2)) <= radius
}
hit <- replicate(n_of_trials, throw_dart(radius = r))
4 * mean(hit)

x <- 1:log10(n_of_trials)
y <- vector("double", length = length(x))
for(i in x) { y[i] <- (pi - 4 * mean(hit[1:10^i]))^2 }
plot(x, y, type = 'h')
abline(h = 0)