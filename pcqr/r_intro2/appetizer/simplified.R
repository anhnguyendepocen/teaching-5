rm(list = ls())
options(help_type = "html")

packages <- c("tidyverse", "rvest", "ggimage")
for (package in packages) {
    if(!require(package, character.only = TRUE)) {
        install.packages(package, repos = "https://cloud.r-project.org")
        library(package, character.only = TRUE)
    }
}

URL <- "https://bulbapedia.bulbagarden.net/wiki/List_of_Pokémon_by_base_stats_(Generation_VII-present)"
COLUMN_NAMES <- c("id", "pokemon", "hp", "attack", "defense", "sp_attack", "sp_defense", "speed")
LOCAL_DIR <- "~/pokemon_images"
dir.create(LOCAL_DIR)
# Scrape Pokémons from bulbapedia
bulbapedia_page <- URL %>% read_html()
pokemons <- bulbapedia_page %>%
    html_nodes(css = "table") %>%
    `[[`(2) %>%
    html_table() %>%
    select(-2, -10, -11)
names(pokemons) <- COLUMN_NAMES
images <- bulbapedia_page %>%
    html_nodes(css = "table") %>%
    html_nodes("span") %>%
    html_nodes("a") %>%
    html_nodes("img") %>%
    html_attr("src") %>%
    str_replace("//", "http://")
for (image in images) {
    file_name <- str_extract(image, "(?<=/)\\w+\\.png$")
    download.file(image, file.path(LOCAL_DIR, file_name))
}
images <- tibble(
    id = seq(nrow(pokemons)),
    image_file = file.path(LOCAL_DIR, str_extract(images, "(?<=/)\\w+\\.png$")))
pokemons <- inner_join(pokemons, images)

# image <- image_read("/Users/dag/pokemon_images/001MS.png", strip = TRUE)
# image_info(image)
# image_convert(image, format = "png", depth = NULL)
ggplot(data = pokemons[!grepl("MMS.png", pokemons[, "image_file"]), ], aes(x = attack, y = defense)) + geom_image(aes(image = image_file))

cor(pokemons[, c("hp", "attack", "defense", "sp_attack", "sp_defense", "speed")])
pca_fit <- prcomp(
    pokemons[, c("hp", "attack", "defense", "sp_attack", "sp_defense", "speed")],
    center = TRUE, scale = TRUE
)
summary(pca_fit)
screeplot(pca_fit)
biplot(pca_fit)
yhat <- predict(pca_fit, newdata = pokemons)
test <- data.frame(pokemons, yhat[, 1:2])
head(test)
ggplot(
    data = test[!grepl("MMS.png", pokemons[, "image_file"]), ],
    aes(x = PC1, y = PC2)) + geom_image(aes(image = image_file))


pca_fit$sdev
 $ image_file