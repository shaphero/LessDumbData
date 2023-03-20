df <- read_csv('https://raw.githubusercontent.com/shaphero/LessDumbData/main/moving-average/sample-traffic-data.csv')

# Calculate the Simple Exponential Smoothing (SES) values
alpha <- 0.2
df <- df %>% mutate(SES = lag(Sessions, default = Sessions[1]))
for (i in 2:nrow(df)) {
    df$SES[i] <- alpha * df$Sessions[i - 1] + (1 - alpha) * df$SES[i - 1]
}

# Calculate errors
df$error <- df$SES - df$Sessions
df$abs_error <- abs(df$error)
df$pct_error <- df$abs_error / df$Sessions
df$squared_error <- df$error^2

# Calculate metrics
absolute_bias <- mean(df$error, na.rm = TRUE)
rel_bias <- absolute_bias / mean(df$Sessions, na.rm = TRUE)

rel_mape <- mean(df$pct_error, na.rm = TRUE)

absolute_mae <- mean(df$abs_error, na.rm = TRUE)
rel_mae <- absolute_mae / mean(df$Sessions, na.rm = TRUE)

absolute_rmse <- sqrt(mean(df$squared_error, na.rm = TRUE))
rel_rmse <- absolute_rmse / mean(df$Sessions, na.rm = TRUE)

# Create a data frame with the results
results <- tibble(
    Metric = c("Bias", "MAPE", "MAE", "RMSE"),
    Absolute = c(absolute_bias, "-", absolute_mae, absolute_rmse),
    Relative = c(rel_bias, rel_mape, rel_mae, rel_rmse)
)

# Print the results rounded to two decimal places
print(round(results, 2))
