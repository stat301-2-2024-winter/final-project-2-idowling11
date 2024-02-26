## Datasets in /data folder

- `nba_season_stats.csv`: raw, uncleaned dataset with missing values. Displays/stores NBA players' stats and salaries from  1950 to 2017, with missing values. 24,625 observations, and 54 variables (2 of which are blank). 42 numerics, and 10 character variables.

- `nba_season_statistics.csv`: very preliminary cleaning, with variable names cleaned. Same number of observations.

- `nba_season_statistics_cleaned.csv`: thorough cleaning. Missing salaries (overwhelming majority of which are unrecorded salary observations from before 1990) removed. Percentages for 0 made shots in 0 attempts imputed as 0%. Includes log-transformed salary variable. 10,977 observations with 53 variables. 2 blank variables from first dataset removed, while log-transformed salary variable added.
