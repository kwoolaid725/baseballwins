# baseballwins

A small R package for comparing baseball team records with run-based expectations.

- `pythagorean_win_pct()` estimates winning percentage from runs scored and allowed.
- `compare_team_record()` returns actual wins, expected wins, and the difference.

Both functions accept one team or several teams. No runtime packages are required.

## Try it

From this repository's folder:

```r
devtools::load_all()

# Illustrative team totals
pythagorean_win_pct(800, 650)
compare_team_record(90, 72, 800, 650)
```

## Generate documentation and check

```r
devtools::document()
devtools::check()
```

The `R/` files contain roxygen comments. `man/` and `NAMESPACE` are generated
from those comments. Tests in `tests/functions.R` cover known results,
multiple teams, zero totals, invalid inputs, and mismatched vector lengths.

Method: [MLB's Pythagorean winning percentage glossary](https://www.mlb.com/glossary/advanced-stats/pythagorean-winning-percentage).

ChatGPT assisted with development and testing.
