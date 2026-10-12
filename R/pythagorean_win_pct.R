#' Estimate Pythagorean winning percentage
#'
#' Estimate a baseball team's winning percentage from runs scored and allowed.
#'
#' @param runs_scored Numeric vector of nonnegative whole-number run totals.
#' @param runs_allowed Numeric vector of nonnegative whole-number run totals,
#'   with the same length as `runs_scored`.
#' @param exponent One positive finite number. Defaults to 1.83; use 2 for
#'   the original Pythagorean formula.
#'
#' @details The formula is `RS^exponent / (RS^exponent + RA^exponent)`.
#'   Each team must have at least one run scored or allowed. Missing values
#'   are rejected. The result describes run-based expectations, not a
#'   guaranteed future winning percentage.
#'
#' @return A numeric vector of expected winning percentages between 0 and 1,
#'   in the same order as the inputs.
#'
#' @references MLB. "Pythagorean Winning Percentage."
#'   <https://www.mlb.com/glossary/advanced-stats/pythagorean-winning-percentage>
#' @examples
#' pythagorean_win_pct(700, 700)
#' pythagorean_win_pct(c(800, 600), c(600, 800), exponent = 2)
#' @export
pythagorean_win_pct <- function(runs_scored, runs_allowed, exponent = 1.83) {
  check_counts(runs_scored, "runs_scored")
  check_counts(runs_allowed, "runs_allowed")
  if (length(runs_scored) != length(runs_allowed)) {
    stop("Run vectors must have the same length.", call. = FALSE)
  }
  if (!is.numeric(exponent) || length(exponent) != 1L ||
      !is.null(dim(exponent)) || !is.finite(exponent) || exponent <= 0) {
    stop("exponent must be one positive finite number.", call. = FALSE)
  }
  if (any(runs_scored == 0 & runs_allowed == 0)) {
    stop("Each team must have at least one run scored or allowed.", call. = FALSE)
  }
  # Rescaling avoids overflow when run totals are raised to a power.
  scale <- pmax(runs_scored, runs_allowed)
  scored <- (runs_scored / scale)^exponent
  allowed <- (runs_allowed / scale)^exponent
  scored / (scored + allowed)
}

check_counts <- function(x, name) {
  if (!is.numeric(x) || length(x) == 0L || !is.null(dim(x)) ||
      any(!is.finite(x)) || any(x < 0) || any(x != floor(x))) {
    stop(name, " must contain finite, nonnegative whole numbers.", call. = FALSE)
  }
}
