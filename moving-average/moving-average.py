import pandas as pd
from sklearn.metrics import mean_absolute_error, mean_absolute_percentage_error, mean_squared_error

# Create a pandas dataframe from github csv file
df = pd.read_csv('https://raw.githubusercontent.com/shaphero/LessDumbData/main/sample-traffic-data.csv')

# Create a new column with the moving average
df['moving_average'] = df['Sessions'].shift(1).rolling(window=3).mean()

# Remove NaN rows
df = df.dropna()

# Create a new column with the total error
df['error'] = df['moving_average'] - df['Sessions']

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


# print the results
print(f'Absolute Bias: {absolute_bias:.2f}')
print(f'Relative Bias: {rel_bias:.2f}')
print(f'Relative MAPE: {rel_mape:.2f}')
print(f'Absolute MAE: {absolute_mae:.2f}')
print(f'Relative MAE: {rel_mae:.2f}')
print(f'Absolute RMSE: {absolute_rmse:.2f}')
print(f'Relative RMSE: {rel_rmse:.2f}')







