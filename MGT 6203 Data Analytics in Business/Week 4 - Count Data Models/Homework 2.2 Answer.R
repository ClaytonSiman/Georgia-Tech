# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 4 - Count Data Models\\Forum_Posts.csv", header = TRUE, sep=",")

# Q1
poisson_model <- glm(posts ~ ., df, family=poisson)
summary(poisson_model)

# Q2
y = df$posts
yhat = predict(poisson_model, type='response')
sigma_sq = sum((y-yhat)^2 / yhat) / (nrow(df) - length(coef(poisson_model)))
sigma_sq
## Since sigma_sq is way above 1, we conclude that there is overdispersion and poisson distribution is not suitable for this dataset

# Q3
library(MASS)
nb_model = glm.nb(posts~., df)
summary(nb_model)

# Q4 
## The overdispersion is quite high as theta has an inverse relationship with sigma_sq
## Since theta is very close to 0 (and below 1), the sigma_sq in this model is high

# Q5
cbind(AIC(poisson_model), AIC(nb_model))
cbind(BIC(poisson_model), BIC(nb_model))
## Since the AIC & BIC about the negative binomial model is lower than the poisson model (16k vs 25k),
## we can conclude that the negative binomial model fits the data better

# Q6
xbar = colMeans(df[2:5])
poisson_xbar = crossprod(coef(poisson_model), c(1, xbar))
nb_xbar = crossprod(coef(nb_model), c(1, xbar))
k = 0:20
p1 = dpois(k, exp(poisson_xbar))
p2 = dnbinom(k, size=nb_model$theta, mu=exp(nb_xbar))
plot(k, p2, pch=16, xlab='Posts', ylab='Probability')
points(k, p1)
legend('topright', c('Poisson', 'Negative Binomial'), pch=c(1, 16))

p2[1]
