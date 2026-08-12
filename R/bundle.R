#' An ACS LMI data bundle
#'
#' Topic helpers return a named bundle of analysis-ready tibbles. Components
#' remain separate when their ACS source tables have different structures.
#'
#' @param components A named list of data frames.
#' @param topic Topic name used when printing the bundle.
#' @param year ACS vintage.
#' @param survey ACS survey dataset.
#'
#' @return An object of class `acs_lmi_bundle`.
#' @keywords internal
new_acs_lmi_bundle <- function(components, topic, year, survey) {
  if (is.null(names(components)) || any(names(components) == "")) {
    stop("Bundle components must be named.", call. = FALSE)
  }
  structure(
    components,
    class = c("acs_lmi_bundle", "list"),
    topic = topic,
    year = year,
    survey = survey
  )
}

#' @export
print.acs_lmi_bundle <- function(x, ...) {
  cat("<acs_lmi_bundle>", attr(x, "topic"), "\n")
  cat("Year:", attr(x, "year"), " Survey:", attr(x, "survey"), "\n")
  cat("Components:\n")

  for (component in names(x)) {
    value <- x[[component]]
    tables <- if ("table" %in% names(value)) {
      paste(unique(stats::na.omit(value$table)), collapse = ", ")
    } else {
      "unknown"
    }
    universes <- if ("universe" %in% names(value)) {
      paste(unique(stats::na.omit(value$universe)), collapse = "; ")
    } else {
      "unknown"
    }
    cat("  $", component, ": ", nrow(value), " rows | ", tables,
        " | ", universes, "\n", sep = "")
  }

  invisible(x)
}

#' @export
as.data.frame.acs_lmi_bundle <- function(x, ...) {
  stop(
    "An `acs_lmi_bundle` contains separate ACS structures. Extract a named component with `$` before converting it.",
    call. = FALSE
  )
}
