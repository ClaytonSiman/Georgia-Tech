library(caret)
library(Hmisc)
library(stats)
library(ggplot2)

# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:/Users/Clayton/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 6 Change Detection/Homework 3/uscrime.txt", header = TRUE)

describe(df)

df_x <- df[1:15]

# PCA 
pca_result <- prcomp(df_x, scale.=TRUE)

summary(pca_result)

# Analysing variance of each component
scree_data <- data.frame(
  Component = 1:length(pca_result$sdev),
  Variance = pca_result$sdev^2 / sum(pca_result$sdev^2)
)

ggplot(scree_data, aes(x = Component, y = Variance)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_line() +
  geom_point() +
  xlab("Principal Components") +
  ylab("Proportion of Variance Explained") +
  ggtitle("Scree Plot")

# Combine top 5 PCA components with dependent variable
pca_df <- merge(pca_result$x[, 1:5], df[16], by='row.names', all.x=TRUE)
pca_df <- pca_df[2:length(pca_df)]

#specify the cross-validation method
ctrl <- trainControl(method="LOOCV")

#fit a regression model and use LOOCV to evaluate performance
model <- train(Crime ~ ., data=pca_df, method="lm", trControl=ctrl)
model$results
summary(model)

# Get model equation based on original variables
rotation <- pca_result$rotation[, 1:5]
beta <- model$finalModel$coefficients[2:6] 
alpha <- rotation %*% beta

mu <- sapply(df_x, mean)
sigma <- sapply(df_x, sd)

orig_coeff <- alpha / sigma
orig_intercept <- model$finalModel$coefficients[1] - sum(alpha*mu / sigma)

# Prediction on new data point
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

# Derive Crime from the sum of intercept & coefficients * test data
orig_intercept + sum(orig_coeff * test_data) 

# PCA transformation on the test data
pca_test_data <- data.frame(predict(pca_result, test_data)) 
predict(model, pca_test_data[, 1:5])


