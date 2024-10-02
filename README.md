# CNN-LSTM-Jakarta-Air-Pollution-Forecasting
**Purpose:**
Time series forecasting using [CNN-LSTM](https://github.com/ina-tantri/CNN-LSTM-Jakarta-Air-Pollution-Forecasting/blob/main/CNN-LSTM%20Air%20Pollution.ipynb) to predict air pollution (PM10) in Jakarta. The CNN components are used to capture the spatial effects by using different stations simultaneously, while the LSTM is used to accommodate the temporal variations. Forecasting is based solely on historical data, without additional variables. Each forecast resulting in total of 5 forecasts across all stations.


**Dataset:**
The data were collected daily from January 1, 2013 to December 31, 2021, at 5 Air Quality Monitoring Stations in Jakarta. The source is from website [Satu Data Jakarta](https://satudata.jakarta.go.id/). 

**Missing Value and Imputation**
In the [original data](https://github.com/ina-tantri/CNN-LSTM-Jakarta-Air-Pollution-Forecasting/blob/main/SKPU.csv), there are several dates that have missing values. Therefore, imputation is necessary. The [Kalman Smoothing Imputation](https://github.com/ina-tantri/CNN-LSTM-Jakarta-Air-Pollution-Forecasting/blob/main/Missing%20value%20and%20Imputation%20Kalman.R) method using R was chosen, so that the [final data](https://github.com/ina-tantri/CNN-LSTM-Jakarta-Air-Pollution-Forecasting/blob/main/data_imputed_combined_zero.csv) shows data that has been imputed.

