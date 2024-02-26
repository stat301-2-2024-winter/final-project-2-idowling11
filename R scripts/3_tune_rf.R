# 3: Tuning random forest model  ----

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

# load pre-processing/feature engineering/recipes

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
cl <- makePSOCKcluster(num_cores)

registerDoParallel(cl)

#  model specifications ----


# define workflows ----


# hyperparameter tuning values ----


# grid_random(rf_params, size = 20) # good for many parameters
# grid_latin_hypercube(rf_params, size = 50)

# fit workflows/models ----

# Stopping cluster
stopCluster(cl)