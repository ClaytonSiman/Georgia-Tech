# Question 2.2.1
# Installing & importing packages
library(kernlab)

# Read credit card data into df
directory <- "C:/Users/Clayton/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 2 Classification/"
df <- read.table(paste0(directory, "credit_card_data-headers.txt"), header = T, sep = "\t")

# Set seed for reproducibility
set.seed(31)

# Find the best performing value of C based on the accuracy of predictions
C_list <- list("0.001", "0.005", "0.01", "0.05", "0.1", "0.5", "1", "5", "10", "50", "100")
best_i <- 0
best_accuracy <- 0

for (i in C_list) {
  print(i)
  model <- ksvm(as.matrix(df[, 1:10]), as.factor(df[, 11]), type="C-svc", kernel="vanilladot", C=i, scaled=TRUE)
  pred <- predict(model, df[, 1:10])
  accuracy <- sum(pred == df[, 11]) / nrow(df)
  if (accuracy > best_accuracy) {
    best_i <- i
    best_accuracy <- accuracy
  }
}

cat("The best value for C is: ", best_i)

# Train the model using the best value of C
final_model <- ksvm(as.matrix(df[, 1:10]), as.factor(df[, 11]), type="C-svc", kernel="vanilladot", C=best_i, scaled=TRUE)
final_pred <- predict(final_model, df[, 1:10])
final_accuracy <- sum(final_pred == df[, 11]) / nrow(df)

cat("Using the best value for C, the accuracy is: ", final_accuracy*100, "%")

# Calculate coefficients of a1…am
a <- colSums(final_model@xmatrix[[1]] * final_model@coef[[1]])

# Calculate a0
a0 <- -final_model@b

# Show the equation of the classifier and accuracy of the model
equation <- a0

for (name in names(a)) {
  if (substring(a[name], 1, 1) == "-") {
    equation <- paste0(equation, " - ", substring(a[name], 2), "*", name)
  } else {
    equation <- paste0(equation, " + ", a[name], "*", name)
  }
}

cat("The equation of the classifier is:", equation, "\n")
cat("The accuracy of the classifier is:", final_accuracy*100, "%")

# Question 2.2.2
# Training classifier with a range of kernels and values of C
kernel_list <- list("rbfdot", "polydot", "tanhdot", "laplacedot", "besseldot", "anovadot", "splinedot")
C_list <- list("0.001", "0.005", "0.01", "0.05", "0.1", "0.5", "1", "5", "10", "50", "100")

for (k in kernel_list) {
  best_i <- 0
  best_accuracy <- 0
  
  ign <- capture.output({
    for (i in C_list) {
      model <- ksvm(as.matrix(df[, 1:10]), as.factor(df[, 11]), type="C-svc", kernel=k, C=i, scaled=TRUE)
      pred <- predict(model, df[, 1:10])
      accuracy <- sum(pred == df[, 11]) / nrow(df)
      if (accuracy > best_accuracy) {
        best_i <- i
        best_accuracy <- accuracy
      }
    }
  })
  
  cat("The best value of C for", k, "kernel is:", best_i, "\n")
  cat("Using the best value of C, the accuracy for", k, "is:", best_accuracy*100, "%", "\n\n")
}

# Question 2.2.3
# Installing & importing packages
library(kknn)

# Set seed for reproducibility
set.seed(31)

# Create train-test split
df_len <- dim(df)[1]
test_sample <- sample(1:df_len, size=round(0.2*df_len), replace=FALSE)
train_set <- df[-test_sample,]
test_set <- df[test_sample,]

# Train the KNN classifier and find the best value of k
best_i <- 0
best_accuracy <- 0

for (i in 1:100) {
  kknn_model <- kknn(as.factor(R1)~., train_set, test_set, k=i, distance=1, kernel="optimal", scale=T)
  fit <- fitted(kknn_model)
  accuracy <- sum(test_set$R1 == fit) / nrow(test_set)
  if (accuracy > best_accuracy) {
    best_i <- i
    best_accuracy <- accuracy
  }
}

cat("Best value of k is:", best_i, "\n")
cat("Using the best value of k, the accuracy is:", best_accuracy*100, "%")