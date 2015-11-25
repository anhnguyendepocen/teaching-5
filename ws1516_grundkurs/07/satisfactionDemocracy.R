# Setup workspace ------------------------------------------
rm(list = ls())
pathData <- '/Users/dag/Dropbox/lehre/ws1516/grundlagenkurs/07/'
pathOut <- pathCode <- pathData
packs <- c('ggplot2', 'dplyr', 'scales', 'grid')
invisible(lapply(packs, library, character.only = TRUE))
rm(packs)

# load data ------------------------------------------------
load(file.path(pathData, 'satdem_22Apr14_prep.Rdata'))
ds <- mutate(
  ds,
  eastwest = ifelse(country %in% c('Austria', 'Belgium',
    'Cyprus (Republic)', 'Denmark', 'Finland', 'France',
    'Germany', 'Greece', 'Ireland', 'Italy', 'Luxembourg',
    'Malta', 'Portugal', 'Spain', 'Sweden',
    'The Netherlands', 'UK'), 'west' , 'east'
  )
) %>%
mutate(
  eastwest = factor(
    eastwest,
    levels = c('east', 'west'),
    labels = c('Osteuropa', 'Westeuropa')
  )
)
with(ds, table(country, eastwest))

ggplot(data = ds, aes(x = year, y = sat.wgt)) +
  stat_summary(fun.data = mean_cl_normal, geom = 'linerange', size = .3) +
  stat_summary(fun.y = mean, geom = 'point', size = 2) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(limits = c(1970, 2015), breaks = seq(1970, 2010, 10)) +
  labs(y = 'Zufriedenheit mit der Demokratie') +
  facet_grid(~eastwest) +
  theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    panel.border = element_rect(fill = 'transparent', colour = 'black', size = .1)
  )

ggplot(data = ds, aes(x = year, y = sat.wgt)) +
  geom_point() +
  geom_smooth(method = 'lm', formula = y ~ poly(x, 3)) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(limits = c(1970, 2015), breaks = seq(1970, 2010, 10)) +
  labs(y = 'Zufriedenheit mit der Demokratie') +
  facet_wrap(~ country) +
  theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    panel.border = element_rect(fill = 'transparent', colour = 'black', size = .1)
  )

# ds %>%                              # yearly satisfaction eu
#   group_by( year ) %>%
#   mutate( mean = mean( sat.wgt , na.rm = TRUE )) %>%
#   select( year , mean ) %>%
#   unique( ) -> eu
#
# ds %>%                  # yearly satisfaction western europe
#   filter( eastwest == 'west' ) %>%
#   group_by( year ) %>%
#   mutate( mean = mean( sat.wgt , na.rm = TRUE )) %>%
#   select( year , mean ) %>%
#   unique( ) -> west
#
# ds %>%                  # yearly satisfaction eastern europe
#   filter( eastwest == 'east' ) %>%
#   group_by( year ) %>%
#   mutate( mean = mean( sat.wgt , na.rm = TRUE )) %>%
#   select( year , mean ) %>%
#   unique( ) -> east
#
# ggplot() +
#   geom_bar( data = eu , aes( x = year , y = mean ) , color = 'white' , fill = 'grey' , stat="identity" ) +
#   geom_line( data = subset( west ) , aes( x = year , y = mean ) , linetype = 1 , size = 1 ) +
#   geom_line( data = east , aes( x = year , y = mean ) , linetype = 2 , size = 1 ) +
#   scale_y_continuous( limit = c( 0 , .8 )
#                       , breaks = seq( 0 , .8 , .1 )
#                       , labels = percent
#                       , name = 'Satisfaction with Democracy' ) +
#   scale_x_continuous( breaks = seq( 1973 , 2013 , 2 )
#                       , name = '' ) +
#   theme_bw( base_size = 20  , base_family = 'serif' ) +
#   theme( axis.text.x = element_text(angle = 45, hjust= 1 )
#          , axis.title.y=element_text( vjust = 1.5 )
#          , panel.grid.major.y = element_line( color = 'black' , linetype = 2 )
#          , legend.key = element_blank()
#          , legend.key.width = unit( 2 , "cm" ) )

detach( package:dplyr )
detach( package:scales )
detach( package:grid )
detach( package:ggplot2 )
