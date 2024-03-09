# 3: Tuning boosted tree model, kitchen sink recipe  ----

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

# model specifications ----
bt_model <- boost_tree(mode = "regression",
                                 min_n = tune(),
                                 mtry = tune(),
                                 learn_rate = tune()) |>
  set_engine("xgboost")

# define workflows ----
bt_workflow <- workflow() |>
  add_model(bt_model) |>
  add_recipe(nba_recipe_one_tree)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_model) |>
  update(mtry = mtry(range = c(1, 16))) 

bt_grid <- grid_regular(bt_params, levels = 5)


# fit workflows/models ----
tuned_bt_kitchen <- tune_grid(bt_workflow,
                                nba_folds,
                                grid = bt_grid,
                                control = control_grid(save_workflow = TRUE))

# stopping cluster
stopCluster(cl)

# write out results (fitted/trained workflows) ---
save(tuned_bt_kitchen, file = here("results/tuned_bt_kitchen.rda"))

