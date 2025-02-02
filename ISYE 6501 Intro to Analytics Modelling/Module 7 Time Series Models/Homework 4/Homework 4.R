library(qcc)

# Set seed for reproducibility
set.seed(31)

# Read temperature data into a dataframe
df <- read.table("C:/Users/Clayton/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 7 Time Series Models/Homework 4/temps.txt", header = TRUE)

# Convert dataframe into a vector and then to a time-series object for the HoltWinters model
df_vector <- as.vector(unlist(df[, 2:21]))
df_length <- length(df[, 1])
temp_ts <- ts(df_vector, start=1996, frequency=df_length)

# Plot the time-series data for visualisation
plot(temp_ts)

# To analyse whether the unofficial end of summer has gotten later over the years, we are generally interested in 2 factors: the beta (or trend) estimate and the gamma (or seasonality) estimate
# Therefore, we will be using the Triple Exponential Smoothing approach to determine the trend and seasonality estimates
# For the Seasonality estimate, we will use the 'Additive' approach as we will generally expect temperature differences between summer and fall for each year to be roughly consistent

# Triple exponential smoothing (additive seasonality)
es_triple_additive_model <- HoltWinters(temp_ts, seasonal='additive')
es_triple_additive_model
es_triple_additive_model$coefficients[2]

# Here we see that beta (or trend) is 0, which means that across the past 20 years, the trend of temperatures from July to October has remained flat.
# However, this is not sufficient to conclude that the unofficial end of summer over the past 20 years has remained the same.
# For this, we will need to observe the seasonality factors to determine whether unofficial end of summer has gotten later.

# The intuition here is that if unofficial end of summer has gotten later, we will expect the average annual seasonality factor to increase over the years, since we expect more days of summer between July and October in the later years
# We will use the CUSUM approach on the average annual seasonality factor to determine whether the annual seasonality factor has consistently increased above 5 standard errors in the later years

# Extract the seasonality factors from the Triple Exponential Smoothing model to a matrix
season_matrix <- matrix(es_triple_additive_model$fitted[,4], ncol=123)

# Get the average annual seasonality factors for all years
avg_seasonality <- data.frame(rowMeans(season_matrix, n=19))

# Get the mean annual seasonality factor for all years for CUSUM center (C)
temp.mean <- mean(avg_seasonality[, 1])

# For the CUSUM method, we will use the mean annual seasonality factor as the center (C) and the threshold (T) to be a standard 5x of the standard error
temp_cusum <- cusum(avg_seasonality, center=temp.mean, decision.interval=5)

# From the CUSUM chart, we see that the average annual seasonality factor for most of the remaining 19 years has remained within 5 standard errors.
# The only exception is in the year 2010, when the seasonality factor increased above 5 standard errors; however, from the chart, this is a one-off observation and the seasonality factor subsequently reverted to the mean afterwards.
# Therefore, we can conclude that the seasonality factors across the years have largely remained the same and unofficial end of summer has not gotten later in the past 20 years.


