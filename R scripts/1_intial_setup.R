 # Script 1: Initial Setup and cleaning

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(janitor)
library(skimr)
library(ggplot2)
library(dplyr)

# handle common conflicts
tidymodels_prefer()

# setting seed
set.seed(8)

# data read-in
nba_season_stats <- read_csv(here("data/nba_season_stats.csv"))

nba_season_statistics <- nba_season_stats |>
  clean_names()

# removing dollar sign from salary
nba_season_statistics$player_salary_in = gsub("\\$", "", nba_season_statistics$player_salary_in)

# removing commas from salary
nba_season_statistics$player_salary_in = as.numeric(gsub("\\,", "", nba_season_statistics$player_salary_in))

# removing percentage signs
nba_season_statistics$ts_percent = as.numeric(gsub("%", "", nba_season_statistics$ts_percent))
nba_season_statistics$f_tr = as.numeric(gsub("%", "", nba_season_statistics$f_tr))
nba_season_statistics$fg_percent = as.numeric(gsub("%", "", nba_season_statistics$fg_percent))
nba_season_statistics$x2p_percent = as.numeric(gsub("%", "", nba_season_statistics$x2p_percent))
nba_season_statistics$ft_percent = as.numeric(gsub("%", "", nba_season_statistics$ft_percent))
nba_season_statistics$e_fg_percent = as.numeric(gsub("%", "", nba_season_statistics$e_fg_percent))


# renaming player_salary_in to player_salary
nba_season_statistics_cleaned <- nba_season_statistics |>
  rename(player_salary = player_salary_in)

# filtering out missing salaries
nba_season_statistics_cleaned <- nba_season_statistics_cleaned |>
  filter(player_salary != "NA")

# ensuring the 5 primary positions are measured
nba_season_statistics_cleaned <- nba_season_statistics_cleaned |>
  filter(pos == "C" | pos == "PF" | pos == "SF" | pos == "SG" |
           pos == "PG")

# Finding initial distribution and log-transforming
nba_season_statistics_cleaned |>
  ggplot(aes(x = player_salary)) +
  geom_histogram(color = "white") 

# log-transforming player_salary and making missing values 0

# missing values are percentages and come as a result of no shots attempted
# thus 0/0 listed as NA
nba_season_statistics_cleaned <- nba_season_statistics_cleaned |>
  mutate(log_10_player_salary = log10(player_salary)) |>
  mutate(ts_percent = ifelse(is.na(ts_percent), 0, ts_percent),
         x3p_ar = ifelse(is.na(x3p_ar), 0, x3p_ar),
         f_tr = ifelse(is.na(f_tr), 0, f_tr),
         tov_percent = ifelse(is.na(tov_percent), 0, tov_percent),
         fg_percent = ifelse(is.na(fg_percent), 0, fg_percent),
         x3p_percent = ifelse(is.na(x3p_percent), 0, x3p_percent),
         x2p_percent = ifelse(is.na(x2p_percent), 0, x2p_percent),
         e_fg_percent = ifelse(is.na(e_fg_percent), 0, e_fg_percent),
         ft_percent = ifelse(is.na(ft_percent), 0, ft_percent)) |>
  select(-blanl, -blank2)

# new distribution
nba_season_statistics_cleaned |>
  ggplot(aes(x = log_10_player_salary)) +
  geom_histogram(color = "white") +
  theme_minimal() +
  scale_x_log10()
  labs(title = "Distribution of NBA Player Yearly Salary: Log-Transformed")

  
  
# saving cleaned target variable dataset
write_csv(nba_season_statistics_cleaned, file = here("data/nba_season_statistics_cleaned.csv"))
  
# splitting data
nba_split <- initial_split(nba_season_statistics_cleaned, prop = 0.8, 
                           strata = log_10_player_salary)

nba_train <- training(nba_split)
nba_test <- testing(nba_split)

nba_folds <- vfold_cv(nba_train, v = 5, repeats = 3)

# writing new datasets in
save(nba_split, file = here("data_splits/nba_split.rda"))
save(nba_train, file = here("data_splits/nba_train.rda"))
save(nba_test, file = here("data_splits/nba_test.rda"))
save(nba_folds, file = here("data_splits/nba_folds.rda"))

