# 4: Fitting to Folds
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
load(here("recipes/nba_recipe_one_tree.rda"))
load(here("recipes/nba_recipe_one_nontree.rda"))

# handle common conflicts
tidymodels_prefer()

# linear model kitchen sink specification, workflow
lm_mod_kitchen <- linear_reg(mode = "regression") |>
  set_engine("lm")

lm_workflow_kitchen <- workflow() |>
  add_model(lm_mod_kitchen) |>
  add_recipe(nba_recipe_one_nontree)

# null baseline model kitchen sink specification, workflow
null_spec_kitchen <- null_model() |>
  set_engine("parsnip") |>
  set_mode("regression") 

null_workflow_kitchen <- workflow() |> 
  add_model(null_spec_kitchen) |>
  add_recipe(nba_recipe_one_nontree)



keep_pred <- control_resamples(save_pred = TRUE)

# fit workflows/models ----
lm_fit_folds_kitchen <- fit_resamples(lm_workflow_kitchen,
                      resamples = nba_folds,
                      control = keep_pred)

null_fit_folds_kitchen <- null_workflow_kitchen |> 
  fit_resamples(
    resamples = nba_folds, 
    control = control_resamples(save_workflow = TRUE)
  )


nba_metrics_resamples_rmse <- bind_rows(lm_fit_folds_kitchen |>
                                collect_metrics() |>
                                mutate(model = "OLS")) |>
  bind_rows(null_fit_folds_kitchen |>
              collect_metrics() |>
              mutate(model = "Null")) |>
  filter(.metric == "rmse") 

# saving resample fit
save(nba_metrics_resamples_rmse, file = here("results/nba_metrics_resamples_rmse.rda"))


