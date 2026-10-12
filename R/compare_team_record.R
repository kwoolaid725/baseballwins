#' Compare actual wins with run-based expectations
#'
#' Summarize how a team's actual record compares with its Pythagorean record.
#'
#' @param wins Numeric vector of nonnegative whole-number win totals.
#' @param losses Numeric vector of nonnegative whole-number loss totals.
#' @param runs_scored Numeric vector of nonnegative whole-number run totals.
#' @param runs_allowed Numeric vector of nonnegative whole-number run totals.
#' @param exponent One positive finite number, passed to
#'   [pythagorean_win_pct()]. Defaults to 1.83.
#'
#' @details All four count vectors must have the same length. Each team must
#'   have at least one decided game and at least one run scored or allowed.
#'   Games are defined as wins plus losses; ties are not included.
#'   A positive `wins_above_expected` means more wins than the run-based
#'   estimate. This difference is not a direct measure of luck or coaching.
#'
#' @return A data frame with one row per team and columns `wins`, `losses`,
#'   `games`, `actual_win_pct`, `expected_win_pct`, `expected_wins`, and
#'   `wins_above_expected`. Percentages use a 0-to-1 scale. Expected wins
#'   and differences are returned without rounding.
#'
#' @examples
#' compare_team_record(90, 72, 800, 650)
#' compare_team_record(c(90, 75), c(72, 87), c(800, 650), c(650, 750))
#' @export
compare_team_record <- function(wins, losses, runs_scored, runs_allowed,
                                exponent = 1.83) {
  check_counts(wins, "wins")
  check_counts(losses, "losses")
  expected <- pythagorean_win_pct(runs_scored, runs_allowed, exponent)
  if (length(wins) != length(losses) || length(wins) != length(expected)) {
    stop("All count vectors must have the same length.", call. = FALSE)
  }
  games <- wins + losses
  if (any(!is.finite(games)) || any(games == 0)) {
    stop("Each team must have a positive finite number of games.", call. = FALSE)
  }
  data.frame(
    wins = wins,
    losses = losses,
    games = games,
    actual_win_pct = wins / games,
    expected_win_pct = expected,
    expected_wins = games * expected,
    wins_above_expected = wins - games * expected
  )
}
