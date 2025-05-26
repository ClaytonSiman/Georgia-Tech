# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 3 - Censored & Truncated Models\\Mobile_data_usage.csv", header = TRUE, sep=",")

# Q1
quota <- df$Quota
data_use <- df$DataUse

plot(quota, data_use)

# Q2
model <- lm(DataUse ~ Quota + Days, df)
summary(model)

# Q3
library("censReg")
cens_model <- censReg(DataUse ~ Quota + Days, df, left=0, right=Inf)
summary(cens_model)

# Q4
summary(model)$coefficients[, 1]
summary(cens_model)$estimate[1:3, 1]
## Estimates are different as the linear regression estimates are estimates for the underlying latent variable y* while censReg model are estimating for the variable y

# Q5
mean_days <- mean(df$Days)

margEff(cens_model, c(1, 10, mean_days))
margEff(cens_model, c(1, 2000, mean_days))
margEff(cens_model, c(1, 200000, mean_days))

min(df$)
