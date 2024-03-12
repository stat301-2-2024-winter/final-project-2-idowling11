# 6: Final fit for best model on training data, testing prediction, and observed vs. predicted values plot

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

# load training and testing data
load(here("data_splits/nba_train.rda"))
load(here("data_splits/nba_test.rda"))

# loading baseline kitchen sink model
load(here("results/null_fit_folds_kitchen.rda"))

## final workflow
final_wflow_null <- null_fit_folds_kitchen |> 
  extract_workflow(select_best(null_fit_folds_kitchen, metric = "rmse"))

## train final model
final_null_fit_train <- fit(final_wflow_null, nba_train)

nba_test_res_null <- predict(final_null_fit_train, new_data = nba_test |>
                          select(-log_10_player_salary))
nba_test_res_null <- bind_cols(nba_test_res_null, nba_test |>
                            select(log_10_player_salary))

# observed values vs. predicted values: null model
obs_pred_salary_plot_null <- ggplot(nba_test_res_null, aes(x = 10^log_10_player_salary, y = 10^.pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.3, color = "blue") + 
  labs(y = "Predicted Salary ($)", x = "Observed Salary ($) ",
       title = "Baseline Model: Predicted vs. Observed Yearly NBA Salaries: 1990-2017") +
  coord_obs_pred()

obs_pred_salary_plot_zoomed_null <- ggplot(nba_test_res, aes(x = 10^log_10_player_salary, y = 10^.pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.3, color = "blue") + 
  labs(y = "Predicted Salary ($)", x = "Observed Salary ($)",
       title = "Zooming in: Predicted vs. Observed NBA Yearly Salaries: 1990-2017",
       subtitle = "This only includes observed salaries under $10,000,000.") +
  coord_obs_pred() +
  xlim(0, 10000000) 