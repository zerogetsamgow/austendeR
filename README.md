
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
| ocid                | prod-b35c11ec025d4e41ad76fa8bfa3e5535 |
| supplier_id         | bbd12d2dd6c330989e5ba5428bbe40fd      |
| supplier_abn        | 47000067541                           |
| supplier_name       | Chubb Fire & Security Pty Ltd         |
| supplier_country    | AUSTRALIA                             |
| supplier_street     | NA                                    |
| supplier_locality   | Sydney                                |
| supplier_region     | NSW                                   |
| supplier_postalCode | 2116                                  |

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
| ocid        | prod-a18e3a2b2c054d8497768f5c6d60c6df |
| agency_id   | 0ec9911c9e99d1b7bb1b77f4abffc583      |
| agency_abn  | 62950639680                           |
| agency_name | Department of Defence                 |

`austender_contracts` - containing information about the contract. A
random example is shown below. A random example is shown below. Note
`austenders_contracts` includes contracts and contract amendments. These
are denoted by the `tag` variable.

``` r
library(austendeR)
## example of data in austender_suppliers

knitr::kable(
  sample_n(austendeR::austender_contracts, size = 1) |> 
    pivot_longer(everything()))
```

| name                  | value                                        |
|:----------------------|:---------------------------------------------|
| ocid                  | prod-9cafe389e7e845488e99265281b663c1        |
| contract_description  | Provision of printer usage and leasing costs |
| contract_value_amount | 695283.84                                    |
| contract_date_signed  | 2022-04-22T04:03:06Z                         |
| contract_date_start   | 2021-11-29T13:00:00Z                         |
| contract_date_end     | 2024-02-28T13:00:00Z                         |
| tag                   | contract                                     |

As can be seen in these examples, all three tables contain a variable
`ocid` that enables information from all three to be joined.

## How and when is data updated

Data is added to the package using the `add_new_tenders_from_API.r`
fundtion in `data-raw`.

Historical data will be added semi-regularly. Once a full history is
compiled, data will be added monthly thereon.
