# 3: Tuning knn model, kitchen sink recipe  ----

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
knn_model <- nearest_neighbor(mode = "regression", neighbors = tune()) |>
  set_engine("kknn")

# define workflows ----
knn_workflow <- workflow() |>
  add_model(knn_model) |>
  add_recipe(nba_recipe_one_tree)

# hyperparameter tuning values ----
knn_params <- extract_parameter_set_dials(knn_model) 
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
tuned_knn_kitchen <- tune_grid(knn_workflow,
                       nba_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE))

# stopping cluster
stopCluster(cl)

# write out results (fitted/trained workflows) ----
save(tuned_knn_kitchen, file = here("results/tuned_knn_kitchen.rda"))