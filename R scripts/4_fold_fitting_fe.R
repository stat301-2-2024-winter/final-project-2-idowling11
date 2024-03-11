# 4: Fitting to Folds: Feature-engineered
# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(janitor)
library(skimr)
library(ggplot2)

# load data split
load(here("data_splits/nba_split.rda"))
load(here("data_splits/nba_train.rda"))
load(here("data_splits/nba_test.rda"))
load(here("data_splits/nba_folds.rda"))

# load recipes
load(here("recipes/nba_recipe_two_tree.rda"))
load(here("recipes/nba_recipe_two_nontree.rda"))

# handle common conflicts
tidymodels_prefer()

# linear model kitchen sink specification, workflow
lm_mod_fe <- linear_reg(mode = "regression") |>
  set_engine("lm")

lm_workflow_fe <- workflow() |>
  add_model(lm_mod_fe) |>
  add_recipe(nba_recipe_two_nontree)

# null baseline model kitchen sink specification, workflow
null_spec_fe <- null_model() |>
  set_engine("parsnip") |>
  set_mode("regression") 

null_workflow_fe <- workflow() |> 
  add_model(null_spec_fe) |>
  add_recipe(nba_recipe_two_nontree)



keep_pred <- control_resamples(save_pred = TRUE)

# fit workflows/models ----
lm_fit_folds_fe <- fit_resamples(lm_workflow_fe,
                                      resamples = nba_folds,
                                      control = keep_pred)

null_fit_folds_fe <- null_workflow_fe |> 
  fit_resamples(
    resamples = nba_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

# saving resample fit
save(null_fit_folds_fe, file = here("results/null_fit_folds_fe.rda"))
save(lm_fit_folds_fe, file = here("results/lm_fit_folds_fe.rda"))