library(caret)
library(boot)
library(Hmisc)

# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:/Users/Clayton/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 6 Change Detection/Homework 3/uscrime.txt", header = TRUE)

describe(df)

df_scaled_features <- scale(df[1:(length(df)-1)])
df_scaled <- merge(df_scaled_features, df[length(df)], by='row.names', all.x=TRUE)
df_scaled <- df_scaled[2:length(df_scaled)]

#specify the cross-validation method
ctrl <- trainControl(method="LOOCV")

#fit a regression model and use LOOCV to evaluate performance
model <- train(Crime ~ ., data=df_scaled, method="lm", trControl=ctrl)
model$results$RMSE

summary(model)

test_data = data.frame(
  M = 14.0,
  So = 0,
  Ed = 10.0,
  Po1 = 12.0,
  Po2 = 15.5,
  LF = 0.640,
  M.F = 94.0,
  Pop = 150,
  NW = 1.1,
  U1 = 0.120,
  U2 = 3.6,
  Wealth = 3200,
  Ineq = 20.1,
  Prob = 0.04,
  Time = 39.0
)

test_scaled <- scale(test_data, center=attr(df_scaled_features, "scaled:center"), scale=attr(df_scaled_features, "scaled:scale"))
predict(model, newdata=test_scaled)

# Filtered columns
model <- train(Crime ~ M + Ed + Po1 + U2 + Ineq + Prob, data=df_scaled, method="lm", trControl=ctrl)
model$results$RMSE

summary(model)

predict(model, newdata=test_scaled)

