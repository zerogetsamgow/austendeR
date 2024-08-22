library(tidyverse)
library(pdftools)

# Codes saved in a pdf here
unspsc.link =
  "https://data.gov.au/data/storage/f/2013-05-12T202500/tmpocbZxQAusTender-Customised-UNSPSC-Codeset-August-2012.pdf"

# Get text from pdf
unspsc.text =
  unspsc.link |>
  pdftools::pdf_text()


# Clean and convert to tibble
austender_unspsc =
  unspsc.text |>
  str_replace(pattern = "\nand", replacement = "and") |>
  str_remove(pattern = "Management and provision of all facilities engineering modification and maintenance services") |>
  str_replace(pattern = "for a site", replacement = "Management and provision of all facilities engineering modification and maintenance services for a site") |>
  str_replace(pattern = "\\s{2,}", replacement = "") |>
  str_replace(pattern = "s([A-Z])", replacement = "\\1") |>
  str_split(pattern = "\n") |>
  unlist() |>
  tibble() |>
  rename(raw = 1) |>
  mutate(
    unspsc_id = str_extract(raw,"[0-9]{8}"),
    unspsc_group =
      if_else(
        is.na(unspsc_id),str_trim(raw),NA_character_),
    unspsc_group =
      if_else(unspsc_group == "",NA_character_, unspsc_group),
    unspsc_desc = str_remove(raw,unspsc_id) |> str_trim()
  ) |>
  filter((!is.na(unspsc_id)|!is.na(unspsc_group))) |>
  fill(unspsc_group) |>
  filter(!is.na(unspsc_id)) |>
  select(contains("unspsc"))

# Save as rda in data
usethis::use_data(austender_unspsc, overwrite = TRUE)
