library(checker)
pak <- read.csv(
  text = 'package, recommended, minimum, message
        tidyverse, "2.0.0", NA, NA
        quarto, NA, NA, NA
        gt, NA, NA, NA
        remotes, NA, NA, NA
        here, NA, NA, NA
        usethis, NA, NA, NA',
  strip.white = TRUE
)

prog <- read.csv(text = 'program, recommended, minimum, message
             rstudio, "2023.03.0", NA, NA
             R, "4.3.1", "4.3.0", NA
             quarto, "1.3.0", NA, NA',
             strip.white = TRUE)
opt <- read.csv(text = 'option, value, message
             "save_workspace", "never", NA
             "load_workspace", "FALSE", "untick <Restore .Rdata into workspace at startup> for reproducibility"
             "insert_native_pipe_operator", "TRUE", "Get the native pipe"',
             strip.white = TRUE)

fs::dir_create("checker")
fs::file_create( "checker/chk_bio300B.yaml")
(chk_make(path = "checker/chk_bio300B.yaml", programs = prog, packages = pak, options = opt))

chk_requirements("checker/chk_bio300B.yaml")

