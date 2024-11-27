#ALY 6080 Module 7 Report Group 1

# Syed # Pravalika #Vraj #Emelia #Shicheng #Christiana

# Analyzing the Gini Coefficient 

gini <- read.csv("gini_in_cma.csv")

print(gini)
str(gini)

library(dplyr)

gini <- 
  gini %>%
  mutate(mean = rowMeans(select(., -Year)))

# Get a numerical data summary table 

# Load necessary package
library(dplyr)

# Add the five-number summary to the dataframe
gini <- gini %>%
  mutate(
    min = apply(select(., -Year), 1, min),
    Q1 = apply(select(., -Year), 1, function(x) quantile(x, 0.25)),
    median = apply(select(., -Year), 1, median),
    Q3 = apply(select(., -Year), 1, function(x) quantile(x, 0.75)),
    max = apply(select(., -Year), 1, max),
    meangini = apply(select(., -Year), 1, mean),
    stddev = apply(select(., -Year), 1, sd)
  )

# Separate the five-number summary as a new dataframe
Numerical_Data_summary <- gini %>%
  select(Year, min, Q1, median, Q3, max, meangini, stddev)

# Remove the five-number summary columns from the original dataframe
gini <- gini %>%
  select(-min, -Q1, -median, -Q3, -max, -meangini, -stddev)

# Display both dataframes
print("Gini Dataframe without Five-Number Summary:")
print(gini)
print("\nFive-Number Summary Dataframe:")
print(Numerical_Data_summary)


# Hypothesis Testing
# Does gini differ between city of Toronto and the other regions

# Load necessary package
library(dplyr)

# Define the regions to compare with 'City_of_Toronto'
regions <- c("Halton_Region", "York_Region", "Peel_Region", "Durham_Region", "Toronto_CMA")

# Loop through each region and perform paired t-tests
for (region in regions) {
  # Perform paired t-test between 'City_of_Toronto' and each region
  t_test_result <- t.test(gini$City_of_Toronto, gini[[region]], paired = TRUE)
  
  # Display the result
  cat("\nPaired t-test between City_of_Toronto and", region, ":\n")
  print(t_test_result)
}

t_test_result_peel_york <- t.test(gini$Peel_Region,gini$York_Region , paired = TRUE)
 cat("\nPaired t-test between Peel and York \n")
 
 # Linear Regression Model 
 
 # Create linear regression models for City of Toronto, York Region, and Peel Region
 lin_reg_toronto <- lm(City_of_Toronto ~ Year, data = gini)
 lin_reg_york <- lm(York_Region ~ Year, data = gini)
 lin_reg_peel <- lm(Peel_Region ~ Year, data = gini)
 
 # Create a data frame for future years up to 2040
 future_years <- data.frame(Year = seq(2020, 2030, by = 2))
 
 # Generate predictions for each model
 pred_toronto <- predict(lin_reg_toronto, newdata = future_years)
 pred_york <- predict(lin_reg_york, newdata = future_years)
 pred_peel <- predict(lin_reg_peel, newdata = future_years)
 
 # Plot Gini Index over time for each region and add regression lines
 plot(gini$Year, gini$City_of_Toronto, type = "p", pch = 16, col = "blue",
      main = "Gini Index Over Time (Observed and Predicted): City of Toronto, York Region, and Peel Region",
      xlab = "Year", ylab = "Gini Index", xlim = c(1970, 2030), ylim = c(0, 0.4))
 
 # Add points for York Region and Peel Region
 points(gini$Year, gini$York_Region, pch = 16, col = "red")
 points(gini$Year, gini$Peel_Region, pch = 16, col = "green")
 
 # Add regression lines for each region
 abline(lin_reg_toronto, col = "blue", lwd = 2)
 abline(lin_reg_york, col = "red", lwd = 2)
 abline(lin_reg_peel, col = "green", lwd = 2)
 
 # Add predicted points and lines for future years
 points(future_years$Year, pred_toronto, pch = 17, col = "blue")
 points(future_years$Year, pred_york, pch = 17, col = "red")
 points(future_years$Year, pred_peel, pch = 17, col = "green")
 
 # Draw dashed lines connecting the last observed data points to the first predicted points
 lines(c(max(gini$Year), future_years$Year[1]), 
       c(gini$City_of_Toronto[nrow(gini)], pred_toronto[1]), 
       col = "blue", lty = 2)
 lines(c(max(gini$Year), future_years$Year[1]), 
       c(gini$York_Region[nrow(gini)], pred_york[1]), 
       col = "red", lty = 2)
 lines(c(max(gini$Year), future_years$Year[1]), 
       c(gini$Peel_Region[nrow(gini)], pred_peel[1]), 
       col = "green", lty = 2)
 
 # Add legend
 legend("topleft", legend = c("City of Toronto (Observed)", "York Region (Observed)", "Peel Region (Observed)",
                              "City of Toronto (Predicted)", "York Region (Predicted)", "Peel Region (Predicted)"),
        col = c("blue", "red", "green", "blue", "red", "green"), pch = c(16, 16, 16, 17, 17, 17), lty = c(1, 1, 1, 2, 2, 2), lwd = 2)
 
