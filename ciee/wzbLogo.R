library('ggplot2')
library('extrafont')
loadfonts()
#setwd('/Users/dag/github/diss/presentations/2015-11-9_WiP')
theme_nothing <- function(base_size = 48, base_family = "Helvetica")
  {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
      theme(
            rect             = element_blank(),
            line             = element_blank(),
            text             = element_blank(),
            axis.ticks.margin = grid::unit(0, "lines")
           )
  }
# check that it is a complete theme
attr(theme_nothing(), "complete")
dta <- expand.grid(
  x = 0:1, y = 0:1
)
p <- ggplot(data = dta, aes(x = x, y = y)) +
  geom_blank() +
  geom_point(x = .5, y = .3, colour = '#0380B5', size = 14) +
  geom_point(x = .7, y = .3, colour = '#9E3173', size = 14) +
  geom_point(x = .9, y = .3, colour = '#619933', size = 14) +
  geom_text(x = .475, y = .6, aes(label = 'WZB'),
    family = 'Arial Black', size = 26
  ) +
  geom_text(x = .475, y = .425, aes(label = 'Berlin Social Science Center'),
    family = 'Dahrendorf', size = 4.4
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme_nothing() +
  theme(
    plot.margin = grid::unit(c(0, 0, 0, -.8), units = 'lines'),
    panel.background = element_rect(fill = 'transparent')
  )
png(filename = './wzbLogo.png',
  width = 512, height = 512, units = 'px', res = 180
)
p
dev.off()

