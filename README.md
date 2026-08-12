# ACSloadR

ACSloadR helps labor market information analysts move from hierarchical ACS
tables to analysis-ready data with explicit measures, units, dimensions, and
margins of error.

## Topic helpers

```r
library(ACSloadR)

age <- get_acs_age(
  year = 2024,
  survey = "acs5",
  geography = "county",
  state = "MA"
)

age$total_population
age$race_ethnicity
```

`get_acs_age()` deliberately returns two data frames. The B01001 total-
population table has more detailed age bands than the B01001A-I race and
ethnicity companion tables, so ACSloadR does not imply that their rows are
directly interchangeable.

The mixed pilot also includes:

```r
employment <- get_acs_employment(2024, "acs5", "state", state = "MA")
occupation <- get_acs_occupation(2024, "acs5", "state", state = "MA")
earnings <- get_acs_earnings(2024, "acs5", "state", state = "MA")
commuting <- get_acs_commuting(2024, "acs5", "state", state = "MA")

employment$employment
occupation$occupation
earnings$earnings
commuting$commuting
```

Each component is long data. `measure` and `unit` identify what an observation
represents, while `value_source` distinguishes published ACS values from
derived shares. Derived rows retain `denominator_variable` and propagated
90-percent margins of error.

## Geography and geometry

Additional arguments are passed to `tidycensus::get_acs()`:

```r
county_age_sf <- get_acs_age(
  2024,
  "acs5",
  "county",
  state = "NV",
  geometry = TRUE
)
```

The requested geometry is retained in each bundle component.

## Variable explorer

`explore_census_data()` launches the optional Shiny variable explorer. Install
the suggested `DT` and `collapsibleTree` packages before launching it.
