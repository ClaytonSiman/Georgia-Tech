library(Hmisc)
library(caret)
library(tidyverse)
library(glmnet)

# Set seed for reproducibility
set.seed(31)

# Read temperature data into a dataframe
df <- read.table("//Users/c.siman/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 10 Advanced Regression/Homework 7/uscrime.txt", header = TRUE)

describe(df)

# Stepwise Regression
# stepwise_model <- lm(Crime~., data=df)
# stepwise_model <- step(stepwise_model, direction = "both")

ctrl <- trainControl(method="LOOCV")
stepwise_model <- train(Crime~., data=df, method="lmStepAIC", trControl=ctrl)

stepwise_model$results
summary(stepwise_model)

stepwise_sig_var_model <- train(Crime ~ M + Ed + Po1 + U2 + Ineq + Prob, data=df, method="lmStepAIC", trControl=ctrl)

stepwise_sig_var_model$results

# LASSO
# df_len <- dim(df)[1]
# test_sample <- sample(1:df_len, size=round(0.2*df_len), replace=FALSE)
# train_set <- df[-test_sample,]
# test_set <- df[test_sample,]

# x_train <- scale(as.matrix(train_set)[,-16], center = TRUE, scale = TRUE)
# y_train <- scale(as.matrix(train_set)[,16], center = TRUE, scale = TRUE)
# x_test <- scale(as.matrix(test_set)[,-16], center = TRUE, scale = TRUE)
# y_test <- scale(as.matrix(test_set)[,16], center = TRUE, scale = TRUE)

x <- scale(as.matrix(df)[,-16], center = TRUE, scale = TRUE)
y <- scale(as.matrix(df)[,16], center = TRUE, scale = TRUE)

lasso_model <- cv.glmnet(x, y, family="gaussian", alpha=1)
best_lambda <- lasso_model$lambda.min
best_lambda
lasso_model <- glmnet(x, y, family="gaussian", alpha=1, lambda=best_lambda)

coef(lasso_model)

pred <- predict(lasso_model, x)
SSE <- sum((pred - y)^2)
SST <- sum((y - mean(y))^2)
R2 <- 1 - SSE / SST
RMSE = sqrt(SSE/nrow(df))
  
# Elastic Net
models <- list()
results <- data.frame()

set.seed(31)

for (i in 0:20) {
  name <- paste0("alpha: ", i/20)
  
  models[[name]] <- cv.glmnet(x, y, family="gaussian", alpha=i/20)
  best_lambda <- models[[name]]$lambda.min
  models[[name]] <- glmnet(x, y, family="gaussian", alpha=i/20, lambda=best_lambda)
  
  ## Use each model to predict 'y' given the Testing dataset
  pred <- predict(models[[name]], x)
  
  ## Calculate the Mean Squared Error...
  SSE <- sum((pred - y)^2)
  SST <- sum((y - mean(y))^2)
  R2 <- 1 - SSE / SST
  RMSE = sqrt(SSE/nrow(df))
  
  ## Store the results
  temp <- data.frame(alpha=i/20, lambda=best_lambda, RMSE=RMSE, R2=R2)
  results <- rbind(results, temp)
}

results
best_results <- results[which.min(results$RMSE),]
results[which.max(results$R2),]

elastic_net_model <- glmnet(x, y, family="gaussian", alpha=best_results$alpha, lambda=best_results$lambda)
coef(elastic_net_model)
