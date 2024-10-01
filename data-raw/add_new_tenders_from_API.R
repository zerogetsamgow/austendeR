## code to prepare `add_new_tenders_from_API` dataset goes here
#' This code allows you to add
#'

library(tidyverse)
library(jsonlite)

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


#' Define functions for cleaning data from API
#' `get_suppliers`
#'
#'
#'
get_suppliers <- function(df) {
  # A function to extract supplier variables from Austender JSON releases extract
  test <<- df
  df |>
    # Select ocid and parties from releases df
    select(ocid, parties) |>
    # unnest parties variable wider
    unnest_wider(parties, names_sep = "_") |>
    # The supplier is the first party to each contract in Austenders
    # rename accordingly and select ocid and supplier
    select(
      ocid,
      "supplier" = parties_1) |>
    # Now unnest supplier data longer creating supplier_id and supplier columns
    # The former contains the names of the data and the latter the data
    unnest_longer(supplier) |>
    # Then pivot data wider to create a column for each name
    pivot_wider(
      names_from = supplier_id,
      values_from = supplier,
      names_prefix="supplier_"
    ) |>
    # Then unnest these columns wider still
    unnest_wider(
      contains("supplier_"),
      names_sep = "_"
    )
  # On occasion list will only include foreign supplies, so no ABN
  # Need if to handle
  if("supplier_additionalIdentifiers_1" %in% names(df)) {
    df |>
    # Which leaves one last column to widen (this contains ABNs)
    unnest_wider(supplier_additionalIdentifiers_1, names_sep = ".") }

  df |>
    # Now we have our data we can clean the names and select data we want.
    select(contains("id"), contains("name"), contains("address")) |>
    select(-contains("contact"),-contains("scheme")) |>
    rename_with(\(x) str_replace(x,"\\.id","abn")) |>
    rename_with(\(x) str_remove_all(x,"additionalIdentifiers|(A|a)ddress(_)*|Name|_1"))
}

#' `get_agencies`
#'
get_agencies = function(df) {
  # A function to extract agency variables from Austender JSON releases extract
  df |>
    # Select ocid and parties from releases df
    select(ocid, parties) |>
    # unnest parties variable wider
    unnest_wider(parties, names_sep = "_") |>
    # The agency is the second party to each contract in Austenders
    # rename accordingly and select ocid and agency
    select(
      ocid,
      "agency" = parties_2) |>
    # Now unnest agency data longer creating supplier_id and supplier columns
    # The former contains the names of the data and the latter the data
    unnest_longer(agency) |>
    # Then pivot data wider to create a column for each name
    pivot_wider(
      names_from = agency_id,
      values_from = agency,
      names_prefix="agency_") |>
    # Then unnest these columns wider still
    unnest_wider(
      contains("agency_"),
      names_sep = "_"
    ) |>
    # Which leaves one last column to widen (this contains ABNs)
    unnest_wider(agency_additionalIdentifiers_1, names_sep = ".") |>
    # Now we have our data we can clean the names and select data we want.
    select(contains("id"), contains("name")) |>
    select(-contains("scheme")) |>
    rename_with(\(x) str_replace(x,"\\.id","_abn")) |>
    rename_with(\(x) str_remove_all(x,"_additionalIdentifiers|_1"))
}

