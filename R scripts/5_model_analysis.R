# 5: Model analysis

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
load(here("results/tuned_bt_fe.rda"))
load(here("results/tuned_elastic_fe.rda"))
load(here("results/tuned_knn_fe.rda"))
load(here("results/tuned_rf_fe.rda"))

# loading linear/null
load(here("results/null_fit_folds_fe.rda"))
load(here("results/null_fit_folds_kitchen.rda"))
load(here("results/lm_fit_folds_kitchen.rda"))
load(here("results/lm_fit_folds_fe.rda"))

# autoplots: determining good parameter ranges
autoplot(tuned_rf_kitchen, metric = "rmse")
autoplot(tuned_knn_kitchen, metric = "rmse") +
  labs(y = "RMSE")
autoplot(tuned_elastic_kitchen, metric = "rmse")
autoplot(tuned_bt_kitchen, metric = "rmse")

autoplot(tuned_rf_fe, metric = "rmse")
autoplot(tuned_knn_fe, metric = "rmse") 
autoplot(tuned_elastic_fe, metric = "rmse")
autoplot(tuned_bt_fe, metric = "rmse")

# tables of best tuned models
## with kitchen sink recipe
tbl_rf_kitchen <- tuned_rf_kitchen |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "Random Forest, kitchen sink recipe") |>
  select(model, mtry, min_n, mean, n, std_err)

tbl_knn_kitchen <- tuned_knn_kitchen |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "K Nearest Neighbor, kitchen sink recipe") |>
  select(model, neighbors, mean, n, std_err)

tbl_bt_kitchen <- tuned_bt_kitchen |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "Boosted Tree, kitchen sink recipe") |>
  select(model, mtry, min_n, learn_rate, mean, n, std_err) 

tbl_elastic_kitchen <- tuned_elastic_kitchen |> 
  show_best("rmse") |>
  slice_head(n = 1) |>
  slice_min(mean) |>
  mutate(model = "Elastic net, kitchen sink recipe") |>
  select(model, penalty, mixture, mean, n, std_err) 

tbl_lm_kitchen <- lm_fit_folds_kitchen |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "OLS, kitchen sink recipe") |>
  select(model, mean, n, std_err)

tbl_null_kitchen <- null_fit_folds_kitchen |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "Null, kitchen sink recipe") |>
  select(model, mean, n, std_err) 

## with feature-engineered recipe
tbl_rf_fe <- tuned_rf_fe |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "Random Forest, feature-engineered recipe") |>
  select(model, mtry, min_n, mean, n, std_err) 

tbl_knn_fe <- tuned_knn_fe |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "K Nearest Neighbor, feature-engineered recipe") |>
  select(model, neighbors, mean, n, std_err) 

tbl_bt_fe <- tuned_bt_fe |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "Boosted Tree, feature-engineered recipe") |>
  select(model, mtry, min_n, learn_rate, mean, n, std_err) 

tbl_elastic_fe <- tuned_elastic_fe |> 
  show_best("rmse") |>
  slice_head(n = 1) |>
  slice_min(mean) |>
  mutate(model = "Elastic net, feature-engineered recipe")|>
  select(model, penalty, mixture, mean, n, std_err)

tbl_lm_fe <- lm_fit_folds_fe |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "OLS, feature-engineered recipe") |>
  select(model, mean, n, std_err) 

tbl_null_fe <- null_fit_folds_fe |>
  show_best("rmse") |>
  slice_min(mean) |>
  mutate(model = "Null, feature-engineered recipe") |>
  select(model, mean, n, std_err) 

tbl_model_results <- bind_rows(tbl_rf_kitchen, tbl_bt_kitchen, tbl_knn_kitchen, tbl_elastic_kitchen, 
                               tbl_lm_kitchen, tbl_null_kitchen, tbl_rf_fe, tbl_bt_fe, 
                               tbl_knn_fe, tbl_elastic_fe, tbl_lm_fe, tbl_null_fe,) |> 
  arrange(mean) 

# saving table
save(tbl_model_results, file = here("results/tbl_model_results.rda"))

