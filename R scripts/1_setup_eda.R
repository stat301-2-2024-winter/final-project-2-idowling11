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

## target variable distribution ----
nba_train_eda |>
  ggplot(aes(x = log_10_player_salary)) +
  geom_density(fill = "skyblue") +
  labs(title = "Exploring Player Salary (log transformed)",
       x = "Player Salary, log-transformed")

## categorical variable distribution ----
## position
nba_train_eda |>
  ggplot(aes(x = log_10_player_salary)) +
  geom_density(fill = "skyblue") +
  facet_wrap(~pos) +
  labs(title = "Exploring Player Salary by Position", 
       x = "Player Salary, log-transformed")


## season start
nba_train_eda |>
  ggplot(aes(x = log_10_player_salary)) +
  geom_density(fill = "skyblue") +
  facet_wrap(~factor(season_start)) +
  labs(title = "Exploring Player Salary by Year", 
       x = "Player Salary, log-transformed")

## team
nba_train_eda |>
  ggplot(aes(x = log_10_player_salary)) +
  geom_density(fill = "skyblue") +
  facet_wrap(~tm) +
  labs(title = "Exploring Player Salary by Team", 
       x = "Player Salary, log-transformed")

# potential interactions ----

# ast and position
nba_train_eda |>
  ggplot(aes(x = sqrt(ast), y = log_10_player_salary)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm") +
  facet_wrap(~pos) 


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

# defensive and total rebounds
nba_train_eda |>
  ggplot(aes(x = sqrt(drb), y = log_10_player_salary, color = sqrt(trb))) +
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

# transformations ----

# rebounds
nba_train_eda |>
  ggplot(aes(x = trb)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(trb))) +
  geom_density()

# assists
nba_train_eda |>
  ggplot(aes(x = ast)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(ast))) +
  geom_density() 

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
    formula = y ~ ns(x, df = 3),
    color = "lightblue",
    se = FALSE) 

# per
nba_train_eda |>
  ggplot(aes(x = per)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(per))) +
  geom_density()

# e_fg_percentage 
nba_train_eda |>
  ggplot(aes(x = e_fg_percent)) +
  geom_density() 

# usage percentage
nba_train_eda |>
  ggplot(aes(x = usg_percent, y = log_10_player_salary)) +
  geom_point(alpha = 0.4) 

nba_train_eda |>
  ggplot(aes(x = usg_percent)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(usg_percent))) +
  geom_density()

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
  geom_density()

nba_train_eda |>
  ggplot(aes(x = ws_48, y = log_10_player_salary)) +
  geom_point()

# ws -- negative values, right skew, yeo-johnson could be useful
nba_train_eda |>
  ggplot(aes(x = ws)) +
  geom_density()

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
  ggplot(aes(x = fg)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(fg))) +
  geom_density()

# fga
nba_train_eda |>
  ggplot(aes(x = fga)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(fga))) +
  geom_density()

# fg_percent -- normal
nba_train_eda |>
  ggplot(aes(fg_percent)) +
  geom_histogram(color = "white")

nba_train_eda |>
  ggplot(aes(x = fg_percent, log_10_player_salary)) +
  geom_point(alpha = 0.4)

# three-pointers -- some rows with log removed because of 0 values --> Use YeoJohnson
nba_train_eda |>
  ggplot(aes(x = x3p)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = log(x3p))) +
  geom_density()

# three-pointers attempted
nba_train_eda |>
  ggplot(aes(x = x3pa)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = log(x3pa))) +
  geom_density()

# three-point percentage -- could use YeoJohnson
nba_train_eda |>
  ggplot(aes(x = x3p_percent)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = x3p_percent, y = log_10_player_salary)) +
  geom_point(alpha = 0.5) 

# two-pointers/attempted
nba_train_eda |>
  ggplot(aes(x = x2p)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(x2p))) +
  geom_density()

# two-point percentage 
nba_train_eda |>
  ggplot(aes(x = x2p_percent)) +
  geom_histogram()

nba_train_eda |>
  ggplot(aes(x = x2p_percent, y = log_10_player_salary)) +
  geom_point(alpha = 0.5)

# free throws/attempts
nba_train_eda |>
  ggplot(aes(x = ft)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(ft))) +
  geom_density()

# free throw percentage -- left skew, try squaring it
nba_train_eda |>
  ggplot(aes(x = ft_percent)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = ft_percent^2)) +
  geom_density()


# steals
nba_train_eda |>
  ggplot(aes(x = stl)) +
  geom_density()

nba_train_eda |>
  ggplot(aes(x = sqrt(stl))) +
  geom_density()

# assist percentage
nba_train_eda |>
  ggplot(aes(x = sqrt(ast_percent))) +
  geom_histogram(color = "white")

# saving EDA subset of training data
save(nba_train_eda, file = here("data_splits/nba_train_eda.rda"))


