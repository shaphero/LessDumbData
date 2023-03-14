library(tidyverse)
library(zoo)

# Read the data from Github
df <- read_csv('https://raw.githubusercontent.com/shaphero/LessDumbData/main/moving-average/sample-traffic-data.csv')

# Create a new column with the moving average

df$moving_average <- rollapply(df$Sessions, width = 3, FUN = mean, align = "right", fill = NA)

df$moving_average <- lag(df$moving_average)

# Remove NaN rows
df <- df %>% drop_na()

# Create a new column with the total error
df$error <- df$moving_average - df$Sessions

# Create a new column with the absolute error
df$abs_error <- abs(df$error)

# Create a new column with the percentage error
df$pct_error <- df$abs_error / df$Sessions

# Create a new column with the error squared
df$squared_error <- df$error ^ 2

# Create the relative and absolute bias values
absolute_bias <- mean(df$error, na.rm = TRUE)
rel_bias <- absolute_bias / mean(df$Sessions, na.rm = TRUE)

# Create the relative mape value
rel_mape <- mean(df$pct_error, na.rm = TRUE)

# Create the relative and absolute mae values
absolute_mae <- mean(df$abs_error, na.rm = TRUE)
rel_mae <- absolute_mae / mean(df$Sessions, na.rm = TRUE)

# Create the relative and absolute rmse values
absolute_rmse <- sqrt(mean(df$squared_error, na.rm = TRUE))
rel_rmse <- absolute_rmse / mean(df$Sessions, na.rm = TRUE)

# Print the results
cat(paste0('Absolute Bias: ', round(absolute_bias, 2), '\n'))
cat(paste0('Relative Bias: ', round(rel_bias, 2), '\n'))
cat(paste0('Relative MAPE: ', round(rel_mape, 2), '\n'))
cat(paste0('Absolute MAE: ', round(absolute_mae, 2), '\n'))
cat(paste0('Relative MAE: ', round(rel_mae, 2), '\n'))
cat(paste0('Absolute RMSE: ', round(absolute_rmse, 2), '\n'))
cat(paste0('Relative RMSE: ', round(rel_rmse, 2), '\n'))
