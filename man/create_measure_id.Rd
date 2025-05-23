% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_hces.R
\name{create_measure_id}
\alias{create_measure_id}
\title{Create a measure ID column based on selected columns}
\usage{
create_measure_id(data, country, survey, cols, include_ISOs = FALSE)
}
\arguments{
\item{data}{A data frame to modify.}

\item{country}{A character string specifying the country of the data.}

\item{survey}{A character string specifying the survey of the data.}

\item{cols}{A character vector specifying the names of the columns to include in the measure ID.}

\item{include_ISOs}{A logical value indicating whether to include the country and survey strings in the measure ID.}
}
\value{
A modified data frame with a measure ID column added.
}
\description{
This function creates a measure ID column in a data frame based on selected columns. 
The measure ID is a string that concatenates the values of the selected columns with hyphens.
The measure ID can optionally include the country and survey strings.
}
\examples{
data <- data.frame(unit_name = c("kg", "g", "lb", "oz"), unit_code = c("KGM", "GRM", "LBR", "ONZ"), 
region = c("A", "B", "C", "D"))
create_measure_id(data, "USA", "NHANES", c("unit_name", "unit_code", "region"), TRUE)
}
