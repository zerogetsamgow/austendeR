
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
| ocid                | prod-9bec32efca0747999bf2a975940c9d6b |
| supplier_id         | af7d1748ef37decd2a6440a4d35e2614      |
| supplier_abn        | 55921612267                           |
| supplier_name       | PLANEX SALES PTY LTD                  |
| supplier_country    | AUSTRALIA                             |
| supplier_street     |                                       |
| supplier_locality   | HALLAM                                |
| supplier_region     | VIC                                   |
| supplier_postalCode | 3803                                  |
| id                  | NA                                    |
| originalid          | NA                                    |

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
| ocid        | prod-c44519653a9f456194942903068e34dc |
| agency_id   | 3e8a6e49ad6a089682fe57bba6072633      |
| agency_abn  | 22323254583                           |
| agency_name | Australian Signals Directorate        |

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

| name                                       | value                                                                                                              |
|:-------------------------------------------|:-------------------------------------------------------------------------------------------------------------------|
| ocid                                       | prod-5f4bdffd04379727ed1421aacb90ce1d                                                                              |
| contract_id                                | CN3537837                                                                                                          |
| contract_unspsc_id                         | 55101500                                                                                                           |
| contract_description                       | Finalisation of Plant Biosecurity Surveillance Protocols for the citrus and mango industries in northern Australia |
| contract_value_amount                      | 50000.00                                                                                                           |
| contract_date_signed                       | 2018-09-04T05:49:18Z                                                                                               |
| contract_date_start                        | 2018-08-28T14:00:00Z                                                                                               |
| contract_date_end                          | 2019-06-06T14:00:00Z                                                                                               |
| tag                                        | contract                                                                                                           |
| contract_amendment_id                      | NA                                                                                                                 |
| contract_amendment_originalamount          | NA                                                                                                                 |
| contract_amendment_contractamendmentamount | NA                                                                                                                 |
| contract_amendment_amendedamount           | NA                                                                                                                 |
| contract_amendment_startdate               | NA                                                                                                                 |
| contract_amendment_date                    | NA                                                                                                                 |

`austender_unspsc` - containing information about the simplified United
Nations Standard Products and Services Code (UNSPSC) used by Austender
contract. A random example is shown below.

``` r
## example of data in austender_contracts

knitr::kable(
  sample_n(austendeR::austender_unspsc, size = 10)
)
```

| unspsc_id | unspsc_group                                                       | unspsc_desc                                      |
|:----------|:-------------------------------------------------------------------|:-------------------------------------------------|
| 43221500  | Information Technology Broadcasting and Telecommunications         | Call management systems or accessories           |
| 92120000  | National Defence and Public Order and Security and Safety Services | Security and personal safety                     |
| 42120000  | Laboratory and Measuring and Observing and Testing Equipment       | Veterinary equipment and supplies                |
| 80141500  | Management and Business Professionals and Administrative Services  | Market research                                  |
| 78100000  | Transportation and Storage and Mail Services                       | Mail and cargo transport                         |
| 83101900  | Public Utilities and Public Sector Related Services                | Energy conservation                              |
| 80101707  | Management and Business Professionals and Administrative Services  | Lobbying services                                |
| 44111515  | Office Equipment and Accessories and Supplies                      | File storage boxes or containers                 |
| 42140000  | Laboratory and Measuring and Observing and Testing Equipment       | Patient care and treatment products and supplies |
| 73150000  | Industrial Production and Manufacturing Services                   | Manufacturing support services                   |

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
