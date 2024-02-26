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

# load recipe
load(here("recipes/nba_recipe_one_lm.rda"))

# handle common conflicts
tidymodels_prefer()

# linear model specification, workflow
lm_mod <- linear_reg(mode = "regression") |>
  set_engine("lm")

lm_workflow <- workflow() |>
  add_model(lm_mod) |>
  add_recipe(nba_recipe_one_lm)

# null baseline model specification, workflow
null_spec <- null_model() |>
  set_engine("parsnip") |>
  set_mode("regression") 

null_workflow <- workflow() |> 
  add_model(null_spec) |>
  add_recipe(nba_recipe_one_lm)

keep_pred <- control_resamples(save_pred = TRUE)

# fit workflows/models ----
lm_fit_folds <- fit_resamples(lm_workflow,
                              resamples = nba_folds,
                              control = keep_pred)

null_fit_folds <- null_workflow |> 
  fit_resamples(
    resamples = nba_folds, 
    control = control_resamples(save_workflow = TRUE)
  )


nba_metrics_resamples_rmse <- bind_rows(lm_fit_folds |>
                                collect_metrics() |>
                                mutate(model = "OLS")) |>
  bind_rows(null_fit_folds |>
              collect_metrics() |>
              mutate(model = "Null")) |>
  filter(.metric == "rmse") 

# saving resample fit
save(nba_metrics_resamples_rmse, file = here("results/nba_metrics_resamples_rmse.rda"))


