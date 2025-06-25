# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 7 - Causal Inference\\Education_data.csv", header = TRUE, sep=",")

# Q1
model <- lm(log(wage) ~ educ + exper + I(exper**2), df)
summary(model)

# Q2
cor(df$educ, df$nearc4)
cor(df$educ, df$fatheduc)
cor(df$educ, df$motheduc)

## Father educ has the highest correlation with educ, so it could be the best instrumental
## variable to be used for educ; but the correlation with the error term is unknown here

# Q3
stage1 = lm(educ ~ nearc4 + exper + I(exper**2), df)
summary(stage1)

## Yes, the endogenous variable educ is correlated with the proposed IV nearc4 with a high
## coefficient (beta) of 0.49 with statistical significance

# Q4
stage2 = lm(log(wage) ~ fitted(stage1) + exper + I(exper**2), df)
summary(stage2)

# Q5
install.packages("AER")
library("AER")

tsls_model = ivreg(log(wage) ~ educ + exper + I(exper**2)|nearc4 + exper + I(exper**2), data=df)
summary(tsls_model)

cbind(coef(model), coef(tsls_model))
