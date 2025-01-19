# Installing & importing packages
library(kernlab)

# Read credit card data into df
directory <- "C:/Users/Clayton/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 2 Classification/"
df <- read.table(paste0(directory, "credit_card_data-headers.txt"), header = T, sep = "\t")

# Q3.1a
# Importing packages
library(caret)
library(kknn)

# seed for reproducible results
set.seed(31)

# create train-test split (80-20)
set.seed(31) 
df_len <- dim(df)[1]
test_sample <- sample(1:df_len, size=round(0.2*df_len), replace=FALSE)
train_set <- df[-test_sample,]
test_set <- df[test_sample,]

# KNN model
# define training control for cross validation
train_control <- trainControl(method = "cv", number = 10)

# define Hyperparameter Grid
tune_grid <- expand.grid(distance=c(1:5), kmax=20, kernel="optimal")

# train the kknn classification model with cross validation
model <- train(as.factor(R1)~., data=train_set, trControl=train_control, tuneGrid=tune_grid, method="kknn")
model

# train the kknn model with the best parameters from cv
kknn_training_model <- train.kknn(as.factor(R1)~., data=train_set, scale=T, kmax=20, distance=1, kernel='optimal')
kknn_training_model

# using the best parameters from the training step, build the kknn model
kknn_model <- kknn(as.factor(R1)~., train=train_set, test=test_set, scale=T, k=19, distance=1, kernel='optimal')

# fit the model and observe the model performance
kknn_fit <- fitted(kknn_model)
confusionMatrix(data=kknn_fit, reference=as.factor(test_set$R1))

# KSVM model
# create folds for k-fold cross validation
folds = createFolds(as.factor(train_set[, 11]), k = 10)

# Optimise for C parameter
C_list <- list("0.001", "0.005", "0.01", "0.05", "0.1", "0.5", "1", "5", "10", "50", "100", "1000")
best_c <- 0
best_accuracy <- 0

for (c in C_list) {
  model = lapply(folds, function(x) {
    train_fold = train_set[-x, ]
    test_fold = train_set[x, ]
    
    ksvm = ksvm(as.matrix(train_fold[, 1:10]), as.factor(train_fold[, 11]), type="C-svc", kernel="vanilladot", C=c, scaled=TRUE)
    
    y_pred <- predict(ksvm, test_fold[, 1:10])
    # accuracy <- sum(y_pred == test_fold[, 11]) / nrow(test_fold)
    
    cm = table(test_fold[, 11], y_pred)
    accuracy = (cm[1,1] + cm[2,2]) / (cm[1,1] + cm[2,2] + cm[1,2] + cm[2,1])
    return(accuracy)
  })
  cv_accuracy <- mean(unlist(model))
  if (cv_accuracy > best_accuracy) {
    best_c <- c
    best_accuracy <- cv_accuracy
  }
}

cat("The best performing value of C is:", best_c)
cat("The accuracy with the best value of C is:", best_accuracy*100, "%")
ksvm_model <- ksvm(as.matrix(train_set[, 1:10]), as.factor(train_set[, 11]), type="C-svc", kernel="vanilladot", C=best_c, scaled=TRUE)

# fit the model and observe the model performance
ksvm_pred <- predict(ksvm_model, test_set[, 1:10])
confusionMatrix(data=ksvm_pred, reference=as.factor(test_set$R1))

# 3.1b
set.seed(31)
# create train-validation-test split (80-10-10)
df_len <- dim(df)[1]
test_sample <- sample(1:df_len, size=round(1/10*df_len), replace=FALSE, seed=31)
train_validation_set <- df[-test_sample,]
test_set <- df[test_sample,]

train_validation_df_len <- dim(train_validation_set)[1]
validation_sample <- sample(1:train_validation_df_len, size=round(1/9*train_validation_df_len), replace=FALSE, seed=31)
train_set <- df[-validation_sample,]
validation_set <- df[validation_sample,]

# KNN model
# train the kknn model to find the best value of k
kknn_training_model <- train.kknn(as.factor(R1)~., data=train_set, scale=T, kmax=50)
best_k <- kknn_training_model[['best.parameters']][[2]]
best_accuracy <- 1 - min(kknn_training_model[['MISCLASS']])
  
cat("The best performing value of k is:", best_k)
cat("The accuracy with the best value of k is:", best_accuracy*100, "%")

y_pred <- predict(kknn_training_model, test_set[, 1:10])
confusionMatrix(data=y_pred, reference=as.factor(test_set$R1))


