

library(tidyverse)
library(here)
library(rvest)
library(textreuse)

source_dir <- "p_control/krill"
dest_dir <- "p_control/krill/txt/"

# get list of files
file_list <- list.files(path = here(source_dir), full.names = TRUE, pattern = "html")
file_list

fs::dir_create(dest_dir)
file_list |>
  walk(\(f){
    print(f)
  # 1 extract quarto from html
  read_html(f) |>
    html_elements(xpath = '//*[@id="quarto-embedded-source-code-modal"]') |> #"div.modal") |>
    html_text2() |>
    # save as txt
    write_lines(file.path(dest_dir, paste0(basename(f), ".txt")))
})

# compare assigments
txt_comp <- TextReuseCorpus(dir = dest_dir)
skipped(txt_comp)
comparisons <- pairwise_compare(txt_comp, jaccard_similarity, progress = FALSE)
pc <- pairwise_candidates(comparisons)

# plot
pc |>
  arrange(-score)
ggplot(pc, aes(x = score)) +
  geom_histogram()


