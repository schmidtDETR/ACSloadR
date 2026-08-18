acs_label_tokens <- function(labels, remove_measure = TRUE) {
  purrr::map(labels, function(label) {
    if (is.na(label)) {
      return(character())
    }

    tokens <- stringr::str_split(label, "!!", simplify = FALSE)[[1]]
    tokens <- stringr::str_trim(tokens)
    tokens <- stringr::str_remove(tokens, ":$")
    tokens <- tokens[tokens != ""]

    if (remove_measure && length(tokens) > 0L &&
        tokens[[1]] %in% c("Estimate", "Margin of Error")) {
      tokens <- tokens[-1]
    }

    tokens
  })
}

token_at <- function(tokens, position) {
  purrr::map_chr(tokens, function(x) {
    if (length(x) >= position) x[[position]] else NA_character_
  })
}

deepest_token <- function(tokens, start = 1L) {
  purrr::map_chr(tokens, function(x) {
    if (length(x) < start) return(NA_character_)
    x[[length(x)]]
  })
}

parse_label_levels <- function(data, label_col = "label", remove_measure = FALSE) {
  if (!label_col %in% names(data)) {
    stop("`label_col` must identify a column in `data`.", call. = FALSE)
  }

  tokens <- acs_label_tokens(data[[label_col]], remove_measure = remove_measure)
  depths <- lengths(tokens)
  max_depth <- if (length(depths)) max(depths, na.rm = TRUE) else 0L

  out <- data
  out$label_depth <- depths
  if (is.finite(max_depth) && max_depth > 0L) {
    for (i in seq_len(max_depth)) {
      out[[paste0("label_level_", i)]] <- token_at(tokens, i)
    }
  }
  out
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

