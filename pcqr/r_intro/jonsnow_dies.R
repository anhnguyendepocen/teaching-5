rm(list = ls())
books <- c("got", "cok", "sos", "ffc", "dwd")
# binary, what books did the character appear in?
length_in_chapters <- c(73, 70, 82, 46, 73)

deaths <- read.csv2(
  file.path(".", "pcqr", "r_intro", "05", "dta", "asoiaf_deaths.csv"),
  stringsAsFactors = FALSE
)

table(deaths$allegiances, exclude = NULL)
with(deaths,
  table(death_year, book_of_death, exclude = NULL)
)
dubious <- with(deaths,
  which(is.na(death_year) & !is.na(book_of_death))
)
deaths[dubious[1], "death_year"] <- 300

chk_sum <- apply(deaths[, books], 1, sum)
table(chk_sum)

book_of_intro <- vector("numeric", length = nrow(deaths))
for(b in 1:length(books)){
  book_of_intro <- ifelse(
    book_of_intro == 0 & deaths[, books[b]] == 1,
    b, book_of_intro
  )
}
deaths <- data.frame(deaths, book_of_intro)
rm(b, book_of_intro)

deaths <- within(deaths, {died <- !is.na(book_of_death)})
fit <- glm(
  died ~ 0 + allegiances + gender + nobility,
  data = deaths, family = binomial(link = "logit")
)
summary(fit)
with(deaths, table(allegiances, died))
with(deaths, table(allegiances, nobility))
deaths[deaths$name == "Jon Snow", ]


jon snow: stark && targaryan && night's watch