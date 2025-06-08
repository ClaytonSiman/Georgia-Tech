# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 5 - Survival Models\\Bank_Attrition.csv", header = TRUE, sep=",")

# Q1
library(survival)
model = survreg(Surv(ChurnTime, 1-Censored) ~ Age + Income + HomeVal + Tenure + DirectDeposit + Loan + NumAccounts + Dist + MktShare, df)

# Q2
summary(model)

delta = coef(model)
a = 1/model$scale
beta = delta * -a

delta
beta

# Q3
xbar = colMeans(df[, 2:10])
xbeta = crossprod(c(1, xbar), beta)
curve(exp(c(xbeta)) * a * x^(a-1), xlim=c(0, 50), xlab='Time', ylab='Hazard')

a

# Q4
curve(dweibull(x, shape=a, scale=exp(-xbeta/a)), xlab='Churn Time', ylab='Density', xlim=c(0, 20), ylim=c(0, 0.12))
hist(df$ChurnTime[df$Censored == 0], breaks=50, freq=FALSE, add=TRUE, col=NULL)
