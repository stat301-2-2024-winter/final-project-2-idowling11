# Script 1: Brief EDA

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(janitor)
library(skimr)
library(ggplot2)
library(dplyr)
library(splines)

# handle common conflicts
tidymodels_prefer()

# setting seed
set.seed(8)

# loading training data
load(here("data_splits/nba_train.rda"))

# splitting portion of training set for EDA
nba_eda_split <- initial_split(nba_train, prop = 0.5, 
                               strata = log_10_player_salary)

nba_train_eda <- training(nba_eda_split)

## Correlation Plot for numerics ----
num_nba_values <- nba_train_eda |>
  select(where(is.numeric))

correlation_log_salary <- cor(num_nba_values)
nba_corrplot <- corrplot::corrplot(correlation_log_salary, method = "color", tl.cex = 0.6)

# potential interactions ----

# teams and win shares
nba_train_eda |>
  ggplot(aes(x = ws, y = log_10_player_salary)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm") +
  facet_wrap(~tm) 

nba_train_eda |>
  ggplot(aes(x = log_10_player_salary)) +
  geom_histogram() +
  facet_wrap(~tm)

# field goals and points
nba_train_eda |>
  ggplot(aes(x = fg, y = log_10_player_salary, color = pts)) +
  geom_point() 

nba_train_eda |>
  ggplot(aes(x = sqrt(fg), y = log_10_player_salary, color = sqrt(pts))) +
  geom_point() 

# effective field goal percentage and true shooting percentage
nba_train_eda |>
  ggplot(aes(x = ts_percent, y = log_10_player_salary, color = e_fg_percent)) +
  geom_point() 

# offensive and total rebounds
nba_train_eda |>
  ggplot(aes(x = sqrt(orb), y = log_10_player_salary, color = sqrt(trb))) +
  geom_point()

# fg and fga 
nba_train_eda |>
  ggplot(aes(x = fga, y = log_10_player_salary, color = fg)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(fga), y = log_10_player_salary, color = sqrt(fg))) +
  geom_point()

# g and mp
nba_train_eda |>
  ggplot(aes(x = g, y = log_10_player_salary, color = mp)) +
  geom_point() +
  geom_smooth(method = "lm")

# transformations: looking at relationships with log10 salary ----

# rebounds
nba_train_eda |>
  ggplot(aes(x = trb, y = log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(trb), y = log_10_player_salary)) +
  geom_point()

# assists
nba_train_eda |>
  ggplot(aes(x = ast, y = log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(ast), y = log_10_player_salary)) +
  geom_point() 

# blk -- needs log transformation, but regular log results in nAN -> yeo-Johnson
nba_train_eda |>
  ggplot(aes(x = blk)) +
  geom_density(fill = "blue")

nba_train_eda |>
  ggplot(aes(x = log10(blk))) +
  geom_density(fill = "blue")

nba_train_eda |>
  ggplot(aes(x = blk, y = log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = log10(blk), y = log_10_player_salary)) +
  geom_point() +
  geom_smooth(method = "lm")

# age
nba_train_eda |>
  ggplot(aes(x = age)) +
  geom_density(fill = "blue")

nba_train_eda |>
  ggplot(aes(x = age, y = log_10_player_salary)) +
  geom_point() +
  geom_smooth(
    method = lm,
    formula = y ~ ns(x, df = 10),
    color = "lightblue",
    se = FALSE) 

# per
nba_train_eda |>
  ggplot(aes(x = per, y = log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(per), y = log_10_player_salary)) +
  geom_point()

# e_fg_percentage 
nba_train_eda |>
  ggplot(aes(x = e_fg_percent)) +
  geom_histogram() 

nba_train_eda |>
  ggplot(aes(x = e_fg_percent, y = log_10_player_salary)) +
  geom_point() 

# usage percentage
nba_train_eda |>
  ggplot(aes(x = usg_percent, y = log_10_player_salary)) +
  geom_point(alpha = 0.4) 

# offensive win shares -- negative values, right skew, yeo johnson could work
nba_train_eda |>
  ggplot(aes(x = ows, y = log_10_player_salary)) +
  geom_point(alpha = 0.5)