# using the best parameters from the training step, build the kknn model
kknn_model <- kknn(as.factor(R1)~., train=train_set, test=validation_set, scale=T, k=5)

# fit the model and observe the model performance
kknn_fit <- fitted(kknn_model)
confusionMatrix(data=kknn_fit, reference=as.factor(validation_set$R1))

# KSVM model
# Optimise for C parameter
C_list <- list("0.001", "0.005", "0.01", "0.05", "0.1", "0.5", "1", "5", "10", "50", "100", "1000")
best_c <- 0
best_accuracy <- 0

# train the ksvm model to find the best value of C
for (c in C_list) {
  ksvm_training_model <- ksvm(as.matrix(train_set[, 1:10]), as.factor(train_set[, 11]), type="C-svc", kernel="vanilladot", C=c, scaled=TRUE)
    
  y_pred <- predict(ksvm_training_model, train_set[, 1:10])
  accuracy <- sum(y_pred == train_set[, 11]) / nrow(train_set)

  if (accuracy > best_accuracy) {
    best_c <- c
    best_accuracy <- accuracy
  }
}

cat("The best performing value of C is:", best_c)
cat("The accuracy with the best value of C is:", best_accuracy*100, "%")

# using the best value of C from the training step, build the ksvm model
ksvm_model <- ksvm(as.matrix(train_set[, 1:10]), as.factor(train_set[, 11]), type="C-svc", kernel="vanilladot", C=best_c, scaled=TRUE)

# fit the model and observe the model performance
ksvm_pred <- predict(ksvm_model, validation_set[, 1:10])
confusionMatrix(data=ksvm_pred, reference=as.factor(validation_set$R1))

# since KSVM model performs better, we will evaluate the test set using KSVM
ksvm_pred <- predict(ksvm_model, test_set[, 1:10])
confusionMatrix(data=ksvm_pred, reference=as.factor(test_set$R1))

kknn_model <- kknn(as.factor(R1)~., train=train_set, test=test_set, scale=T, k=5)
kknn_fit <- fitted(kknn_model)
confusionMatrix(data=kknn_fit, reference=as.factor(test_set$R1))

# Question 4.1
Describe a situation or problem from your job, everyday life, current events, etc., for which a clustering
model would be appropriate. List some (up to 5) predictors that you might use.

In my job in the food delivery industry, we have restaurant accounts on our platform to provide food options to our customers. 
One use case of clustering for these restaurant vendors is to cluster them based on their performance on our platform so that 
we can target them more effectively with benefits to encourage their good performance or recommendations to improve their performance.

Some predictors we can use are:
  * Number of years the vendor is on our platform
  * Amount of Gross Merchandise Value contributed by the vendor in the past 3 months
  * Number of orders by the vendor in the past 3 months
  * Conversion rate (# orders / # clicks) of the vendor in the past 3 months
  * Average customer rating of the vendor in the past 3 months
  
# Question 4.2
The iris data set iris.txt contains 150 data points, each with four predictor variables and one
categorical response. The predictors are the width and length of the sepal and petal of flowers and the
response is the type of flower. The data is available from the R library datasets and can be accessed with
iris once the library is loaded. It is also available at the UCI Machine Learning Repository
(https://archive.ics.uci.edu/ml/datasets/Iris ). The response values are only given to see how well a
specific method performed and should not be used to build the model.
Use the R function kmeans to cluster the points as well as possible. Report the best combination of
predictors, your suggested value of k, and how well your best clustering predicts flower type.

# import iris library
library(datasets)
library(cluster)
library(factoextra)

# set seed for reproducibility
set.seed(31)

# summary of the iris data
data(iris)
summary(iris)

#create plot of number of clusters vs total within sum of squares
fviz_nbclust(as.matrix(iris[, 4]), kmeans, method = "wss")

# K-means model
cluster_model <- kmeans(as.matrix(iris[, 4]), centers=3)
centers <- sort(cluster_model$centers)
cluster_model <- kmeans(as.matrix(iris[, 4]), centers=centers)

# Plotting the clustering predictions on chart
plot(as.matrix(iris[, 4]), col = cluster_model$cluster)

# Rename cluster numbers to the iris species
y_pred <- factor(cluster_model$cluster)
levels(y_pred) <- c("setosa","versicolor","virginica")

# Confusion matrix to show model performance
confusionMatrix(data=y_pred, reference=as.factor(iris$Species))

