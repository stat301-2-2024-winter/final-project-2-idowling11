# Recipe 2: Feature-engineered recipe: non-parametric

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(janitor)
library(skimr)
library(ggplot2)
library(textrecipes)

# load data split and folds
load(here("data_splits/nba_split.rda"))
load(here("data_splits/nba_train.rda"))
load(here("data_splits/nba_test.rda"))
load(here("data_splits/nba_folds.rda"))

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(8)

nba_train |>
  group_by(pos) |>
  count() 


# feature-engineered recipe
nba_recipe_two_tree <- recipe(log_10_player_salary ~ ., data = nba_train) |>
  step_rm(player_name, player_salary, number, stl_percent, x3p_ar, f_tr,
          orb_percent, drb_percent, trb_percent, blk_percent, tov_percent, pf, tm) |>
  step_cut(season_start, breaks = c(1990, 1995, 2000, 2005, 2010, 2015)) |>
  step_novel(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_lincomb(all_numeric_predictors()) |>
  step_zv(all_predictors()) |>
  step_nzv(all_predictors()) |>
  step_normalize(all_numeric_predictors()) 

prep(nba_recipe_two_tree) |>
  bake(new_data = NULL)

# saving recipes
save(nba_recipe_two_tree, file = here("recipes/nba_recipe_two_tree.rda"))