# dws -- negative values, right skew, yeo johnson could work
nba_train_eda |>
  ggplot(aes(x = dws, y = log_10_player_salary)) +
  geom_point(alpha = 0.5)

# win shares per 48
nba_train_eda |>
  ggplot(aes(x = ws_48)) +
  geom_histogram()

nba_train_eda |>
  ggplot(aes(x = ws_48, y = log_10_player_salary)) +
  geom_point()

# ws -- negative values, right skew, yeo-johnson could be useful
nba_train_eda |>
  ggplot(aes(x = ws)) +
  geom_histogram()

# obpm
nba_train_eda |>
  ggplot(aes(x = obpm, y = log_10_player_salary)) +
  geom_point(alpha = 0.4)

# dbpm. One outlier north of 40. Only 7 outliers missing with new scale
nba_train_eda |>
  ggplot(aes(x = dbpm, y = log_10_player_salary)) +
  geom_point(alpha = 0.4) +
  xlim(c(-10, 10))

# bpm
nba_train_eda |>
  ggplot(aes(x = bpm, y = log_10_player_salary)) +
  geom_point(alpha = 0.4)

# vorp --> some negative values... use YeoJohnson
nba_train_eda |>
  ggplot(aes(x = vorp, log_10_player_salary)) +
  geom_point()

# fg
nba_train_eda |>
  ggplot(aes(x = fg, log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(fg), log_10_player_salary)) +
  geom_point()

# fga
nba_train_eda |>
  ggplot(aes(x = fga, log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(fga), log_10_player_salary)) +
  geom_point()

# fg_percent -- normal
nba_train_eda |>
  ggplot(aes(fg_percent)) +
  geom_histogram(color = "white")

nba_train_eda |>
  ggplot(aes(x = fg_percent, log_10_player_salary)) +
  geom_point(alpha = 0.4)

# three-pointers
nba_train_eda |>
  ggplot(aes(x = x3p, log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(x3p), log_10_player_salary)) +
  geom_point()

# three-pointers attempted
nba_train_eda |>
  ggplot(aes(x = x3pa, log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(x3pa), log_10_player_salary)) +
  geom_point()

# three-point percentage -- could use boxcox 
nba_train_eda |>
  ggplot(aes(x = x3p_percent)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = x3p_percent, y = log_10_player_salary)) +
  geom_point(alpha = 0.5) 

# two-pointers/attempted
nba_train_eda |>
  ggplot(aes(x = x2p, y = log_10_player_salary)) +
  geom_point(alpha = 0.5) 

nba_train_eda |>
  ggplot(aes(x = sqrt(x2p), y = log_10_player_salary)) +
  geom_point(alpha = 0.5) 

# two-point percentage 
nba_train_eda |>
  ggplot(aes(x = x2p_percent)) +
  geom_histogram()

nba_train_eda |>
  ggplot(aes(x = x2p_percent, y = log_10_player_salary)) +
  geom_point(alpha = 0.5)

# free throws/attempts
nba_train_eda |>
  ggplot(aes(x = ft, y = log_10_player_salary)) +
  geom_point(alpha = 0.5) 

nba_train_eda |>
  ggplot(aes(x = sqrt(ft), y = log_10_player_salary)) +
  geom_point(alpha = 0.5) 

# free throw percentage -- left skew, use boxcox
nba_train_eda |>
  ggplot(aes(x = ft_percent)) +
  geom_histogram()

nba_train_eda |>
  ggplot(aes(x = ft_percent, y = log_10_player_salary)) +
  geom_point(alpha = 0.5)

# steals
nba_train_eda |>
  ggplot(aes(x = stl, y = log_10_player_salary)) +
  geom_point()

nba_train_eda |>
  ggplot(aes(x = sqrt(stl), y = log_10_player_salary)) +
  geom_point()

# assist percentage
nba_train_eda |>
  ggplot(aes(x = sqrt(ast_percent), y = log_10_player_salary)) +
  geom_point()

# saving EDA subset of training data and corr plot
save(nba_train_eda, file = here("data_splits/nba_train_eda.rda"))
save(nba_corrplot, file = here("results/nba_corrplot.rda"))
