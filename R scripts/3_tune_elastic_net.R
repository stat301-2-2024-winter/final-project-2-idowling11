# 3: Tuning elastic net model  ----

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
load(here("recipes/nba_recipe_one_nontree.rda"))

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
cl <- makePSOCKcluster(num_cores)

registerDoParallel(cl)

#  model specifications ----
elastic_model <- linear_reg(penalty = tune(),  mixture = tune()) |>
  set_engine("glmnet")

# define workflows ----
elastic_workflow <- workflow() |>
  add_model(elastic_model) |>
  add_recipe(nba_recipe_one_nontree)

# hyperparameter tuning values ----
elastic_params <- extract_parameter_set_dials(elastic_model) |>
  update(penalty = penalty(range = c(-10, 0)))

elastic_grid <- grid_regular(elastic_params, levels = 5)

# fit workflows/models ----
tuned_elastic_kitchen <- tune_grid(elastic_workflow,
                              nba_folds,
                              grid = elastic_grid,
                              control = control_grid(save_workflow = TRUE))

# Stopping cluster
stopCluster(cl)

# saving tune
save(tuned_elastic_kitchen, file = here("results/tuned_elastic_kitchen.rda"))