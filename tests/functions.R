library(baseballwins)

near <- function(actual, expected) {
  stopifnot(isTRUE(all.equal(actual, expected, tolerance = 1e-12)))
}
fails <- function(expr, message) {
  error <- tryCatch({ force(expr); NULL }, error = identity)
  stopifnot(inherits(error, "error"),
            grepl(message, conditionMessage(error), fixed = TRUE))
}

# Known values, boundary cases, vector order, and numeric stability.
near(pythagorean_win_pct(700, 700), 0.5)
near(pythagorean_win_pct(300, 100, exponent = 2), 0.9)
near(pythagorean_win_pct(c(0, 100, 100), c(100, 0, 100)), c(0, 1, 0.5))
near(pythagorean_win_pct(1e200, 1e200, exponent = 2), 0.5)
near(pythagorean_win_pct(800, 650), pythagorean_win_pct(8000, 6500))

for (bad in list(-1, 1.5, NA_real_, Inf, "700", numeric(0), matrix(1))) {
  fails(pythagorean_win_pct(bad, 700), "runs_scored")
  fails(pythagorean_win_pct(700, bad), "runs_allowed")
}
for (bad in list(0, -1, NA_real_, Inf, "2", c(1, 2), numeric(0), matrix(2))) {
  fails(pythagorean_win_pct(700, 700, bad), "exponent")
}
fails(pythagorean_win_pct(0, 0), "at least one run")
fails(pythagorean_win_pct(c(700, 800), 650), "same length")

# Hand-calculated results with exponent 2: 800^2/(800^2+600^2) = .64.
x <- compare_team_record(c(90, 80), c(72, 82), c(800, 700),
                         c(600, 700), exponent = 2)
stopifnot(is.data.frame(x), nrow(x) == 2L)
near(x$games, c(162, 162))
near(x$actual_win_pct, c(90, 80) / 162)
near(x$expected_win_pct, c(0.64, 0.5))
near(x$expected_wins, c(103.68, 81))
near(x$wins_above_expected, c(-13.68, -1))
near(compare_team_record(1, 0, 1, 0)$wins_above_expected, 0)
fails(compare_team_record(0, 0, 1, 1), "positive finite")
fails(compare_team_record(1e308, 1e308, 1, 1), "positive finite")
fails(compare_team_record(90, 72, c(800, 700), c(600, 700)), "same length")
fails(compare_team_record(90, c(72, 82), 800, 600), "same length")
fails(compare_team_record(-1, 72, 800, 600), "wins")
fails(compare_team_record(90, NA_real_, 800, 600), "losses")
