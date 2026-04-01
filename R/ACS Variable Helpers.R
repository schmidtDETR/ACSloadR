#' Get and Clean ACS Table S2301 Variable Labels
#'
#' This function retrieves variable metadata for ACS Subject Table S2301,
#' cleans the hierarchical Census labels, ensures "Population" labels
#' are correctly assigned, and creates hierarchical mapping for both
#' Master (population root) and Parent (immediate ancestor) variables.
#'
#' @param acs_year Numeric or integer. The reference year for the ACS data (e.g., 2023).
#' @param acs_scope Numeric or character. The ACS survey type: 1 for 1-year or 5 for 5-year.
#' @param verbose Logical. If TRUE, prints status messages indicating the year and scope being processed. Defaults to FALSE.
#'
#' @return A tibble with structured demographic labels. Master_Variable and
#' Parent_Variable columns are located at the end of the table.
#'
#' @importFrom tidycensus load_variables
#' @importFrom dplyr filter mutate if_else select group_by ungroup case_when relocate
#' @importFrom stringr str_detect str_to_title str_replace_all str_extract
#' @importFrom tidyr separate
#' @export
#'
#' @examples
#' \dontrun{
#'   vars_2023 <- get_2301_variables(2023, 1, verbose = TRUE)
#' }
get_2301_variables <- function(acs_year, acs_scope, verbose = FALSE) {

  # 1. Determine the correct dataset path
  scope_val <- if (stringr::str_detect(as.character(acs_scope), "1")) "acs1" else "acs5"
  dataset_path <- paste0(scope_val, "/subject")

  # 2. Verbose Status Message
  if (verbose) {
    message(paste0("--- Fetching S2301 variables for ", acs_year, " (", scope_val, ") ---"))
  }

  # 3. Fetch the raw variable list
  var_raw <- tidycensus::load_variables(acs_year, dataset_path)

  # 4. Clean and structure the variable labels
  var_processed <- var_raw |>
    dplyr::filter(stringr::str_detect(name, "S2301_")) |>

    # Break down the 'label' column
    tidyr::separate(
      col = label,
      into = c(NA, "Data", "Demographic_Population", "Demographic_Type",
               "Demographic_Group", "Demographic_Subgroup_1", "Demographic_Subgroup_2"),
      sep = "!!",
      fill = "right"
    ) |>

    # Swap logic for "Population" string
    dplyr::mutate(
      needs_swap = stringr::str_detect(Demographic_Type, "Population") &
        !stringr::str_detect(Demographic_Population, "Population"),
      temp_pop = Demographic_Population,
      Demographic_Population = dplyr::if_else(needs_swap %in% TRUE, Demographic_Type, Demographic_Population),
      Demographic_Type = dplyr::if_else(needs_swap %in% TRUE, temp_pop, Demographic_Type)
    ) |>
    dplyr::select(-needs_swap, -temp_pop) |>

    # 5. Hierarchical Mapping (Master and Parent)
    dplyr::mutate(Measure_Code = stringr::str_extract(name, "C\\d{2}")) |>

    # Step A: Identify Master (Top of the population block)
    dplyr::group_by(Measure_Code, Demographic_Population) |>
    dplyr::mutate(Master_Variable = name[is.na(Demographic_Group)][1]) |>

    # Step B: Identify potential parent for Subgroup 2 (Parent is the Subgroup 1 row)
    dplyr::group_by(Measure_Code, Demographic_Population, Demographic_Type, Demographic_Group, Demographic_Subgroup_1) |>
    dplyr::mutate(p_sub1 = name[is.na(Demographic_Subgroup_2)][1]) |>

    # Step C: Identify potential parent for Subgroup 1 (Parent is the Group row)
    dplyr::group_by(Measure_Code, Demographic_Population, Demographic_Type, Demographic_Group) |>
    dplyr::mutate(p_group = name[is.na(Demographic_Subgroup_1)][1]) |>
    dplyr::ungroup() |>

    # Step D: Assign the correct Parent based on depth
    dplyr::mutate(
      Parent_Variable = dplyr::case_when(
        !is.na(Demographic_Subgroup_2) ~ p_sub1,
        !is.na(Demographic_Subgroup_1) ~ p_group,
        !is.na(Demographic_Group)      ~ Master_Variable,
        TRUE                           ~ NA_character_
      )
    ) |>
    # Step E: Assign variable name to Measure Code
    dplyr::mutate(Measure = dplyr::case_when(
      Measure_Code == "C01" ~ "Population",
      Measure_Code == "C02" ~ "Labor Force Participation Rate",
      Measure_Code == "C03" ~ "Employment Population Ratio",
      Measure_Code == "C04" ~ "Unemployment Rate",
      .default = "Missing"
      )
    ) |>
    # Clean up calculation helpers
    dplyr::select(-Measure_Code, -p_sub1, -p_group) |>

    # 6. Formatting Labels
    dplyr::mutate(Group = paste0(
      Demographic_Population,
      ifelse(!is.na(Demographic_Type), paste0(" ", Demographic_Type), ""),
      ifelse(!is.na(Demographic_Group), paste0(": ", Demographic_Group), ""),
      ifelse(!is.na(Demographic_Subgroup_1), paste0(", ", Demographic_Subgroup_1), ""),
      ifelse(!is.na(Demographic_Subgroup_2), paste0(", ", Demographic_Subgroup_2), "")
    )) |>
    dplyr::mutate(Group = stringr::str_to_title(Group)) |>
    dplyr::mutate(Group = stringr::str_replace_all(Group, c(" And " = " and ", " Or " = " or ", " To " = " to "))) |>

    dplyr::mutate(Group_Alone = paste0(
      ifelse(!is.na(Demographic_Group), paste0(Demographic_Group), ""),
      ifelse(!is.na(Demographic_Subgroup_1), paste0(",\n ", Demographic_Subgroup_1), ""),
      ifelse(!is.na(Demographic_Subgroup_2), paste0(",\n ", Demographic_Subgroup_2), "")
    )) |>
    dplyr::mutate(Group_Alone = stringr::str_to_title(Group_Alone)) |>
    dplyr::mutate(Group_Alone = stringr::str_replace_all(Group_Alone, c(" And " = " and ", " Or " = " or ", " To " = " to "))) |>

    # 7. Final Organization: Move hierarchy columns to the end
    dplyr::relocate(Master_Variable, Parent_Variable, Measure, .after = dplyr::last_col())

  return(var_processed)
}
