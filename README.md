# ACSloadR

ACSloadR helps labor market information analysts move from hierarchical ACS
tables to analysis-ready data with explicit measures, units, dimensions, and
margins of error.

## Interactive Topic Wizard & Code Generator

ACSloadR includes an interactive console wizard to browse available topics, review table coverage, and generate customized R scripts:

```r
library(ACSloadR)

# Launch the interactive console wizard
acs_wizard()

# Or generate code directly for a topic
create_acs_script(topic = "employment_detail", geography = "county", state = "MA")
```

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

### Comprehensive Employment & Labor Market Helpers

ACSloadR covers all major ACS employment and labor market topics:

```r
# Subject-table employment & occupation summaries
employment <- get_acs_employment(2024, "acs5", "state", state = "MA")
occupation <- get_acs_occupation(2024, "acs5", "state", state = "MA")

# Detailed B/C-series employment status & cross-tabulations
emp_detail <- get_acs_employment_detail(2024, "acs5", "state", state = "MA")
emp_detail$status              # B23025: Total, Civilian Employed/Unemployed, Armed Forces, Not in Labor Force
emp_detail$age_sex             # B23001: Sex by Age by Employment Status
emp_detail$race_ethnicity      # B23002A-I / C23002A-I: Sex by Age by Race by Employment Status
emp_detail$education           # B23006: Educational Attainment by Employment Status (25-64)
emp_detail$poverty_disability  # B23024: Poverty by Disability by Employment Status (20-64)

# Work intensity, hours, and full-time status
work <- get_acs_work_experience(2024, "acs5", "state", state = "MA")
work$hours_weeks               # B23022, B23026: Usual Hours Worked per Week by Weeks Worked
work$full_time_by_age          # B23027: Full-time, Year-round Work Status by Age
work$hours_summary             # B23018, B23020, B23013: Aggregate/Mean Hours & Median Age

# Family and child employment
family <- get_acs_family_employment(2024, "acs5", "state", state = "MA")
family$children_parent_status  # B23008: Children by Living Arrangements and Parental Employment
family$females_with_children   # B23003: Females 20-64 by Age of Children and Employment Status
family$family_type_status      # B23007: Presence of Children by Family Type and Employment Status
family$family_workers          # B23009, B23010: Family Workers and Work Experience

# Industry (B24030-B24070 / C24030-C24070)
industry <- get_acs_industry(2024, "acs5", "state", state = "MA")
industry$industry              # Sex by Industry for Civilian Employed Pop 16+
industry$industry_full_time    # Sex by Industry for Full-Time, Year-Round
industry$earnings              # Industry Median Earnings (Total and by Sex)
industry$earnings_full_time    # Full-Time Industry Median Earnings
industry$industry_by_occupation# Industry by Occupation Matrix
industry$industry_by_class     # Industry by Class of Worker

# Class of Worker (B24080-B24092 / C24080-C24092)
cow <- get_acs_class_of_worker(2024, "acs5", "state", state = "MA")
cow$class_of_worker            # Sex by Class of Worker (Private, Non-profit, Gov, Self-employed)
cow$class_of_worker_full_time  # Full-time Class of Worker
cow$earnings                   # Class of Worker Median Earnings
cow$earnings_full_time         # Full-time Class of Worker Median Earnings
cow$class_by_occupation        # Occupation by Class of Worker

# Detailed base occupation counts & earnings
occ_detail <- get_acs_occupation_detailed(2024, "acs5", "state", state = "MA")
occ_detail$occupation          # B24010 / C24010: Total Population Detailed Occupation
occ_detail$occupation_full_time# B24020 / C24020: Full-Time Detailed Occupation
occ_detail$earnings            # B24011, B24012: Detailed Occupation Median Earnings

# National 500+ Category Detailed Tables (US-level only)
national <- get_acs_national_detailed(2024, "acs5", "us")
national$detailed_occupation   # B24114-B24126
national$detailed_industry     # B24134-B24136

# Earnings by education & Commuting
earnings <- get_acs_earnings(2024, "acs5", "state", state = "MA")
commuting <- get_acs_commuting(2024, "acs5", "state", state = "MA")

# Household, Family, & Individual Income & Inequality
hh_inc <- get_acs_household_income(2024, "acs5", "state", state = "MA") # B19001, B19013, B19019, B19037, B19049 & Race
fam_inc <- get_acs_family_income(2024, "acs5", "state", state = "MA")    # B19101, B19113, B19119, B19121, B19125, B19126, B19131, B19201, B19202 & Race
inc_types <- get_acs_income_types(2024, "acs5", "state", state = "MA")  # B19051-B19070 (Earnings, Wages, SSI, Retirement, SNAP, etc.)
ineq <- get_acs_income_inequality(2024, "acs5", "state", state = "MA")   # Gini Index (B19083), Quintiles (B19080-82), Per Capita (B19301)
ind_inc <- get_acs_individual_income(2024, "acs5", "state", state = "MA")# Individual Income & Earnings by Sex and Work Exp (B20001-B20018, B19325-26)

# Education, School Enrollment, & Field of Degree
enroll <- get_acs_school_enrollment(2024, "acs5", "state", state = "MA") # B14001-B14007 (Level, Public/Private, Age, Poverty, Youth status)
attain <- get_acs_educational_attainment(2024, "acs5", "state", state = "MA") # B15001-B15003 (Age, Sex, 24 detailed categories & Race)
field <- get_acs_field_of_degree(2024, "acs5", "state", state = "MA")    # B15010-B15014 (Undergraduate Majors & Earnings by Sex/Age)

# Commute, Travel Time, Departure/Arrival Times, Place of Work, & Mode Cross-tabulations
commuting <- get_acs_commuting(2024, "acs5", "state", state = "MA")      # B08301 (Means of Transportation)
travel_time <- get_acs_commuting_travel_time(2024, "acs5", "state", state = "MA") # B08302-3, B08602-3, B08011-13, B08131-36, B08532-36
place_of_work <- get_acs_place_of_work(2024, "acs5", "state", state = "MA") # B08007-09, B08016-18, B08604
comm_char <- get_acs_commuting_characteristics(2024, "acs5", "state", state = "MA") # Mode crossed by Age, Earnings, Poverty, Occ, Ind, Class, Vehicles & Race

# Geographical Mobility & Migration (Current Residence & Residence 1 Year Ago)
mig_curr <- get_acs_migration_current(2024, "acs5", "state", state = "MA") # B07001-B07013, B07004A-I, B07101, B07201-B07204
mig_prior <- get_acs_migration_prior(2024, "acs5", "state", state = "MA")  # B07401-B07413, B07404A-I
```

Each component is long data. `measure` and `unit` identify what an observation
represents, while `value_source` distinguishes published ACS values from
derived shares. Derived rows retain `denominator_variable` and propagated
90-percent margins of error.

Occupation and industry companion tables automatically manage survey differences
(e.g., using detailed `B` tables for ACS 1-year and collapsed `C` tables for ACS 5-year).
Where tables publish estimates by male and female but omit total sex, ACSloadR
adds `sex = "Total"` rows by summing the estimates, marking them `value_source = "derived"`,
identifying both inputs in `source_variables`, and applying the Census MOE formula
for sums.

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
