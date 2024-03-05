# 5: Model analysis and final fit

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

# loading fits/tuned models
load(here("results/tuned_elastic_kitchen.rda"))
load(here("results/tuned_rf_kitchen.rda"))
load(here("results/tuned_knn_kitchen.rda"))

# determining best tuned models
best_rf_kitchen <- select_best(tuned_rf_kitchen, metric = "rmse")
best_knn_kitchen <- select_best(tuned_knn_kitchen, metric = "rmse")
best_elastic_kitchen <- select_best(tuned_elastic_kitchen, metric = "rmse")




#best_bt_kitchen <- select_best(tuned_bt_kitchen, metric = "rmse")