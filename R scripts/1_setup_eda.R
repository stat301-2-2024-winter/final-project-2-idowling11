# Script 1: Brief EDA

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

# loading training data
load(here("data_splits/nba_train.rda"))

# splitting portion of training set for EDA
nba_eda_split <- initial_split(nba_train, prop = 0.5, 
                               strata = log_10_player_salary)

nba_train_eda <- training(nba_eda_split)

## Correlation Plot for numerics
### Note to self: FTR and stl_pct and xpa3R have basically no correlation to log salary, remove them
num_nba_values <- nba_train_eda |>
  select(where(is.numeric))

correlation_log_salary <- cor(num_nba_values)
corrplot::corrplot(correlation_log_salary, method = "color", tl.cex = 0.6)

# investigating relationship between games and games started
nba_train_eda |>
  ggplot(aes(x = g, y = gs)) +
  geom_point() +
  geom_smooth(method = "lm")

# between minutes played and games started
nba_train_eda |>
  ggplot(aes(x = mp, y = gs)) +
  geom_point() +
  geom_smooth(method = "lm")

# between total rebounds and total rebound percentage
nba_train_eda |>
  ggplot(aes(x = ast_percent, y = ast)) +
  geom_point() +
  geom_smooth(method = "lm")

# bpm used to calculate vorp --> potential interaction
nba_train_eda |>
  ggplot(aes(x = bpm, y = vorp)) +
  geom_point() +
  geom_smooth(method = "lm")

# three-pointers attempted and field goals attempted
nba_train_eda |>
  ggplot(aes(x = x3pa, y = fga)) +
  geom_point() +
  geom_smooth(method = "lm")

# points and OWS
nba_train_eda |>
  ggplot(aes(x = ows, y = pts)) +
  geom_point() +
  geom_smooth(method = "lm")
