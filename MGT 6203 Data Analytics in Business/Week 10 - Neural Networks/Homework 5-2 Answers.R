# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 10 - Neural Networks\\Smarket.csv", header = TRUE, sep=",")

# Q1
library(neuralnet)

# Q2
df[,-7] <- scale(df[,-7])

# Q3
set.seed(1000)

training_size = floor(nrow(scaled_df) * 0.8)
train_index = sample(1:nrow(scaled_df), training_size)
train_set = scaled_df[train_index, ]
test_set = scaled_df[-train_index, ]

# Q4
nn = neuralnet(Up ~ Lag1 + Lag2, data=train_set, hidden=2, linear.output=FALSE)
load("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 10 - Neural Networks\\Smarket_nn1.Rda")

# Q5
plot(nn, rep="best")

# Q6
nn$weights

# Q7
test_set[1,]

s1 = (-1.5526810) + (-0.4006151 * -0.5516457) + (0.3979986 * 0.9047775)
s1 = exp(s1)/(1+exp(s1))
s1

s2 = (-20.092955) + (1.325688 * -0.5516457) + (33.606746 * 0.9047775)
s2 = exp(s2)/(1+exp(s2))
s2

p1 = (-0.2670554) + (2.5133068 * s1) + (-0.7918837 * s2)
p1 = exp(p1)/(1+exp(p1))
p1

# Q8
compute(nn, test_set[1, ])

# Q9
nn = neuralnet(Up ~ ., data=train_set, hidden=c(4, 2), linear.output=FALSE)
load("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 10 - Neural Networks\\Smarket_nn2.Rda")

# Q10
plot(nn, rep="best")
nn$weights

# Q11
compute(nn, test_set[1, ])
ml_pred = compute(nn, test_set)

# Q12
pred = rep(FALSE, nrow(test_set))
pred[ml_pred$net.result>0.5] = TRUE

pred = ml_pred$net.result >0.5

# Q13
confusion_matrix = table(pred, test_set$Up)
confusion_matrix

sum(diag(confusion_matrix)) / sum(confusion_matrix)

# Q14
log_model = glm(Up~., data=train_set, family=binomial(link="logit"))
summary(log_model)

log_pred = predict(log_model, test_set, type="response")

log_pred = log_pred > 0.5

log_confusion_matrix = table(log_pred, test_set$Up)
log_confusion_matrix

sum(diag(log_confusion_matrix)) / sum(log_confusion_matrix)