install.packages("Metrics") 
library(Metrics) 

# Generate predictions on the observed data for each model
pred_toronto_observed <- predict(lin_reg_toronto, newdata = gini)
pred_york_observed <- predict(lin_reg_york, newdata = gini)
pred_peel_observed <- predict(lin_reg_peel, newdata = gini)

# Calculate RMSE for each model
rmse_toronto <- rmse(gini$City_of_Toronto, pred_toronto_observed)
rmse_york <- rmse(gini$York_Region, pred_york_observed)
rmse_peel <- rmse(gini$Peel_Region, pred_peel_observed)

# Display RMSE results
cat("RMSE for City of Toronto Model:", rmse_toronto, "\n")
cat("RMSE for York Region Model:", rmse_york, "\n")
cat("RMSE for Peel Region Model:", rmse_peel, "\n")

# Define the years for prediction
years <- c(2025, 2030)

# Calculate predictions for each region using the linear regression models

# City of Toronto predictions
pred_toronto <- -8.219671 + 0.004225 * years

# York Region predictions
pred_york <- -3.6247945 + 0.0018904 * years

# Peel Region predictions
pred_peel <- -2.2487397 + 0.0011945 * years

# Display the predictions
predictions <- data.frame(
  Year = years,
  City_of_Toronto = pred_toronto,
  York_Region = pred_york,
  Peel_Region = pred_peel
)

print(predictions)

 

# Decision Tree Model 
# Load necessary packages
library(dplyr)
library(tidyr)
library(rpart)

# Prepare the data by removing the 'Year' column and adding a region label
gini_long <- gini %>%
  pivot_longer(cols = -Year, names_to = "Region", values_to = "Gini_Index")

# Fit a decision tree model
tree_model <- rpart(Region ~ Gini_Index, data = gini_long)

# Plot the decision tree
plot(tree_model, margin = 0.1)
text(tree_model, use.n = TRUE, cex = 0.8)


# Living Wage vs minimum wage

living_wage_data <- read.csv("living_wage_data.csv")

print(living_wage_data)


# Load necessary libraries
library(dplyr)
library(tidyr)
library(randomForest)
library(caret)

# Prepare the data by reshaping it to long format for modeling
living_wage_long <- living_wage_data %>%
  pivot_longer(cols = starts_with("Living_Wage"), names_to = "Year", values_to = "Living_Wage") %>%
  pivot_longer(cols = starts_with("Minimum_Wage"), names_to = "Min_Wage_Year", values_to = "Minimum_Wage") %>%
  mutate(Year = as.numeric(sub("Living_Wage_", "", Year)))

# Select unique rows to avoid redundancy from pivoting
living_wage_long <- living_wage_long %>%
  select(Region, Year, Living_Wage, Minimum_Wage) %>%
  unique()

# View the prepared data
print(living_wage_long)

# Split the data into training and testing sets
set.seed(123)  # For reproducibility
train_index <- createDataPartition(living_wage_long$Living_Wage, p = 0.8, list = FALSE)
train_data <- living_wage_long[train_index, ]
test_data <- living_wage_long[-train_index, ]

# 1. Linear Regression Model
lm_model <- lm(Living_Wage ~ Year + Minimum_Wage + Region, data = train_data)
lm_predictions <- predict(lm_model, newdata = test_data)


summary(lm_model)

# Evaluate Linear Regression Model
lm_rmse <- sqrt(mean((lm_predictions - test_data$Living_Wage)^2))
cat("Linear Regression RMSE:", lm_rmse, "\n")

# 2. Random Forest Model
rf_model <- randomForest(Living_Wage ~ Year + Minimum_Wage + Region, data = train_data, ntree = 100, importance = TRUE)
rf_predictions <- predict(rf_model, newdata = test_data)

