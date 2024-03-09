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
load(here("results/tuned_bt_kitchen.rda"))

# autoplots: determining good parameter ranges, round 1 of tuning
autoplot(tuned_rf_kitchen, metric = "rmse")
autoplot(tuned_knn_kitchen, metric = "rmse") +
  labs(y = "RMSE")
autoplot(tuned_elastic_kitchen, metric = "rmse")
autoplot(tuned_bt_kitchen, metric = "rmse")

# determining best tuned models
best_rf_kitchen <- select_best(tuned_rf_kitchen, metric = "rmse")
best_knn_kitchen <- select_best(tuned_knn_kitchen, metric = "rmse")
best_elastic_kitchen <- select_best(tuned_elastic_kitchen, metric = "rmse")
best_bt_kitchen <- show_best(tuned_bt_kitchen, metric = "rmse")

tbl_bt <- tuned_bt_kitchen |>
  show_best("rsq") |>
  slice_min(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Random Forest")
