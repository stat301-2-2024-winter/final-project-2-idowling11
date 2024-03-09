# 3: Tuning random forest model for kitchen sink recipe  ----

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(parallel)
library(doParallel)

# set seed
set.seed(8)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data_splits/nba_train.rda"))
load(here("data_splits/nba_folds.rda"))

# load pre-processing/feature engineering/recipes
load(here("recipes/nba_recipe_one_tree.rda"))

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
cl <- makePSOCKcluster(num_cores)

registerDoParallel(cl)

#  model specifications ----
rf_model <- rand_forest(mode = "regression",
                        min_n = tune(),
                        mtry = tune(),
                        trees = 1000) |>
  set_engine("ranger")

# define workflows ----
rf_workflow <- workflow() |>
  add_model(rf_model) |>
  add_recipe(nba_recipe_one_tree)

# hyperparameter tuning values ----
rf_params <- extract_parameter_set_dials(rf_model) |>
  update(mtry = mtry(range = c(1, 16)))

rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
tuned_rf_kitchen <- tune_grid(rf_workflow,
                      nba_folds,
                      grid = rf_grid,
                      control = control_grid(save_workflow = TRUE))

# Stopping cluster
stopCluster(cl)

# saving tune
save(tuned_rf_kitchen, file = here("results/tuned_rf_kitchen.rda"))