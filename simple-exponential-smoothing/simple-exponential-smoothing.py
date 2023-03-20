import pandas as pd

# Create a pandas dataframe from github csv file
df = pd.read_csv('https://raw.githubusercontent.com/shaphero/LessDumbData/main/moving-average/sample-traffic-data.csv')

# Create a new column with the simple exponential smoothing calculation
df['SES'] = df['Sessions'].shift(1).ewm(alpha=0.2, adjust=False).mean()

# Replace NA values with the first value
df['SES'] = df['SES'].fillna(df['Sessions'].iloc[0])

# Create a new column with the total error
df['error'] = df['SES'] - df['Sessions']

# Create a new column with the absolute error
df['abs_error'] = abs(df['error'])

# Create a new column with the percentage error
df['pct_error'] = df['abs_error'] / df['Sessions']

# Create a new column with the error squared
df['squared_error'] = df['error'] ** 2

# Create the relative and absolute bias values
absolute_bias = df['error'].dropna().mean()
rel_bias = absolute_bias / df['Sessions'].mean()

# Create the relative mape value
rel_mape = df['pct_error'].mean()

# Create the relative and absolute mae values
absolute_mae = df['abs_error'].mean()
rel_mae = absolute_mae / df['Sessions'].mean()

# Create the relative and absolute rmse values
absolute_rmse = df['squared_error'].mean() ** 0.5
rel_rmse = absolute_rmse / df['Sessions'].mean()

# Create a dictionary of the results
data = {
    'Absolute': {
        'Bias': absolute_bias,
        'MAPE': "-",
        'MAE': absolute_mae,
        'RMSE': absolute_rmse
    },
    'Relative': {
        'Bias': rel_bias,
        'MAPE': rel_mape,
        'MAE': rel_mae,
        'RMSE': rel_rmse
    }
}

# Create a pandas dataframe from the dictionary
df = pd.DataFrame(data)

# Display the dataframe with two decimal places
print(df.round(2))