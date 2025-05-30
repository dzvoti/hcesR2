
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hcesNutR <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/micronutrient/hcesNutR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/micronutrient/hcesNutR/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
![GitHub R package
version](https://img.shields.io/github/r-package/v/micronutrient/hcesNutR)
<!-- badges: end -->

The goal of hcesR is to create a package that will help with the
analysis of the Household Consumption Expenditure Survey (HCES) data. A
good source of HCES data is [the world bank microdata
repository](https://microdata.worldbank.org/). The package will contain
functions that will help with the analysis of HCES data. The package
also contains a
[sample_hces.dta](micronutrient.github.io/hcesNutR/data/sample_hces.dta) used
to demonstrate the use of the functions in the package, you can download
this data after installing the package by running
`hcesNutR::sample_hces()` in your R console. The package is still under
development and will be updated regularly.

# `hcesNutR` Package

The goal of the hcesNutR project is to create a repository of functions
and data that will help with the analysis of the Household Consumption
Expenditure Survey (HCES) data. A good source of HCES data is [the world
bank microdata repository](https://microdata.worldbank.org/).

The package contain functions that will help with the analysis of HCES
data. The package also contains the sample data used in this book
i.e. [r4hces-data/mwi-ihs5-sample-data](micronutrient.github.io/hcesNutR/data/r4hces-data.zip)
We will use this sample data to demonstrate the use of the functions in
the package. The package is still under development and will be updated
regularly.

## Reporting bugs

Please report any bugs or issues
[here](www.github.com/micronutrient/hcesNutR/issues).

## Installation

You can install the development version of hcesNutR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("micronutrient/hcesNutR")
```

As we discussed in previous chapters you need to load the package in
your R session before you can use it. You can load the package by
running the following code in your R console.

``` r
library(hcesNutR)
```

## Functions in the package

You can view the functions in the package by running the following code
in your R console.

``` r
ls("package:hcesNutR")
```

<div class="callout-tip">

You can read the functions and their description on the project website
at:
[micronutrient.github.io/hcesNutR/reference/index.html](micronutrient.github.io/hcesNutR/reference/index.html)

</div>

## Sample data

The data used in this example is randomly generated to mimic the
structure of the [Fifth Integrated Household Survey
2019-2020](https://microdata.worldbank.org/index.php/catalog/3818/related-materials)
an HCES of Malawi. The variables and structure of this data is found
[here](https://microdata.worldbank.org/index.php/catalog/3818/related-materials)

<div class="callout-tip">

All functions in this package take a dataframe/tibble as input data.
This is by design to allow flexibility on input data. The example used
here is for use on stata files with `.dta` but the functions should work
with `.csv` files as well.

</div>

### Import and explore the sample data

Import the sample data from the `r4hces-data/mwi-ihs5-sample-data`
folder. Use the `read_dta` function from the `haven` package to import
it.

``` r
# Import the data using the haven package from the tidyverse
sample_hces <-
  haven::read_dta(here::here("data", 
                             "mwi-ihs5-sample-data",
                             "HH_MOD_G1_vMAPS.dta"))
```

### Trim the data

In this example we will use `hcesNutR` functions to demonstrate
processing of `total` consumption data. The `total` consumption data is
the data that contains the total consumption of each food item by each
household.

The other consumption columns contain values for consumption from
sources i.e. gifted, purchased, ownProduced. The workflow for processing
the “other” consumption data is the same as demonstrated below.

``` r
# Trim the data to total consumption
sample_hces <- sample_hces |>
  dplyr::select(case_id:HHID,
                hh_g01:hh_g03c_1)
```

## `hcesnutR` Workflow

### Column Naming Conventions and Renaming

The `sample_hces` data is in stata format which contains data with short
column name codes that have associated “question” labels that explain
the contents of the data. To make the column names more interpretable,
the package provides the `rename_hces` function, which can be used to
rename the column codes to standard hces names used downstream.

The `rename_hces` function uses column names from the
`standard_name_mappings_pairs` dataset within the package.
Alternatively, a user can create their own name pairs or manually rename
their columns to the `standard` names.

It is important to note that all downstream functions in the `hcesNutR`
package work with standard names and will not work with the short column
names. Therefore, it is recommended to use the `rename_hces()` function
to ensure that the column names are consistent with the package’s naming
conventions.

For more information on how to use the `rename_hces` function, please
refer to the function’s documentation:
[`rename_hces`](https://micronutrient.github.io/hcesNutR/reference/rename_hces.html).

``` r
# Rename the variables
sample_hces <- hcesNutR::rename_hces(sample_hces,
                                     country_name = "MWI",
                                     survey_name = "IHS5")
```

### Remove unconsumed food items

HCES surveys administer a standard questionaire to each household where
they are asked to conform whether they consumed the food items on their
standard list. If a household did not consume a food item, the value of
the ‘consYN’ is set to a constant. The `remove_unconsumed` function
removes all food items that were not consumed by the household. The
function takes in a data frame and the name of the column that contains
the consumption information. The function also takes in the value that
indicates that the food item was consumed.

``` r
# Remove unconsumed food items
sample_hces <- hcesNutR::remove_unconsumed(sample_hces,
                                           consCol = "consYN", 
                                           consVal = 1)
```

### Create two columns from each dbl+lbl column

The `create_dta_labels` function creates two columns from each dbl+lbl
(double plus label) column. The first column contains the numeric values
and the second column contains the labels. The function takes in a data
frame and finds all columns that contains the double plus label column.
The function returns a data frame with the new columns.

``` r
# Split dbl+lbl columns
sample_hces <- hcesNutR::create_dta_labels(sample_hces)
```

### Concatenate columns

Some HCES data surveys split consumed food items or their consumption
units into multiple columns. The `concatenate_columns` function cleans
the data by combining the split columns into one column. The function
can exclude values from contatenation by specifying the whole or part of
values to be excluded.

#### Concatenate food item names

``` r
# Merge food item names
sample_hces <-
  hcesNutR::concatenate_columns(sample_hces,
                                c("item_code_name", 
                                  "item_oth"),
                                "SPECIFY",
                                "item_code_name")
```

#### Concatenate food item units

``` r
# Merge consumption unit names. For units it is essential to remove parentesis as they are the major cause of duplicate units
sample_hces <-
  hcesNutR::concatenate_columns(
    sample_hces,
    c(
      "cons_unit_name",
      "cons_unit_oth",
      "cons_unit_size_name",
      "hh_g03c_1_name"
    ),
    "SPECIFY",
    "cons_unit_name",
    TRUE
  )
```

<div class="callout-tip">

Use the `select` and `rename` functions from the dplyr package to subset
the columns containing food item name , food item code, food unit name
and food unit code. This is to ensure that the names are meaningful and
consistent with the package’s naming conventions.

</div>

``` r
sample_hces <- sample_hces |>
  dplyr::select(
    case_id,
    hhid,
    item_code_name,
    item_code_code,
    cons_unit_name,
    cons_unitA,
    cons_quant
  ) |>
  dplyr::rename(food_name = item_code_name,
                food_code = item_code_code,
                cons_unit_code = cons_unitA)
```

### Match survey food items to standard food items

The `match_food_names` function is useful for standardising survey food
names. This is feasible due to an internal dataset of standard food item
names matched with their corresponding survey food names for supported
surveys. Alternatively users can use their own food matching names by
passing a csv to the function. See hcesNutR::food_list for csv
structure.

``` r
sample_hces <-
  match_food_names_v2(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    food_name_col = "food_name",
    food_code_col = "food_code",
    overwrite = FALSE
  )
```

### Match survey consumption units to standard consumption units

The `match_food_units_v2` function is useful for standardising survey
consumption units. This is feasible due to an internal dataset of
standard consumption units matched with their corresponding survey
consumption units for supported surveys. Alternatively users can
download our template from `hcesNutR::unit_names_n_codes_df` and modify
it to use their own consumption unit matching names.

``` r
sample_hces <-
  match_food_units_v2(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    unit_name_col = "cons_unit_name",
    unit_code_col = "cons_unit_code",
    matches_csv = NULL,
    overwrite = FALSE
  )
```

### Add regions and districts to the data

Identify the HCES module that contains `household identifiers`. In some
cases this will already be present in the HCES data and should be
skipped. From the `household identifiers` select the ones that are
required and add to the data. In this example we will add the region and
district identifiers to the data from the `hh_mod_a_filt.dta` file.

``` r
# Import household identifiers from the hh_mod_a_filt.dta file
household_identifiers <-
  haven::read_dta(here::here("data",
                             "mwi-ihs5-sample-data",
                             "hh_mod_a_filt_vMAPS.dta")) |>
  # subset the identifiers and keep only the ones needed.
  dplyr::select(case_id,
                HHID,
                region) |>
  dplyr::rename(hhid = HHID)

# Add the identifiers to the data
sample_hces <-
  dplyr::left_join(sample_hces,
                   household_identifiers,
                   by = c("hhid", "case_id"))
```

### Create a `measure_id` column

The `create_measure_id` function creates a measure id column that is
used to identify the consumption measure of each food item. The function
takes in a data frame and the name of the column that contains the
consumption information. The function also takes in the value that
indicates that the food item was consumed.

The `measure_id` is a unique identifier that allows us to join the
consumption data with the food conversion factors data.

``` r
# Create measure id column
sample_hces <-
  create_measure_id(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    cols = c("region",
             "matched_cons_unit_code",
             "matched_food_code"),
    include_ISOs = FALSE
  )
```

### Import food conversion factors.

The available data comes with a \`food_conversion fcators file which has
conversion fcators that link the food names and units to their
corresponding

``` r
# Import food conversion factors file
IHS5_conv_fct <-
  readr::read_csv(
    here::here(
      "data",
      "mwi-ihs5-sample-data",
      "IHS5_UNIT_CONVERSION_FACTORS_vMAPS.csv"
    )
  )
```

We need to check if the conversion factors file contain all the expected
conversion factors for the hces data being processed. The
`check_conv_fct` function checks if the conversion factors file contains
all the expected conversion factors for the hces data being processed. T

<div class="callout-warning">

Remember this data was randomly generated so it is expected that the
weights will not be realistic. Also not all food items have conversion
factors so the weight of those food items will be `NA`.

</div>

``` r
# Check conversion factors 
check_conv_fct(hces_df = sample_hces, 
               conv_fct_df = IHS5_conv_fct)
```

### Calculate weight of food items in kilograms.

The `apply_wght_conv_fct` function will take the `hces_df` and
`conv_fct_df` and calculate the weight of each food item in kilograms.

<div class="callout-warning">

Remember this data was randomly generated so it is expected that the
weights will not be realistic. Also not all food items have conversion
factors so the weight of those food items will be `NA`.

</div>

``` r
sample_hces <-
  apply_wght_conv_fct(
    hces_df = sample_hces,
    conv_fct_df = IHS5_conv_fct,
    factor_col = "factor",
    measure_id_col = "measure_id",
    wt_kg_col = "wt_kg",
    cons_qnty_col = "cons_quant",
    allowDuplicates = TRUE
  )
```

### Calculate AFE/AME and add to the data

<div class="callout-tip">

## Assumptions

The ame/afe factors are calculated using the following assumptions: -
Merge HH demographic data with AME/AFE factors - Men’s weight: 65kg
(assumption) - Women’s weight: 55kg (from DHS) - PAL: 1.6X the BMR

</div>

#### Import data required

In order to calculate the AFE and AME metrics we require the following
data: - Household roster with the sex and age of each individual
`HH_MOD_B_vMAPS.dta` - Household health `HH_MOD_D_vMAPS.dta` - AFE and
AME factors `IHS5_AME_FACTORS_vMAPS.csv` and `IHS5_AME_SPEC_vMAPS.csv`

``` r
# Import data of the roster and health modules of the IHS5 survey
ihs5_roster <-
  haven::read_dta(here::here("data",
                             "mwi-ihs5-sample-data",
                             "HH_MOD_B_vMAPS.dta"))
ihs5_health <-
  haven::read_dta(here::here("data",
                             "mwi-ihs5-sample-data",
                             "HH_MOD_D_vMAPS.dta"))

# Import data of the AME/AFE factors and specifications
ame_factors <-
  read.csv(here::here("data",
                      "mwi-ihs5-sample-data",
                      "IHS5_AME_FACTORS_vMAPS.csv")) |>
  janitor::clean_names()

ame_spec_factors <-
  read.csv(here::here("data",
                      "mwi-ihs5-sample-data",
                      "IHS5_AME_SPEC_vMAPS.csv")) |>
  janitor::clean_names() |>
  # Rename the population column to cat and select the relevant columns
  dplyr::rename(cat = population) |>
  dplyr::select(cat, ame_spec, afe_spec)
```

#### Extra energy requirements for pregnancy

``` r
# Extra energy requirements for pregnancy and Illness
pregnantPersons <- ihs5_health |>
  dplyr::filter(hh_d05a == 28 |
                  hh_d05b == 28) |> 
  # NOTE: 28 is the code for pregnancy in this survey
  dplyr::mutate(ame_preg = 0.11, afe_preg = 0.14) |> 
  dplyr::select(HHID, ame_preg, afe_preg)
```

#### Process HH roster data

``` r
# Process the roster data and rename variables to be more intuitive
aMFe_summaries <- ihs5_roster |>
  # Rename the variables to be more intuitive
  dplyr::rename(sex = hh_b03, age_y = hh_b05a, age_m = hh_b05b) |>
  dplyr::mutate(age_m_total = (age_y * 12 + age_m)) |> 
  # Add the AME/AFE factors to the roster data
  dplyr::left_join(ame_factors, by = c("age_y" = "age")) |> 
  dplyr::mutate(
    ame_base = dplyr::case_when(sex == 1 ~ ame_m, sex == 2 ~ ame_f),
    afe_base = dplyr::case_when(sex == 1 ~ afe_m, sex == 2 ~ afe_f),
    age_u1_cat = dplyr::case_when(
      # NOTE: Round here will ensure that decimals are not omited in the calculation.
      round(age_m_total) %in% 0:5 ~ "0-5 months",
      round(age_m_total) %in% 6:8 ~ "6-8 months",
      round(age_m_total) %in% 9:11 ~ "9-11 months"
    )
  ) |>
  # Add the AME/AFE factors for the specific age categories
  dplyr::left_join(ame_spec_factors, by = c("age_u1_cat" = "cat")) |>
  # Dietary requirements for children under 1 year old
  dplyr::mutate(
    ame_lac = dplyr::case_when(age_y < 2 ~ 0.19),
    afe_lac = dplyr::case_when(age_y < 2 ~ 0.24)
  ) |>
  dplyr::rowwise() |>
  # TODO: Will it not be better to have the pregnancy values added at the same time here?
  dplyr::mutate(ame = sum(c(ame_base, ame_spec, ame_lac), na.rm = TRUE),
                afe = sum(c(afe_base, afe_spec, afe_lac), na.rm = TRUE)) |>
  # Calculate number of individuals in the households
  dplyr::group_by(HHID) |>
  dplyr::summarize(
    hh_persons = dplyr::n(),
    hh_ame = sum(ame),
    hh_afe = sum(afe)
  ) |>
  # Merge with the pregnancy and illness data
  dplyr::left_join(pregnantPersons, by = "HHID") |>
  dplyr::rowwise() |>
  dplyr::mutate(hh_ame = sum(c(hh_ame, ame_preg), na.rm = T),
                hh_afe = sum(c(hh_afe, afe_preg), na.rm = T)) |>
  dplyr::ungroup() |>
  # Fix single household factors
  dplyr::mutate(
    hh_ame = dplyr::if_else(hh_persons == 1, 1, hh_ame),
    hh_afe = dplyr::if_else(hh_persons == 1, 1, hh_afe)
  ) |>
  dplyr::select(HHID, hh_persons, hh_ame, hh_afe) |>
  dplyr::rename(hhid = HHID)
```

#### Enrich Consumption Data with AFE/AME

We will use the `left_join` function from `dplyr` to join the
consumption data with the `aMFe_summaries` data.

The `left_join` function will join the `aMFe_summaries` data to the
`sample_hces` data by matching the `hhid` column in both data sets.

The `left_join` function will add the `hh_persons`, `hh_ame` and
`hh_afe` columns to the `sample_hces` data.

The `hh_persons` column contains the number of people in each household.
The `hh_ame` and `hh_afe` columns contain the AME and AFE factors for
each household.

``` r
sample_hces <- sample_hces |> 
  dplyr::left_join(aMFe_summaries)
```

Now we have a “clean” data set that we can use for analysis.

## Summary

This chapter demonstrated the use of the `hcesNutR` package to process
HCES data. The package contains functions that will help with the
analysis of HCES data.

The package also contains the sample data used in this book
i.e. [r4hces-data/mwi-ihs5-sample-data](micronutrient.github.io/hcesNutR/data/r4hces-data.zip)
We used this sample data to demonstrate the use of the functions in the
package.

The package is still under development and will be updated
regularly.Please report any bugs or issues
[here](www.github.com/micronutrient/hcesNutR/issues).

## Future work

-   Add more functions to the package
-   Support more surveys (NGA Living Standards Survey 2018-2019)
-   Add more internal data to the package
-   Add more documentation to the package
