# Recipe 2: Feature-engineered recipe: parametric

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

# feature-engineered recipe
nba_recipe_two_nontree <- recipe(log_10_player_salary ~ ., data = nba_train) |>
  step_rm(player_name, player_salary, number, stl_percent, x3p_ar, f_tr,
          orb_percent, drb_percent, trb_percent, blk_percent, tov_percent, pf) |>
  step_sqrt(ast_percent, usg_percent, fg, fga, x3p, x3pa, x2p, x2pa,
            ft, fta, stl, pts, trb, drb, orb) |>
  step_YeoJohnson(ows, dws, ws, vorp, per, x3p_percent, ft_percent, blk) |>
  step_novel(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |>
  step_interact(~starts_with("pos"):ast) |>
  step_interact(~starts_with("tm"):ws) |>
  step_interact(~fg:pts) |>
  step_interact(~e_fg_percent:ts_percent) |>
  step_interact(~x2p_percent:e_fg_percent) |>
  step_interact(~ows:ws) |>
  step_interact(~dws:ws) |>
  step_interact(~orb:trb) |>
  step_interact(~drb:trb) |>
  step_interact(~fga:fg) |>
  step_interact(~g:mp) |>
  step_ns(age, deg_free = 10) |>
  step_lincomb(all_numeric_predictors()) |>
  step_zv(all_predictors()) |>
  step_nzv(all_predictors()) |>
  step_normalize(all_numeric_predictors()) 

prep(nba_recipe_two_nontree) |>
  bake(new_data = NULL)

# saving recipes
save(nba_recipe_two_nontree, file = here("recipes/nba_recipe_two_nontree.rda"))