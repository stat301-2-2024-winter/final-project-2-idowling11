# 3: Tuning linear model  ----
# Define and fit ...

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
load("data_splits/nba_train.rda")

# load pre-processing/feature engineering/recipe
load("recipes/nba_recipe_one.rda")

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
cl <- makePSOCKcluster(num_cores)

registerDoParallel(cl)

# linear model specifications ----
lm_mod <- linear_reg(mode = "regression") |>
  set_engine("lm")

# define workflows ----
lm_workflow <- workflow() |>
  add_model(lm_mod) |>
  add_recipe(nba_recipe_one)

# hyperparameter tuning values ----
lm_params <- extract_parameter_set_dials(rf_model) |>
  update(mtry = mtry(range = c(1, 14)))

rf_grid <- grid_regular(rf_params, levels = 5)

# grid_random(rf_params, size = 20) # good for many parameters
# grid_latin_hypercube(rf_params, size = 50)

# fit workflows/models ----
tuned_rf <- tune_grid(rf_workflow,
                      carseats_folds,
                      grid = rf_grid,
                      control = control_grid(save_workflow = TRUE))

# Stopping cluster
stopCluster(cl)