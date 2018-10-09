rm(list = ls())
books <- c("got", "cok", "sos", "ffc", "dwd")
# binary, what books did the character appear in?
length_in_chapters <- c(73, 70, 82, 46, 73)
time_till_book <- c(0, cumsum(length_in_chapters[1:4]))
names(time_till_book) <- books
deaths <- read.csv2(
  file.path(".", "pcqr", "r_intro", "05", "dta", "asoiaf.csv"),
  stringsAsFactors = FALSE
)
deaths[, "book_of_intro"] <- 0
for(i in 1:length(books)){
  filter <- deaths[["book_of_intro"]] == 0 & deaths[, books[i]] == 1
  deaths[filter, "book_of_intro"] <- i
}
rm(i, filter)
write.csv2(
  x = deaths,
  file.path(".", "pcqr", "r_intro", "05", "dta", "asoiaf.csv"),
  row.names = FALSE
)

deaths[, "exit"] <- NA
survived <- which(is.na(deaths[['book_of_death']]))
deaths[survived, "exit"] <- sum(length_in_chapters)
deaths[-survived, "exit"] <-
  time_till_book[deaths[-survived, "book_of_death"]] +
  deaths[-survived, "chapter_of_death"]
rm(survived)
deaths[, "intro"] <- NA
deaths[, "intro"] <-
  time_till_book[deaths[, "book_of_intro"]] +
  deaths[, "book_intro_chapter"]
deaths <- within(deaths, {
  chapter_age <- exit - intro
  }
)

summary(deaths)
plot(ecdf(deaths$chapter_age))
View(deaths[which(deaths$chapter_age < 0), ])
deaths[which(deaths[["chapter_age"]] < 0), "chapter_age"] <- 0

summary(deaths)
# sapply(
#   1:length(books),
  #FUN = function(x){
    deaths[["book_of_intro"]] == 0 &
  #}
#)

book_of_intro
for(b in 1:length(books)){
  book_of_intro <- ifelse(
    deaths[, "book_of_intro"] == 0 & deaths[, books[b]] == 1, b, deaths[, "book_of_intro"]
  )
}
summary(deaths)
deaths[, "intro"] <- NA
filter <- deaths[, "book_of_intro"] == 1
deaths[filter, ] <- deaths[filter, "book_intro_chapter"]


length_in_chapters[1:deaths[1, "book_of_intro"]]

deaths[1, "book_of_intro"]
# deaths[, "book_intro_chapter"]



if(deaths[, "book_of_intro"] != 1){
    sum(c(73, 70, 82, 46, 73)[1:(deaths[, "book_of_intro"] - 1)])
}


deaths <- within(deaths, {
  entry <- ifelse(
    book_of_intro != 1,
    sum(c(73, 70, 82, 46, 73)[1:(book_of_intro - 1)]) + book_intro_chapter,
    book_intro_chapter
  )
  }
)
summary(deaths)
sum(length_in_chapters)

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
