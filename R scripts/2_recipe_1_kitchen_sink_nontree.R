# Recipe 1: Kitchen sink, nonparametric

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(janitor)
library(skimr)
library(ggplot2)

# load data split and folds
load(here("data_splits/nba_split.rda"))
load(here("data_splits/nba_train.rda"))
load(here("data_splits/nba_test.rda"))
load(here("data_splits/nba_folds.rda"))

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(8)

# LM/null recipe, kitchen sink
nba_recipe_one_nontree <- recipe(log_10_player_salary ~ ., data = nba_train) |>
  step_rm(player_name) |>
  step_lincomb(all_numeric_predictors()) |>
  step_novel(pos, tm) |>
  step_dummy(pos, tm, one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_nzv() |>
  step_normalize() 

#prep(nba_recipe_one_nontree) |>
  #bake(new_data = NULL)

# saving recipes
save(nba_recipe_one_nontree, file = here("recipes/nba_recipe_one_nontree.rda"))