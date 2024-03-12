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

# loading best model
load(here("results/tuned_rf_kitchen.rda"))

## final workflow
final_wflow <- tuned_rf_kitchen |> 
  extract_workflow(tuned_rf_kitchen) |>  
  finalize_workflow(select_best(tuned_rf_kitchen, metric = "rmse"))

## train final model
final_fit_train <- fit(final_wflow, nba_train)

# saving final fit
save(final_fit_train, file = here("results/final_fit_train.rda"))

nba_test_res <- predict(final_fit_train, new_data = nba_test |>
                               select(-log_10_player_salary))
nba_test_res <- bind_cols(nba_test_res, nba_test |>
                                   select(log_10_player_salary))

nba_metrics <- metric_set(rmse, rsq, mae)
final_fit_metrics <- nba_metrics(nba_test_res, truth = log_10_player_salary, estimate = .pred) 

# writing in final fit metrics
save(final_fit_metrics, file = here("results/final_fit_metrics.rda"))


# observed values vs. predicted values: best model
obs_pred_salary_plot_best <- ggplot(nba_test_res, aes(x = 10^log_10_player_salary, y = 10^.pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.3, color = "blue") + 
  labs(y = "Predicted Salary ($)", x = "Observed Salary ($) ",
       title = "Predicted vs. Observed Yearly NBA Salaries: 1990-2017") +
  coord_obs_pred() +
  ylim(0, 25000000) 

obs_pred_salary_plot_zoomed_best <- ggplot(nba_test_res, aes(x = 10^log_10_player_salary, y = 10^.pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.3, color = "blue") + 
  labs(y = "Predicted Salary ($)", x = "Observed Salary ($)",
       title = "Zooming in: Predicted vs. Observed NBA Yearly Salaries: 1990-2017",
       subtitle = "This only includes observed salaries under $10,000,000.") +
  coord_obs_pred() +
  xlim(0, 10000000) 

# writing in plots
save(obs_pred_salary_plot_zoomed_best, file = here("plots/obs_pred_salary_plot_zoomed_best.rda"))
save(obs_pred_salary_plot_best, file = here("plots/obs_pred_salary_plot_best.rda"))

