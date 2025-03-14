library(Hmisc)
library(caret)
library(rpart)
library(rattle)
library(randomForest)
library(tidyverse)
library(pROC)

# Set seed for reproducibility
set.seed(31)

# Read temperature data into a dataframe
df <- read.table("//Users/c.siman/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 10 Advanced Regression/Homework 7/uscrime.txt", header = TRUE)

describe(df)

# Regression Tree
## Cross validation (specify the cross-validation method)
ctrl <- trainControl(method="LOOCV")

# Fit a CART model and use LOOCV to evaluate performance
rtree_model_cv <- train(Crime~., data=df, method="rpart", trControl=ctrl)
min(rtree_model_cv$results$RMSE)

rtree_model <- rpart(Crime~., data=df)
summary(rtree_model)

par(bg = 'white')
fancyRpartPlot(rtree_model, main="Regression Tree", palettes=c("Blues"), type=1)
rtree_model$variable.importance

rtree_pred <- predict(rtree_model, data=df)
sqrt(mean((rtree_pred - rtree_model$y)^2))

# Random Forest
## Cross validation (specify the cross-validation method)
ctrl <- trainControl(method="LOOCV")

# Fit a CART model and use LOOCV to evaluate performance
rf_model_cv <- train(Crime~., data=df, method="rf", trControl=ctrl)
min(rf_model_cv$results$RMSE)

rf_model <- randomForest(Crime~., data=df)
varImpPlot(rf_model)

sqrt(mean((rf_model$predicted - rf_model$y)^2))



# Question 10.3
# Read data into a dataframe
df <- read.table("//Users/c.siman/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 10 Advanced Regression/Homework 7/germancredit.txt", header = FALSE)

df <- df %>% 
  rename(
    checking_acc_status = V1,
    duration_months = V2,
    credit_history = V3,
    purpose = V4,
    credit_amount = V5,
    savings_account_or_bonds = V6,
    employment_since = V7,
    installment_rate_of_income = V8,
    personal_status_and_sex = V9,
    other_debtors = V10,
    present_residence_since = V11,
    property = V12,
    age = V13,
    other_installment_plans = V14,
    housing = V15,
    number_existing_credits = V16,
    job = V17,
    number_people_liable_for_maintenance = V18,
    has_telephone = V19,
    is_foreign_worker = V20,
    is_bad_credit = V21
  )
df$is_bad_credit = df$is_bad_credit - 1
describe(df)

# create train-test split (80-20)
df_len <- dim(df)[1]
test_sample <- sample(1:df_len, size=round(0.2*df_len), replace=FALSE)
train_set <- df[-test_sample,]
test_set <- df[test_sample,]

## Cross validation (specify the cross-validation method)
model <- glm(is_bad_credit~., data=train_set, family=binomial(link="logit"))
summary(model)

#calculate probability of default for each individual in test dataset
pred <- predict(model, test_set, type="response")

#calculate AUC
roc = roc(test_set$is_bad_credit, pred)
plot(roc, col="blue")
auc(test_set$is_bad_credit, pred)

# ## Cross validation (specify the cross-validation method)
# model <- glm(is_bad_credit~checking_acc_status + duration_months + credit_history + purpose + credit_amount + savings_account_or_bonds + employment_since + installment_rate_of_income + personal_status_and_sex + property + other_installment_plans + housing + number_existing_credits + has_telephone + is_foreign_worker, data=train_set, family=binomial(link="logit"))
# summary(model)
# 
# #calculate probability of default for each individual in test dataset
# pred <- predict(model, test_set, type="response")
# 
# #calculate AUC
# roc = roc(test_set$is_bad_credit, pred)
# plot(roc, col="blue")
# auc(test_set$is_bad_credit, pred)
# 

threshold_list <- list()
pos_pred_list <- list()
accuracy_list <- list()
for (threshold in seq(0.2, 0.8, by=0.05)) {
  binary_pred <- cbind(ifelse(pred>threshold, 1, 0))
  confusion_matrix <- confusionMatrix(data=as.factor(binary_pred), reference=as.factor(test_set$is_bad_credit))
  threshold_list <- rbind(threshold_list, threshold)
  pos_pred_list <- rbind(pos_pred_list, confusion_matrix[["byClass"]][["Pos Pred Value"]])
  accuracy_list <- rbind(accuracy_list, confusion_matrix[["overall"]][["Accuracy"]])
}
plot(threshold_list, accuracy_list, main="accuracy vs threshold")

binary_pred <- cbind(ifelse(pred>0.4, 1, 0))
confusionMatrix(data=as.factor(binary_pred), reference=as.factor(test_set$is_bad_credit))