get_contracts = function(df) {
  # A function to extract contract variables from Austender JSON releases extract
  amendments <<- df |>
    select(ocid, tag) |>
    unnest_longer(tag) |>
    filter(str_detect(tag,"Amendment"))

  if(nrow(amendments)>0){

  df |>
    # Select ocid and contracts from releases df
    select(ocid, contracts, tag) |>
    # unnest contracts variable wider
    unnest_longer(contracts) |>
    unnest_longer(tag) |>
    # unnest the value variable wider again
    unnest_wider(contracts, names_sep = "_") |>
    unnest_wider(contracts_value, names_sep = "_") |>
    unnest_wider(contracts_period, names_sep = "_") |>
    unnest_longer(contracts_items) |>
    unnest_wider(contracts_items, names_sep = "_") |>
    unnest_wider(contracts_items_classification, names_sep = "_") |>
    unnest_wider(contracts_amendments, names_sep = "_") |>
    unnest_wider(contracts_amendments_1, names_sep = "_") |>
    # Now we have our data we can clean the names and select data we want.
    select(ocid,
           contracts_id,
           contains("classification_id"),
           contains("description"),
           contains("amount"),
           contains("date"),
           contains("amendments_1_id"),
           tag) |>
    rename_with(\(x) str_replace(x,"contracts","contract")) |>

    rename_with(\(x) str_replace(x,"_period","_date")) |>
    rename_with(\(x) str_replace(x,"classification","unspsc")) |>
    rename_with(\(x) str_replace(x,"S","_s")) |>
    rename_with(\(x) str_remove(x,"Date|_items|s_1"))
  } else
  {
    df |>
      # Select ocid and contracts from releases df
      select(ocid, contracts, tag) |>
      # unnest contracts variable wider
      unnest_longer(contracts) |>
      unnest_longer(tag) |>
      # unnest the value variable wider again
      unnest_wider(contracts, names_sep = "_") |>
      unnest_wider(contracts_value, names_sep = "_") |>
      unnest_wider(contracts_period, names_sep = "_") |>
      unnest_longer(contracts_items) |>
      unnest_wider(contracts_items, names_sep = "_") |>
      unnest_wider(contracts_items_classification, names_sep = "_") |>
      # Now we have our data we can clean the names and select data we want.
      select(ocid,
             contracts_id,
             contains("classification_id"),
             contains("description"),
             contains("amount"),
             contains("date"),
             tag) |>
      rename_with(\(x) str_replace(x,"contracts","contract")) |>
      rename_with(\(x) str_replace(x,"_period","_date")) |>
      rename_with(\(x) str_replace(x,"classification","unspsc")) |>
      rename_with(\(x) str_replace(x,"S","_s")) |>
      rename_with(\(x) str_remove(x,"Date|_items|s_1"))

  }
}

#' `get_releases`
#'
get_releases <- function(df) {
  # If we have release data
  if(length(df$json$releases) > 0) {

    # Extract releases from df$json
    releases <-
      tibble(json = df$json$releases) |>
      unnest_wider(json)

    # Test for duplicates - contracts that have been amended
    amendments <- releases |>
      select(ocid, tag) |>
      unnest_longer(tag) |>
      filter(str_detect(tag,"Amendment"))

    # remove amended contracts from releases to process for supplier and contractor details
    originals <-
      releases |>
      filter(!ocid %in%  amendments$ocid)

   if(nrow(originals) > 0) {
      # get supplier details
      suppliers = get_suppliers(originals)

      # get agency details
      agencies = get_agencies(originals)
    } else {
      suppliers = agencies = NULL
    }

    # get contracts details for all releases
    contracts = get_contracts(releases)

    # Return data as a named list
    list(suppliers = suppliers,
         agencies = agencies,
         contracts = contracts
         )

  } else {
    NULL
  }
}

#' `get_tender_json`
#'
get_tenders_json <- function(start_date, end_date) {

  suppliers <- agencies <- contracts <- df <- NULL

  get_next_url <- function(df) {
    url_base <- "https://api.tenders.gov.au/ocds/findByDates/contractPublished/"
    url <- str_glue("{url_base}{start_date}T00:00:00Z/{end_date}T23:59:59Z")

    if (is.null(df)) {
      return(url)
    } else {
      df <-
        tibble(json = df$json[8]) |>
        unnest_wider(json)

      if ("next" %in% names(df)) {
        df |>
          select(`next`) |>
          pull()
      } else {
        return(NULL)
      }
    }
  }

  while (!is.null(url <- get_next_url(df))) {
    df <- tibble(json = read_json(url))
    releases <- get_releases(df)

    if (!is.null(releases)) {
      suppliers <- bind_rows(suppliers, releases[["suppliers"]])
      contracts <- bind_rows(contracts, releases[["contracts"]])
      agencies <- bind_rows(agencies, releases[["agencies"]])
    }
  }

  list(
    suppliers = suppliers,
    agencies = agencies,
    contracts = contracts
  )

}

# Run this line of code to add tenders for a specific date range
results <- get_tenders_json("2019-1-1", "2019-12-31")

# Add suppliers from query to existing data
austender_suppliers =
  bind_rows(
    austender_suppliers,
    results$suppliers
    ) |>
  # Ensure there are no duplicates
  unique()

# Replace rda in data with updated set created from above
usethis::use_data(austender_suppliers, overwrite = TRUE)

# Add agencies from query to existing data
austender_agencies =
  bind_rows(
    austender_agencies,
    results$agencies
  ) |>
  # Ensure there are no duplicates
  unique()

# Replace rda in data with updated set
usethis::use_data(austender_agencies, overwrite = TRUE)

# Add contracts from query to existing data
austender_contracts =
  bind_rows(
    austender_contracts,
    results$contracts
   ) |>
  mutate(
    across(contains("date"),ymd_hms),
    across(contains("value"),as.numeric)
  ) |>
  # Ensure there are no duplicates
  unique()

# Replace rda in data with updated set
usethis::use_data(austender_contracts, overwrite = TRUE)

