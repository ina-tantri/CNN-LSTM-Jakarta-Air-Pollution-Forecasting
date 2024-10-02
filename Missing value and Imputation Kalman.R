setwd("C:/Users/Microsoft User/OneDrive - Institut Teknologi Sepuluh Nopember/TA/Data")
skpu <- read.csv("SKPU.csv")
head(skpu, n=35)

#Missing Value Checking
# Choose the data without 2011 and 2012 cause some stations haven't started their observations at those years
skpu <- subset(skpu, !(substr(tanggal, 7, 10) %in% c("2011", "2012")))

# Change missing value '---' menjadi NA
skpu[skpu == '---'] <- NA

# Function to count missing value NA in each column
num_missing <- function(x) sum(is.na(x))

# Function to count the zero value in each column
num_zero <- function(x) sum(x == 0, na.rm = TRUE)

# Function to count the total missing value
num_total_missing <- function(x) sum(is.na(x)) + sum(x == 0, na.rm = TRUE)

# Function to count the proportion of missing value in each column
prop_missing <- function(x) sum(is.na(x)) / length(x) * 100
prop_zero <- function(x) sum(x == 0, na.rm = TRUE) / length(x) * 100
prop_total_missing <- function(x) (sum(is.na(x)) + sum(x == 0, na.rm = TRUE)) / length(x) * 100

# Apply sum and proportion functions to each column (parameter) at each station
num_missing_values <- apply(skpu[, 3:8], 2, function(x) tapply(x, skpu$stasiun, num_missing)) 
num_zero_values <- apply(skpu[, 3:8], 2, function(x) tapply(x, skpu$stasiun, num_zero))
num_total_missing_values <- apply(skpu[, 3:8], 2, function(x) tapply(x, skpu$stasiun, num_total_missing))

missing_values <- apply(skpu[, 3:8], 2, function(x) tapply(x, skpu$stasiun, prop_missing))
zero_values <- apply(skpu[, 3:8], 2, function(x) tapply(x, skpu$stasiun, prop_zero))
total_missing_values <- apply(skpu[, 3:8], 2, function(x) tapply(x, skpu$stasiun, prop_total_missing))


# Combine result
results <- list(
  num_missing_values = num_missing_values,
  num_zero_values = num_zero_values,
  num_total_missing_values = num_total_missing_values,
  missing_values = missing_values,
  zero_values = zero_values,
  total_missing_values = total_missing_values
)
print(results)

# Descriptive Statistics
skpu[, 3:8] <- sapply(skpu[, 3:8], as.numeric)
desc_stats <- list()

# Loop through each station
for (station in unique(skpu$stasiun)) {
  # Loop through each pollutat
  for (param in names(skpu)[3:8]) {
    # Data subset for specific stations and pollutant
    subset_data <- skpu[skpu$stasiun == station, param]
    
    # Descriptive Statistics
    desc_stats[[paste(station, param, sep="_")]] <- summary(subset_data)
  }
}
print(desc_stats)

# MISSING VALUE IMPUTATION  ===============================================================================
#We are using Kalman imputation

# Change 0 into NA
skpu[skpu == 0] <- NA
skpu_KF <- subset(skpu, select = -c(max, critical, categori))
head(skpu_KF)

#install.packages("imputeTS")
library(imputeTS)

# List of parameters
parameters <- c("so2", "no2", "co", "o3", "pm10")

# Loop through each parameter
for (param in parameters) {
  # Initialize dataframe for imputed values
  param_imputed <- data.frame(tanggal = skpu$tanggal, stasiun = skpu_KF$stasiun, value = skpu[[param]])
  
  # Convert value to numeric
  param_imputed$value <- as.numeric(param_imputed$value)
  
  # Impute NA values
  param_imputed$value <- na_kalman(param_imputed$value, model = 'StructTS', smooth = TRUE, maxgap = Inf)
  
  # Replace NA values with the imputed values
  skpu_KF[[param]][is.na(skpu_KF[[param]])] <- param_imputed$value[is.na(skpu_KF[[param]])]
  
  # Replace 0 values with the imputed values
  skpu_KF[[param]][skpu_KF[[param]] == 0] <- param_imputed$value[skpu_KF[[param]] == 0]
}

# Show the first few rows of the updated data
head(skpu_KF, n=20)

# Change the zero values with new imputation data
for (param in parameters) {
  skpu_KF[[param]][skpu_KF[[param]] == 0] <- param_imputed$value[skpu_KF[[param]] == 0]
}

# Save file to csv
file_path <- paste(getwd(), "data_imputed_combined_zero.csv", sep="/")
write.csv(skpu_KF, file_path, row.names = FALSE)

