# Set seed for reproducibility
set.seed(31)

# Read temperature data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 2 - Binary Response Models\\Loan.csv", header = TRUE, sep=",")

# Q1
df$Education <- as.factor(df$Education)

# Q2
model <- lm(Loan ~ ., df)
summary(model)
## Having education = 2 will result in loan probability increasing by 0.1517
## Having education = 3 will result in loan probability increasing by 0.1605

# Q3
## It indicates the likelihood of loans being approved for each customer
## Yes, there are customers with fitted y greater than 1 or less than 0
head(model$fitted.values[model$fitted.values < 0 | model$fitted.values > 1])
head(model$fitted.values[model$fitted.values < 0])
head(model$fitted.values[model$fitted.values > 1])
min(model$fitted.values)

# Q4
logit_model <- glm(Loan ~., family=binomial(link='logit'), df)
summary(logit_model)

# Q5 
threshold <- sum(df$Loan) / length(df$Loan)
pred_y <- logit_model$fitted.values
pred_y[pred_y >= threshold] <- 1
pred_y[pred_y < threshold] <- 0
pred_y <- as.integer(pred_y)


library(caret)
confusionMatrix(data=as.factor(pred_y), reference=as.factor(df$Loan))

y_hat <- predict(logit_model, df, type='response')
y_hat[y_hat >= threshold] <- 1
y_hat[y_hat < threshold] <- 0
y_hat <- as.integer(y_hat)
confusionMatrix(data=as.factor(y_hat), reference=as.factor(df$Loan))


# Q6
summary(logit_model)

mean(df$Income)
mean(df$Family)
mean(df$CCAvg)
calculated_prob <- 
  summary(logit_model)$coefficients["(Intercept)", "Estimate"] + 
  summary(logit_model)$coefficients["Income", "Estimate"] * mean(df$Income) + 
  summary(logit_model)$coefficients["Family", "Estimate"] * mean(df$Family) + 
  summary(logit_model)$coefficients["CCAvg", "Estimate"] * mean(df$CCAvg) + 
  summary(logit_model)$coefficients["Education2", "Estimate"]
prob_success <- exp(calculated_prob) / (1 + exp(calculated_prob))
prob_success

new_data <- data.frame(Income = mean(df$Income), Family = mean(df$Family), CCAvg = mean(df$CCAvg), Education = as.factor(2))
predict(logit_model, newdata=new_data)

# Q7
model$coefficients
logit_model$coefficients
## Why Coefficients Aren't Directly Comparable: 
### 1. Different Scales:
### The coefficients in LPMs represent changes in probabilities (a percentage point), while the coefficients in logit models represent changes in log-odds (which are not directly intuitive without conversion to odds ratios). 
### 2. Model Structure:
### LPMs treat the probability as a direct output, while logit models transform the probability into log-odds before linearizing. 
### 3. Range of Values:
### Probabilities are bounded between 0 and 1, while log-odds can range from negative to positive infinity. 

###In summary, the core difference lies in how the models map predictor variables to the outcome. LPMs map directly to probabilities, while logit models map to log-odds, requiring different interpretations for the coefficients. 

# Q8
library(margins)
margins(logit_model)

logit_prob <- 
  0.002284 * mean(df$Income) + 
  0.02243 * mean(df$Family) + 
  0.006214 * mean(df$CCAvg) + 
  0.1436 * 1
logit_prob

margins(model)
## Yes, they are supposed to be comparable
## The logit model has generally lower partial effects than the LPM