# Evaluate Random Forest Model
rf_rmse <- sqrt(mean((rf_predictions - test_data$Living_Wage)^2))
cat("Random Forest RMSE:", rf_rmse, "\n")

# Display importance of each predictor in the random forest model
summary(rf_model)
print(importance(rf_model))

# Predicting Living Wage for Future Years (2023, 2024)
future_years <- data.frame(
  Region = rep(c("Toronto", "Peel Region", "Durham", "Halton", "York"), each = 2),
  Year = rep(c(2025, 2030), times = 5),
  Minimum_Wage = rep(15.50, 10)  # Assume a minimum wage of 15.50 as a placeholder
)

# Using Random Forest to predict future living wages
future_predictions <- predict(rf_model, newdata = future_years)
future_years$Predicted_Living_Wagerf <- future_predictions

# Display future predictions
print(future_years)

# Using Random Forest to predict future living wages
future_predictions <- predict(lm_model, newdata = future_years)
future_years$Predicted_Living_Wagelm <- future_predictions

# Display future predictions
print(future_years)



#plot comparing predictions from the two models 

# Load necessary library
library(ggplot2)


# Convert `Region` to a factor for proper grouping in ggplot
future_years$Region <- as.factor(future_years$Region)

# Create the plot
ggplot(future_years, aes(x = Year, group = Region)) +
  # Plot random forest predictions
  geom_line(aes(y = Predicted_Living_Wagerf, color = Region, linetype = "Random Forest"), size = 1) +
  # Plot linear regression predictions
  geom_line(aes(y = Predicted_Living_Wagelm, color = Region, linetype = "Linear Regression"), size = 1) +
  # Add points for each prediction
  geom_point(aes(y = Predicted_Living_Wagerf, color = Region, shape = "Random Forest"), size = 3) +
  geom_point(aes(y = Predicted_Living_Wagelm, color = Region, shape = "Linear Regression"), size = 3) +
  # Labels and theme adjustments
  labs(
    title = "Future Living Wage Predictions in Toronto GTA for 2025 to 2030",
    x = "Year",
    y = "Predicted Living Wage",
    color = "Region",
    linetype = "Model",
    shape = "Model"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")


# Low Income prediction for Toronot CMA 
# A model that takes social mobility into consideration

linc_tor <- read.csv("IncDist_CityToronto.csv")
linc_dur <- read.csv("IncDist_Durham.csv")
linc_hal <- read.csv("IncDist_Halton.csv")
linc_peel <- read.csv("IncDist_Peel.csv")
linc_york <- read.csv("IncDist_York.csv")

names(linc_tor)

linc_tor <- linc_tor %>% 
  rename(LowIncome = Low_VeryLow_Income)
linc_dur <- linc_dur %>% 
  rename(LowIncome = Low_VeryLow_Income)
linc_hal <- linc_hal %>% 
  rename(LowIncome = Low_VeryLow_Income)
linc_peel <- linc_peel %>% 
  rename(LowIncome = Low_VeryLow_Income)
linc_york <- linc_york %>% 
  rename(LowIncome = Low_VeryLow_Income)

names(linc_tor)
names(linc_dur)
names(linc_hal)
names(linc_peel)
names(linc_york)

#  linc_tor, linc_dur, linc_hal, linc_peel, and linc_york data frames have'Year', 'LowIncome', 'Middle_Income', 'High_VeryHigh_Income' columns
# Defining future years for prediction and include estimated values for Middle_Income and High_VeryHigh_Income

# Use the last observed values as placeholders for Middle_Income and High_VeryHigh_Income for each region
last_middle_income_tor <- tail(linc_tor$Middle_Income, 1)
last_high_income_tor <- tail(linc_tor$High_VeryHigh_Income, 1)

# Repeat for other regions
last_middle_income_dur <- tail(linc_dur$Middle_Income, 1)
last_high_income_dur <- tail(linc_dur$High_VeryHigh_Income, 1)

last_middle_income_hal <- tail(linc_hal$Middle_Income, 1)
last_high_income_hal <- tail(linc_hal$High_VeryHigh_Income, 1)

last_middle_income_peel <- tail(linc_peel$Middle_Income, 1)
last_high_income_peel <- tail(linc_peel$High_VeryHigh_Income, 1)

last_middle_income_york <- tail(linc_york$Middle_Income, 1)
last_high_income_york <- tail(linc_york$High_VeryHigh_Income, 1)

# Create future data frames with these values

# 1. Toronto
future_years_tor <- data.frame(
  Year = c(2025,2027, 2030),
  Middle_Income = rep(last_middle_income_tor, 3),
  High_VeryHigh_Income = rep(last_high_income_tor, 3)
)
lm_linc_tor <- lm(LowIncome ~ Year + Middle_Income + High_VeryHigh_Income, data = linc_tor)
pred_tor <- predict(lm_linc_tor, newdata = future_years_tor)
future_tor <- data.frame(Region = "Toronto", Year = future_years_tor$Year, Predicted_LowIncome = pred_tor)

# 2. Durham
future_years_dur <- data.frame(
  Year = c(2025,2027, 2030),
  Middle_Income = rep(last_middle_income_dur, 3),
  High_VeryHigh_Income = rep(last_high_income_dur, 3)
)
lm_linc_dur <- lm(LowIncome ~ Year + Middle_Income + High_VeryHigh_Income, data = linc_dur)
pred_dur <- predict(lm_linc_dur, newdata = future_years_dur)
future_dur <- data.frame(Region = "Durham", Year = future_years_dur$Year, Predicted_LowIncome = pred_dur)

# 3. Halton
future_years_hal <- data.frame(
  Year = c(2025,2027, 2030),
  Middle_Income = rep(last_middle_income_hal, 3),
  High_VeryHigh_Income = rep(last_high_income_hal, 3)
)
lm_linc_hal <- lm(LowIncome ~ Year + Middle_Income + High_VeryHigh_Income, data = linc_hal)
pred_hal <- predict(lm_linc_hal, newdata = future_years_hal)
future_hal <- data.frame(Region = "Halton", Year = future_years_hal$Year, Predicted_LowIncome = pred_hal)

# 4. Peel
future_years_peel <- data.frame(
  Year = c(2025,2027, 2030),
  Middle_Income = rep(last_middle_income_peel, 3),
  High_VeryHigh_Income = rep(last_high_income_peel, 3)
)
lm_linc_peel <- lm(LowIncome ~ Year + Middle_Income + High_VeryHigh_Income, data = linc_peel)
pred_peel <- predict(lm_linc_peel, newdata = future_years_peel)
future_peel <- data.frame(Region = "Peel Region", Year = future_years_peel$Year, Predicted_LowIncome = pred_peel)

# 5. York
future_years_york <- data.frame(
  Year = c(2025,2027, 2030),
  Middle_Income = rep(last_middle_income_york, 3),
  High_VeryHigh_Income = rep(last_high_income_york, 3)
)
lm_linc_york <- lm(LowIncome ~ Year + Middle_Income + High_VeryHigh_Income, data = linc_york)
pred_york <- predict(lm_linc_york, newdata = future_years_york)
future_york <- data.frame(Region = "York", Year = future_years_york$Year, Predicted_LowIncome = pred_york)

# Combine all future predictions
future_predictions <- rbind(future_tor, future_dur, future_hal, future_peel, future_york)

# Plotting
library(ggplot2)

ggplot(future_predictions, aes(x = Year, y = Predicted_LowIncome, color = Region, group = Region)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  labs(
    title = "Future Predictions of Low Income Levels by Region with social mobility trends considered",
    x = "Year",
    y = "Predicted Low Income",
    color = "Region"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

#RMSE of the Model
# Load necessary libraries
library(Metrics)

# Define a function to calculate RMSE for each model and data
calculate_rmse <- function(model, data) {
  # Predict on the original data
  predictions <- predict(model, newdata = data)
  # Calculate RMSE between actual and predicted values
  rmse_value <- rmse(data$LowIncome, predictions)
  return(rmse_value)
}

# Calculate RMSE for each region and store in a data frame
rmse_values_mobility <- data.frame(
  Region = c("Toronto", "Durham", "Halton", "Peel Region", "York"),
  RMSEwithSocialMobilityConsidered = c(
    calculate_rmse(lm_linc_tor, linc_tor),
    calculate_rmse(lm_linc_dur, linc_dur),
    calculate_rmse(lm_linc_hal, linc_hal),
    calculate_rmse(lm_linc_peel, linc_peel),
    calculate_rmse(lm_linc_york, linc_york)
  )
)

# Display the RMSE dataframe
print(rmse_values_mobility)


# A model without taking social mobility into consideration

# Load necessary library
library(ggplot2)

# Define future years for prediction
future_years <- data.frame(Year = c(2025,2027, 2030))

# Fit linear regression models and predict for future years for each region
# Toronto
lm_linc_tor <- lm(LowIncome ~ Year, data = linc_tor)
pred_tor <- predict(lm_linc_tor, newdata = future_years)
future_tor <- data.frame(Region = "Toronto", Year = future_years$Year, Predicted_LowIncome = pred_tor)

# Durham
lm_linc_dur <- lm(LowIncome ~ Year, data = linc_dur)
pred_dur <- predict(lm_linc_dur, newdata = future_years)
future_dur <- data.frame(Region = "Durham", Year = future_years$Year, Predicted_LowIncome = pred_dur)

# Halton
lm_linc_hal <- lm(LowIncome ~ Year, data = linc_hal)
pred_hal <- predict(lm_linc_hal, newdata = future_years)
future_hal <- data.frame(Region = "Halton", Year = future_years$Year, Predicted_LowIncome = pred_hal)

# Peel
lm_linc_peel <- lm(LowIncome ~ Year, data = linc_peel)
pred_peel <- predict(lm_linc_peel, newdata = future_years)
future_peel <- data.frame(Region = "Peel Region", Year = future_years$Year, Predicted_LowIncome = pred_peel)

# York
lm_linc_york <- lm(LowIncome ~ Year, data = linc_york)
pred_york <- predict(lm_linc_york, newdata = future_years)
future_york <- data.frame(Region = "York", Year = future_years$Year, Predicted_LowIncome = pred_york)

# Combine all future predictions
future_predictions <- rbind(future_tor, future_dur, future_hal, future_peel, future_york)

# Plotting
ggplot(future_predictions, aes(x = Year, y = Predicted_LowIncome, color = Region, group = Region)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  labs(
    title = "Future Predictions of Low Income Levels by Region without social mobility",
    x = "Year",
    y = "Predicted Low Income",
    color = "Region"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# RMSE for both models

# Load necessary library
library(Metrics)

# Define a function to calculate RMSE for a given model and data
calculate_rmse <- function(model, data) {
  # Predict on the original data
  predictions <- predict(model, newdata = data)
  # Calculate RMSE between actual and predicted values
  rmse <- rmse(data$LowIncome, predictions)
  return(rmse)
}

# Calculate RMSE for each region and store results in a list
rmse_values <- data.frame(
  Region = c("Toronto", "Durham", "Halton", "Peel Region", "York"),
  RMSEwithoutSocialMobility = c(
    calculate_rmse(lm_linc_tor, linc_tor),
    calculate_rmse(lm_linc_dur, linc_dur),
    calculate_rmse(lm_linc_hal, linc_hal),
    calculate_rmse(lm_linc_peel, linc_peel),
    calculate_rmse(lm_linc_york, linc_york)
  )
)

# Display the RMSE dataframe
print(rmse_values)

# RMSE with Social Mobility and without bound

RMSE_Compared <- cbind(rmse_values, rmse_values_mobility)

RMSE_Compared <- RMSE_Compared[, -3]

RMSE_Compared

# Unemployment

peel_un <- read.csv("Unemployment_Peel.csv")

str(peel_un)

names(peel_un)


# Linear Regression Model for Prediction
# Load necessary libraries
library(ggplot2)
library(reshape2)



# Convert Quarter to numeric Year format for modeling
peel_un$Year <- as.numeric(sub("Q\\d ", "", peel_un$Quarter))

# Define regions and future years
regions <- c("Halton", "Mississauga", "Brampton", "Toronto_CMA")
future_years <- data.frame(Year = c(2025,2027, 2030))

# Initialize a data frame to store predictions
future_predictions <- data.frame()

# Loop through each region, fit a linear model, and predict future values
for (region in regions) {
  # Fit a linear regression model
  lm_model <- lm(get(region) ~ Year, data = peel_un)
  
  # Predict for future years
  predictions <- predict(lm_model, newdata = future_years)
  
  # Set any negative predictions to 0 to ensure realistic unemployment rates
  predictions <- pmax(predictions, 0)
  
  # Store predictions in a combined data frame
  future_predictions <- rbind(
    future_predictions,
    data.frame(Region = region, Year = future_years$Year, Predicted = predictions)
  )
}

# Melt the original data for plotting
peel_un_long <- melt(peel_un, id.vars = "Year", measure.vars = regions, variable.name = "Region", value.name = "Observed")

# Plot observed and predicted values
ggplot() +
  geom_line(data = peel_un_long, aes(x = Year, y = Observed, color = Region, group = Region)) +
  geom_point(data = peel_un_long, aes(x = Year, y = Observed, color = Region), size = 2) +
  geom_line(data = future_predictions, aes(x = Year, y = Predicted, color = Region, group = Region), linetype = "dashed") +
  geom_point(data = future_predictions, aes(x = Year, y = Predicted, color = Region), shape = 17, size = 3) +
  labs(
    title = "Observed and Predicted Unemployment Rates by Peel Region and Toronto CMA",
    x = "Year",
    y = "Unemployment Rate (%)",
    color = "Region"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# Calculate the RMSE Values 
# Load necessary library for RMSE calculation
library(Metrics)

# Initialize a data frame to store RMSE values
rmse_values <- data.frame(Region = character(), RMSE = numeric(), stringsAsFactors = FALSE)

# Loop through each region, calculate RMSE, and store it in the data frame
for (region in regions) {
  # Fit the linear model
  lm_model <- lm(get(region) ~ Year, data = peel_un)
  
  # Predict on the original years in peel_un
  predictions <- predict(lm_model, newdata = peel_un)
  
  # Calculate RMSE using the original data
  actual_values <- peel_un[[region]]
  rmse_value <- rmse(actual_values, predictions)
  
  # Append RMSE to the data frame
  rmse_values <- rbind(rmse_values, data.frame(Region = region, RMSE = rmse_value, stringsAsFactors = FALSE))
}

# Display the RMSE values
print(rmse_values)

# York Unemployment Prediction

york_un <- read.csv("Unemployment_York.csv")

str(york_un)

names(york_un)

york_un

# Load necessary libraries
library(ggplot2)
library(Metrics)
library(reshape2)

# Convert Month_Year to Date format
york_un$Date <- as.Date(paste("01", york_un$Month_Year), format = "%d %b %Y")
york_un$Time <- as.numeric(york_un$Date)

# Define regions and future dates, now including 2040 and 2050
regions <- c("York_Region", "Toronto_CMA", "Ontario")
future_dates <- data.frame(
  Date = as.Date(c("2023-01-01", "2024-01-01", "2025-01-01", "2027-01-01", "2030-01-01")),
  Time = as.numeric(as.Date(c("2023-01-01", "2024-01-01", "2025-01-01", "2027-01-01", "2030-01-01")))
)

# Initialize data frame to store predictions and RMSE values
future_predictions <- data.frame()
rmse_values <- data.frame(Region = character(), RMSE = numeric())

# Loop through each region, fit a model, predict, and calculate RMSE
for (region in regions) {
  # Fit linear model
  lm_model <- lm(get(region) ~ Time, data = york_un)
  
  # Predict for future dates and apply a zero floor constraint
  predictions <- predict(lm_model, newdata = future_dates)
  predictions <- pmax(predictions, 0)  # Set any negative predictions to zero
  
  # Calculate RMSE on the original data
  actual_values <- york_un[[region]]
  predictions_actual <- predict(lm_model, newdata = york_un)
  rmse_value <- rmse(actual_values, predictions_actual)
  
  # Store RMSE in the dataframe
  rmse_values <- rbind(rmse_values, data.frame(Region = region, RMSE = rmse_value))
  
  # Store predictions in combined dataframe
  future_predictions <- rbind(
    future_predictions,
    data.frame(Region = region, Date = future_dates$Date, Predicted = predictions)
  )
}

# Melt original data for plotting
york_un_long <- melt(york_un, id.vars = "Date", measure.vars = regions, variable.name = "Region", value.name = "Observed")

# Plot observed and predicted values
ggplot() +
  geom_line(data = york_un_long, aes(x = Date, y = Observed, color = Region, group = Region)) +
  geom_point(data = york_un_long, aes(x = Date, y = Observed, color = Region), size = 2) +
  geom_line(data = future_predictions, aes(x = Date, y = Predicted, color = Region, group = Region), linetype = "dashed") +
  geom_point(data = future_predictions, aes(x = Date, y = Predicted, color = Region), shape = 17, size = 3) +
  labs(
    title = "Observed and Predicted Unemployment Rates for York Region, Toronto CMA, and Ontario",
    x = "Date",
    y = "Unemployment Rate (%)",
    color = "Region"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# Display RMSE values
print(rmse_values)

#Eviction Predictions

evic <- read.csv("evic_apps.csv")

print(evic)

# Load necessary libraries
library(ggplot2)
library(Metrics)


# Fit a linear regression model
lm_model <- lm(Eviction_Applications ~ Year, data = evic)

# Predict evictions for the years 2030, 2040, and 2050
future_years <- data.frame(Year = c(2025,2027, 2030))
future_predictions <- predict(lm_model, newdata = future_years)

# Ensure predictions are non-negative
future_predictions <- pmax(future_predictions, 0)

# Combine future predictions with the future years and add labels
future_data <- data.frame(
  Year = future_years$Year,
  Predicted_Evictions = future_predictions,
  Label = round(future_predictions, 2)  # Label for each point
)

# Calculate RMSE on the original data
predicted_values <- predict(lm_model, newdata = evic)
actual_values <- evic$Eviction_Applications
rmse_value <- rmse(actual_values, predicted_values)

# Display RMSE
cat("RMSE:", rmse_value, "\n")

# Plot observed data and future predictions
ggplot(data = evic, aes(x = Year, y = Eviction_Applications)) +
  geom_point(color = "blue") +
  geom_line(color = "blue") +
  geom_line(data = future_data, aes(x = Year, y = Predicted_Evictions), color = "red", linetype = "dashed") +
  geom_point(data = future_data, aes(x = Year, y = Predicted_Evictions), color = "red", shape = 17, size = 3) +
  geom_text(data = future_data, aes(x = Year, y = Predicted_Evictions, label = Label), vjust = -0.5, color = "red") +
  labs(
    title = "Observed and Predicted Eviction Applications",
    x = "Year                         (RMSE: 1517.796) ",
    y = "Eviction Applications"
    
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")


# Housing starts Prediction

hs <- read.csv("hs_starts.csv")


print(hs)

nrow(hs)
ncol(hs)
names(hs)
str(hs) # Shows character columns having commas

sum(is.na(hs))



# Define columns to convert
cols_to_convert <- c("Single", "Semi.Detached", "Row", "Apartment", "All")

# Apply function to remove commas and convert to numeric for specified columns
hs[cols_to_convert] <- lapply(hs[cols_to_convert], function(x) as.numeric(gsub(",", "", x)))

# Check the structure to confirm the conversion
str(hs)

# Fit the linear model
lmhs <- lm(All ~ Year + Single + Semi.Detached + Row, data = hs)

# Display model summary
summary(lmhs)

# Predict values based on the model
predicted_hs <- predict(lmhs, hs)

# Print predicted values
print(predicted_hs)

# Calculate RMSE (Corrected)
RMSE_hs <- sqrt(mean((predicted_hs - hs$All)^2))
print(RMSE_hs)

# Load necessary library
library(ggplot2)

# Calculate the mean values for Single, Semi.Detached, and Row
mean_single <- mean(hs$Single, na.rm = TRUE)
mean_semi_detached <- mean(hs$Semi.Detached, na.rm = TRUE)
mean_row <- mean(hs$Row, na.rm = TRUE)

# Create a new data frame for future predictions
future_years <- data.frame(
  Year = c(2025,2027, 2030),
  Single = rep(mean_single, 3),
  Semi.Detached = rep(mean_semi_detached, 3),
  Row = rep(mean_row, 3)
)

# Use the model to predict 'All' for future years
predicted_future_all <- predict(lmhs, newdata = future_years)

# Combine predictions with the future years data and add labels
future_data <- data.frame(
  Year = future_years$Year,
  All = predicted_future_all,
  Label = round(predicted_future_all, 2)  # Rounded label for each point
)

# Plot observed data and future predictions with labels
ggplot(data = hs, aes(x = Year, y = All)) +
  geom_point(color = "blue") +
  geom_line(color = "blue") +
  geom_point(data = future_data, aes(x = Year, y = All), color = "red", shape = 17, size = 3) +
  geom_line(data = future_data, aes(x = Year, y = All), color = "red", linetype = "dashed") +
  geom_text(data = future_data, aes(x = Year, y = All, label = Label), vjust = -0.5, color = "red") +
  labs(
    title = "Observed and Predicted Values of 'All' Housing Starts Over Time in Toronto CMA",
    x = "Year",
    y = "Housing Starts (All)"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# End of Code

