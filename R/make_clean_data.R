#' code to create a dataset of each contract with most recent contract details

library(tidyverse)
library(duckdb)
library(lubridate)

#' Test to see if datasets exist and load if they do.
#' Else create a NULL object to add to later

if( file.exists("data/austender_suppliers.rda"))
{
  load("data/austender_suppliers.rda")
} else {
  austender_suppliers = NULL
}

if(file.exists("data/austender_agencies.rda"))
{
  load("data/austender_agencies.rda")
} else {
  austender_agencies = NULL
}

if(file.exists("data/austender_contracts.rda"))
{
  load("data/austender_contracts.rda")
} else {
  austender_contracts = NULL
}


if(file.exists("data/austender_unspsc.rda"))
{
  load("data/austender_unspsc.rda")
} else {
  austender_contracts = NULL
}


db <- dbConnect(duckdb())
duck_contracts = copy_to(db, df = austender_contracts,  overwrite = TRUE)
duck_suppliers = copy_to(db, df = austender_suppliers, overwrite = TRUE)
duck_agencies = copy_to(db, df = austender_agencies, overwrite = TRUE)
duck_unspsc = copy_to(db, df = austender_unspsc, overwrite = TRUE)

# Get latest details for each contract
austender_latest =
  duck_contracts |>
  group_by(contract_id) |>
  dbplyr::window_order(
    contract_id,
    desc(contract_date_signed),
    desc(contract_amendment_date),
    desc(contract_amendment_id)) |>
  filter(row_number() == 1) |>
  left_join(
    duck_unspsc,
    by = join_by(contract_unspsc_id == unspsc_id),
    relationship = "many-to-many"
  ) |>
  left_join(
    duck_agencies,
    by = join_by(ocid)
  ) |>
  left_join(
    duck_suppliers,
    by = join_by(ocid)
  ) |>
  select(
    supplier_name,
    supplier_abn,
    agency_name,
    contains("contract"),
    contains("unspsc")) |>
  select(-contains("amend"))

# Replace rda in data with updated set
usethis::use_data(austender_latest, overwrite = TRUE)
