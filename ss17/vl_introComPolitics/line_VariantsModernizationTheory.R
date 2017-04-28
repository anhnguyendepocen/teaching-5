# Preamble =================================================
rm(list = ls())
library('ggplot2')
library('dplyr'); library('tidyr')
library('extrafont'); loadfonts(quiet = TRUE)

# Constants ------------------------------------------------
N <- 10
slope <- .5
x <- rep(seq(0, 1, length.out = N), 2)
type <- rep(c('classical', 'modern'), each = length(unique(x)))

# Probability of regime transition data --------------------
y_decreasing <- numeric(length = N)
y_decreasing <- .8 - slope * x
y_increasing <- numeric(length = N)
y_increasing[1:N] <- .2 + slope * unique(x)
y_increasing[(N + 1):(N * 2)] <- .4

# Prepare plotting data ------------------------------------
pdta <- data.frame(
  x, mget(ls()[grepl('y_', ls(), fixed = TRUE)]), type
)
rm(list = ls()[!(ls() %in% 'pdta')])

pdta <- gather(pdta, 'variable', 'value', 2:3)
pdta <- within(pdta, {
  type <- factor(
    type,
    levels = c('classical', 'modern'),
    label = c("bold('Endogen')", "bold('Exogen')")
  )
  variable <- factor(
    variable, levels = c('y_decreasing', 'y_increasing'),
    labels = c("Diktatur", "Demokratie")
  )
  }
)

# proceed to plotting --------------------------------------
p <- ggplot(
  data = pdta,
  aes(x = x, y = value, linetype = variable)
) +
  geom_line() +
  scale_x_continuous(
    expand = c(0,0), limits = c(0, 1), breaks = c(0, 1),
    labels = c('arm', 'reich')
  ) +
  scale_y_continuous(
    limits = c(0, 1), breaks = c(0, 1),
    labels = c('niedrig', 'hoch')
  ) +
  labs(
    x = "Reichtum",
    y = "Wahrscheinlichkeit eines\nRegimewechsels",
    linetype = "Übergang zur",
    title = "Varianten der Modernisierungstheorie"
  ) +
  facet_grid(~type, labeller = label_parsed) +
  theme_minimal() +
  theme(
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(colour = 'black'),
    legend.position = 'bottom',
    panel.spacing = grid::unit(2, "lines"),
    plot.title = element_text(hjust = .5),
    plot.margin = grid::unit(c(2, 2, 1, 1), 'lines')
  )
ggsave(
  p, file = "./line_VariantsModernizationTheory.pdf",
  family = 'CMU Sans Serif',
  width = 7, height = 7/1.618
)

# housekeeping =============================================
rm(list = ls())
detach(package:ggplot2)
detach(package:dplyr)
detach(package:tidyr)
detach(package:extrafont)
