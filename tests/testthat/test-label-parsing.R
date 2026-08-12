test_that("label levels support varying depth without removing internal punctuation", {
  data <- tibble::tibble(
    label = c(
      "Estimate!!Total:",
      "Estimate!!Total:!!Car, truck, or van:!!Drove alone"
    )
  )

  parsed <- ACSloadR:::parse_label_levels(data, remove_measure = TRUE)

  expect_equal(parsed$label_depth, c(1L, 3L))
  expect_equal(parsed$label_level_1, c("Total", "Total"))
  expect_equal(parsed$label_level_2, c(NA, "Car, truck, or van"))
  expect_equal(parsed$label_level_3, c(NA, "Drove alone"))
})

test_that("table IDs support detailed and subject naming", {
  expect_equal(
    ACSloadR:::table_from_variable(c("B01001A_001", "S2301_C01_001")),
    c("B01001A", "S2301")
  )
})
