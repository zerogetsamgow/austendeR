
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

austenderR contains four datasets.

`austender_suppliers` - containing information on the party providing
the services under the contract. A random example is shown below.

``` r
library(austendeR)
## example of data in austender_suppliers

knitr::kable(
  sample_n(austendeR::austender_suppliers, size = 1) |> 
    pivot_longer(everything()))
```

| name                | value                                 |
|:--------------------|:--------------------------------------|
| ocid                | prod-50845751687a4298ae1ea7ad1c586091 |
| supplier_id         | aba5716994b469bd276bb383b8ce902b      |
| supplier_abn        | 82001166927                           |
| supplier_name       | HUBER & SUHNER (AUSTRALIA) PTY LTD    |
| supplier_country    | AUSTRALIA                             |
| supplier_street     |                                       |
| supplier_locality   | FRENCHS FOREST                        |
| supplier_region     | NSW                                   |
| supplier_postalCode | 2086                                  |

`austender_agencies` - containing information on the party
receiving/paying for the services under the contract. A random example
is shown below.

``` r
## example of data in austender_agenceis

knitr::kable(
  sample_n(austendeR::austender_agencies, size = 1) |> 
    pivot_longer(everything()))
```

| name        | value                                 |
|:------------|:--------------------------------------|
| ocid        | prod-ef55edd795964fdba8968ecb34beb8b0 |
| agency_id   | 0ec8f144aa1c235022aed6c59a7c9e24      |
| agency_abn  | 17864931143                           |
| agency_name | Australian Federal Police             |

`austender_contracts` - containing information about the contract. A
random example is shown below. Note `austenders_contracts` includes
contracts and contract amendments. These are denoted by the `tag`
variable.

``` r
## example of data in austender_contracts

knitr::kable(
  sample_n(austendeR::austender_contracts, size = 1) |> 
    pivot_longer(everything()))
```

| name                  | value                                 |
|:----------------------|:--------------------------------------|
| ocid                  | prod-feabf048ce0a59a959af9de1fa7c23da |
| contract_id           | CN3396792                             |
| contract_unspsc_id    | 46171600                              |
| contract_description  | Safety products and support services  |
| contract_value_amount | 391126.08                             |
| contract_date_signed  | 2017-01-03T13:00:00Z                  |
| contract_date_start   | 2016-12-15T13:00:00Z                  |
| contract_date_end     | 2017-05-30T14:00:00Z                  |
| tag                   | contractAmendment                     |

`austender_unspsc` - containing information about the simplified United
Nations Standard Products and Services Code (UNSPSC) used by Austender
contract. A random example is shown below.

``` r
## example of data in austender_contracts

knitr::kable(
  sample_n(austendeR::austender_unspsc, size = 10)
)
```

| unspsc_id | unspsc_group                                                                       | unspsc_desc                                    |
|:----------|:-----------------------------------------------------------------------------------|:-----------------------------------------------|
| 73180000  | Industrial Production and Manufacturing Services                                   | Machining and processing services              |
| 30140000  | Structures and Building and Construction and Manufacturing Components and Supplies | Insulation                                     |
| 92110000  | National Defence and Public Order and Security and Safety Services                 | Military services and national defence         |
| 42000000  | Laboratory and Measuring and Observing and Testing Equipment                       | Medical Equipment and Accessories and Supplies |
| 72101900  | Building and Construction and Maintenance Services                                 | Interior finishing                             |
| 93100000  | Politics and Civic Affairs Services                                                | Political systems and institutions             |
| 41100000  | Laboratory and Measuring and Observing and Testing Equipment                       | Laboratory and scientific equipment            |
| 49150000  | Sports and Recreational Equipment and Supplies and Accessories                     | Winter sports equipment                        |
| 25131900  | Commercial and Military and Private Vehicles and their Accessories and Components  | Military rotary wing aircraft                  |
| 46181700  | Defence and Law Enforcement and Security and Safety Equipment and Supplies         | Face and head protection                       |

As can be seen in these examples, the three main tender tables contain a
variable `ocid` that enables information from all three to be joined.
`austender_contracts` and `austender_unspsc` can be joined based on
fields containing 8-digit UNSPSC codes, thought the names of these are
different in each table.

## How and when is data updated

Data is added to the package using the `add_new_tenders_from_API.r`
fundtion in `data-raw`.

Historical data will be added semi-regularly. Once a full history is
compiled, data will be added monthly thereon.
