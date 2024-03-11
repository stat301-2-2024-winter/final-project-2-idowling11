# Recipe 1: Kitchen sink, parametric

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(janitor)
library(skimr)
library(ggplot2)
# Recipe 2: Feature-engineered recipe: non-parametric
# load data split and folds
load(here("data_splits/nba_split.rda"))
load(here("data_splits/nba_train.rda"))
load(here("data_splits/nba_test.rda"))
load(here("data_splits/nba_folds.rda"))

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(8)

# tree recipe, kitchen sink
nba_recipe_one_tree <- recipe(log_10_player_salary ~ ., data = nba_train) |>
  step_rm(player_name, player_salary) |>
  step_lincomb(all_numeric_predictors()) |>
  step_novel(pos, tm) |>
  step_dummy(pos, tm, one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_nzv(all_predictors()) |>
  step_normalize(all_numeric_predictors()) 

prep(nba_recipe_one_tree) |>
  bake(new_data = NULL)

# saving recipes
save(nba_recipe_one_tree, file = here("recipes/nba_recipe_one_tree.rda"))
