% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_hces.R
\name{concatenate_columns}
\alias{concatenate_columns}
\title{Concatenate values in multiple columns into a single column}
\usage{
concatenate_columns(
  data,
  columns,
  exclude_value,
  new_column_name,
  keep_parenthesis = TRUE
)
}
\arguments{
\item{data}{A data frame containing the columns to concatenate}

\item{columns}{A character vector of column names to concatenate}

\item{exclude_value}{A character vector of strings to exclude from the concatenated values}

\item{new_column_name}{A character string of the name of the new column to create. This column can be one of 
the existing columns used to concatenate.}

\item{keep_parenthesis}{A boolean indicating whether to keep parenthesis in the concatenated string (default is TRUE)}
}
\value{
A modified data frame with a new column containing the concatenated values
}
\description{
This function concatenates the values in multiple columns of a data frame into a single column. It filters out blank,
 NA, and excluded values before concatenating the remaining values with a space in between. 
It also removes parenthesis and extra spaces from the concatenated string, unless specified otherwise.
}
\examples{
# Concatenate consumption unit columns in IHS5 data
hces_data <- data.frame(
food_item_code = c(101, 102, 103, 104),
cons_unit_name = c("OTHER (SPECIFY)", "BASIN", "PIECE", "OTHER (SPECIFY)"),
cons_unit_oth = c("HEAP", NA, "Soy", "TUBE"),
cons_unit_size_name = c("SMALL", "HEAPED", NA, "LARGE")
)

# Concatenate food item columns in HCES data
hces_data <- concatenate_columns(data = hces_data, columns = c("cons_unit_name", "cons_unit_oth",
"cons_unit_size_name"), exclude_value = c("SPECIFY", "OTHER"), new_column_name="survey_food_item", 
keep_parenthesis = FALSE)

}
