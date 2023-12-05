

library(tidyverse)
library(here)
library(rvest)
library(textreuse)

source_dir <- "p_control/krill"
dest_dir <- "p_control/krill/txt/"

extract_qmd <- function(source_dir, dest_ext = "txt") {

  # get list of files
  file_list <- list.files(path = here(source_dir), full.names = TRUE, pattern = "html")

  dest_dir <- file.path(source_dir, dest_ext)
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
}


assignments <- c("p_control/salmon", "p_control/otters", "p_control/krill", "p_control/kjottmeis", "p_control/otoliths") |>
  set_names(basename)
"p_control/lice"
assignments |> map(extract_qmd)


# compare assignments
corpora <- assignments |>
  file.path("txt") |>
  set_names(names(assignments)) |>
  map(\(d)TextReuseCorpus(dir = d))

corpora |> map(skipped)


comparisons <- corpora |>
  map(\(crp)pairwise_compare(crp, jaccard_similarity))


pc <- comparisons |>
  map(pairwise_candidates) |>
  list_rbind(names_to = "assignment")

# plot
pc |>
  group_by(assignment) |>
  mutate(across(c(a, b), str_remove, ".html")) |>
  arrange(-score) |>
  slice(1:10) |>
  View()

ggplot(pc, aes(x = score)) +
  geom_histogram() +
  geom_rug() +
  facet_wrap(vars(assignment))


comparisons |>
  map(t) |>
  map(\(x){
    colnames(x) <- str_remove(colnames(x), "_.*")
    rownames(x) <- str_remove(rownames(x), "_.*")
    x}) |>
  map(as.dist) |>
  map(\(d) hclust(1 - d, method = "single")) |>
  imap(\(h, n){x11(); plot(h, main = n)})
