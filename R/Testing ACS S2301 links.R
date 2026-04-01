
test_2301 <- tidycensus::get_acs(
  geography = "place",
  survey = "acs1",
  table = "S2301",
  year = 2024,
  state = "NV"
)


joined_2301 <- test_2301 |>
  dplyr::left_join(test_vars, by = c("variable" = "name"))
