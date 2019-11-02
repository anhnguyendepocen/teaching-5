set.seed(76633762)
rm(list = ls())
student_data <- data.frame(
  student = c(
    "John", "Angela", "Bullwinkle", "David", "Janice",
    "Cheryl", "Reuven", "Greg", "Joel", "Mary"
  ),
  gender = c(0, 1, 0, 0, 1, 1, 1, 0, 0, 1),
  science = c(502, NA, 412, 358, 495, 512, 410, 625, 573, 522),
  arts = c(95, 99, 80, 82, 75, 85, 80, 95, NA, 86),
  literature = c(25, 22, 18, 15, 20, NA, 15, 30, NA, 18)
)
student_data[, 'student_id'] <- 4e5 + trunc(
  5e5 * runif(nrow(student_data))
)
write.csv(student_data, file = "./pcqr/r_intro/02/dta/student_data.csv", row.names = FALSE)
