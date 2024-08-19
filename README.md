
<!-- README.md is generated from README.Rmd. Please edit that file -->

# austendeR

<!-- badges: start -->
<!-- badges: end -->

The goal of austendeR is to make data available from the Austenders
API - <https://github.com/austender/austender-ocds-api> - for users of R
without them needing to wrangle with JSON.

AusTender is the Australian Government procurement information system.
The API provides AusTender contract notice data on demand in a standard
machine-readable format, but that format is JSON (urk!).

This package presents the results from the API reformatted as three .rda
files. The package is in the developmental phase. Data is being collated
progressively. Please refer to the `DESCRIPTION` for the current
coverage.

Data contained in this package does not currently include all fields
avaialable via the API.

## Installation

You can install the development version of austendeR like so:

``` r
# install.packages("devtools")
devtools::install_github("zerogetsamgow/austendeR")
```

## Data

austenderR contains three datasets.

`austender_suppliers` - containing information on the party providing
the services under the contract.

``` r
library(austendeR)
## example of data in austender_suppliers

knitr::kable(
  sample_n(austendeR::austender_suppliers, size = 1) |> 
    pivot_longer(everything()))
```

| name                | value                                 |
|:--------------------|:--------------------------------------|
| ocid                | prod-b189497ae0d14554aaa158a6b11a2c0b |
| supplier_id         | abc563a9bd67af7a4692516689194410      |
| supplier_abn        | 80003074468                           |
| supplier_name       | ORACLE CORPORATION AUSTRALIA PTY LTD  |
| supplier_country    | AUSTRALIA                             |
| supplier_street     |                                       |
| supplier_locality   | NORTH RYDE                            |
| supplier_region     | NSW                                   |
| supplier_postalCode | 2113                                  |

`austender_agencies` - containing information on the party
receiving/paying for the services under the contract. A random example
is shown below.

``` r
library(austendeR)

## example of data in austender_suppliers

knitr::kable(
  sample_n(austendeR::austender_agencies, size = 1) |> 
    pivot_longer(everything()))
```

| name        | value                                 |
|:------------|:--------------------------------------|
| ocid        | prod-0e2e8518ac4f457db8aa66d62538b246 |
| agency_id   | d3284cb3cff6a81557614b93587bd740      |
| agency_abn  | 41687119230                           |
| agency_name | CSIRO                                 |

`austender_contracts` - containing information about the contract. A
random example is shown below. A random example is shown below.

``` r
library(austendeR)
## example of data in austender_suppliers

knitr::kable(
  sample_n(austendeR::austender_contracts, size = 1) |> 
    pivot_longer(everything()))
```

| name                  | value                                 |
|:----------------------|:--------------------------------------|
| ocid                  | prod-4e8f31bf4b534d6d9efaab1464d89be3 |
| contract_description  | Office Furniture                      |
| contract_value_amount | 537411.60                             |
| contract_date_signed  | 2024-05-20T21:46:15Z                  |
| contract_date_start   | 2024-03-27T13:00:00Z                  |
| contract_date_end     | 2024-12-29T13:00:00Z                  |

As can be seen in these examples, all three tables contain a variable
`ocid` that enables information from all three to be joined.

## How and when is data updated

Data is added to the package using the `add_new_tenders_from_API.r`
fundtion in `data-raw`.

Historical data will be added semi-regularly. Once a full history is
compiled, data will be added monthly thereon.
