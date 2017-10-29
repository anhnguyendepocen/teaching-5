rm(list = ls())
library('dplyr'); library('tidyr')

# load student data
n_students <- 27
n_sessions <- 6
grades <- matrix(
  c(
NA, NA, NA, NA, NA, NA, 2.7, 1.3, 2.3, 1.3, 2.7, 1, 2.3,
1.3, 1.7, 1.7, 1, 1.3, NA, NA, NA, NA, NA, NA, NA, NA, NA,
NA, NA, NA, NA, NA, NA, NA, NA, NA, 2, 3.7, 2, 2, 2, 1.7, 2,
1, 1, 1, 1, 1, NA, 1.3, 1.3, 2, 1.7, NA, 1.3, 1.7, 1, 1.7,
1, 1, 3, 2.3, 1.3, 1.3, 1.3, 1, NA, NA, NA, NA, NA, NA, 2.3,
1.3, 1.7, 1.7, 2.3, 1.7, 1.3, NA, 1.7, 1.3, NA, 1.3, 1.3,
1.3, 1.7, 1.7, 2.7, 1, 1.3, 1.7, 1, 2, 1.3, NA, 1.7, 1.3, 1,
1.3, 1, 1.7, 2.7, 2.3, 1.3, 1.7, 2.3, 1.7, NA, NA, NA, NA,
NA, NA, 1.7, 1.7, 1.7, 1.3, 1, 1.3, 2, 1, 1, 1, 1, 1, 2.3,
1.3, 1.7, 2.3, NA, NA, NA, 1.3, 1.3, 1.7, NA, 1.7, 2.7, 2.3,
2, NA, 1.7, 1.3, 2.3, NA, NA, 1.7, NA, 1.3, 2.7, 2.7, 2.7,
3.7, NA, NA, 2.3, NA, 2, 2.3, 1.3, NA
  ),
  nrow = n_students, ncol = n_sessions, byrow = TRUE,
  dimnames = list(NULL, paste0('s', 1:n_sessions))
)
# drop inactive students
grades <- grades[!(rowSums(is.na(grades)) == n_sessions), ]
student_id <- replicate(
  nrow(grades),
  paste(
    sample(letters, 3, replace = TRUE), collapse = ""
  )
)
student_data <- data.frame(student_id = student_id, grades)
student_data <- gather(student_data, 'session', 'value', s1:s6)
student_data <- within(student_data,
  t <- ave(as.numeric(session), student_id, FUN = seq_along)
)
head(student_data)


# toy analysis
library('ggplot2')
p <- ggplot(data = student_data, aes(x = as.numeric(t), y = value))
p +
  geom_smooth(method = 'lm', se = FALSE) + geom_point() +
  facet_wrap(~student_id)
p + geom_boxplot(aes(x = as.factor(t)))
p_export <- ggplot(data = student_data, aes(x = factor(t), y = value)) +
  geom_jitter(position = position_jitter(width = .02, height = 0)) +
  stat_summary(fun.data = mean_cl_normal, fun.args = list(conf.int = .9), colour = "maroon") +
  scale_x_discrete(labels = c("1" = "08.05.", "2" = "15.05.", "3" = "22.05.", "4" = "29.05.", "5" = "12.06.", "6" = "19.06.")) +
  labs(
    y = "Note", x = "Sitzung",
    title = "Bewertungsentwicklung",
    subtitle = "Die Auswertung berücksichtigt 126 Zusammenfassungen.\nMittelwert und Konfidenzintervalle (alpha = 0.1) werden rot dargestellt."
  ) +
  theme_light() +
  theme(axis.text.x = element_text())
ggsave(
  plot = p_export,
  file = file.path("ss17", "electoral_authoritarianism", "10", "grades_development.pdf"),
  width = 7, height = 7/1.618
)
library('lme4')
fit <- lmer(
  value ~ (1 | student_id) + (1 | session), data = student_data
)
ranef(fit)

plot(density(ranef(fit)[['student_id']][, 1]))
plot(density(ranef(fit)[['session']][, 1]))


