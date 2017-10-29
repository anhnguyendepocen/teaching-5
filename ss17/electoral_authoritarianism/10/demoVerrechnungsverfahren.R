rm(list = ls())
set.seed(30485)
library('ggplot2')

n_party <- 4
n_seats <- 10
vote_range <- c(1500, 120000)
imperiali <- diag(2:n_seats, nrow = n_seats-1)
abs_votes <- matrix(
  vote_range[1] + trunc((vote_range[2] - vote_range[1]) * runif(n_party)),
  #c(47000, 16000, 15900, 12000, 6000, 3100),
  nrow = n_seats-1, ncol = n_party, byrow = TRUE,
  dimnames = list(
    paste("Divisor", diag(imperiali)),
    paste('Partei', LETTERS[1:n_party])
  )
)
averages <- t(solve(imperiali)) %*% abs_votes
abs_seats <- matrix(
  0, nrow = n_seats-1, ncol = n_party,
  dimnames = list(
    paste("Divisor", diag(imperiali)),
    paste('Partei', LETTERS[1:n_party])
  )
)
abs_seats[order(averages, decreasing = TRUE)[1:n_seats]] <- 1

ggplot(
  data = data.frame(
    partei = colnames(abs_votes),
    abs_votes = abs_votes[1, ] / sum(abs_votes[1, ]),
    abs_seats = colSums(abs_seats) / sum(colSums(abs_seats))
  ),
  aes(x = reorder(partei, abs_votes))
) +
  geom_point(aes(y = abs_votes, colour = "Stimmen")) +
  geom_point(aes(y = abs_seats, colour = "Sitze (IHA)")) +
  geom_hline(yintercept = .07, linetype = 'dashed') +
  scale_y_continuous(labels = scales::percent) +
  annotate(x = n_party, y = .07, label = "7% Prozenthürde", geom = 'text', hjust = -.05, vjust = -3) +
  labs(colour = "Anteil", y = "", x = "") +
  coord_flip() +
  ggthemes::theme_fivethirtyeight() +
  theme(axis.title = element_blank(), legend.position = "bottom")
