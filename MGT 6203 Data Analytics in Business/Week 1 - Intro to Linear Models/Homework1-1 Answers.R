# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 1 - Intro to Linear Models\\UsedCars.csv", header = TRUE, sep=",")

# Q1 & 3
model <- lm(Price ~ Age+KM+HP+Metallic+Automatic+CC+Doors+Gears+Weight, df)
summary(model)

# Q2
model$residuals[0:10]
model$fitted.values[0:10]
df$Price[0:10] - model$fitted.values[0:10]

# Q3
summary(model)
summary(model)$coefficients[, 1] / summary(model)$coefficients[, 2]

# Q4
degree_freedom <- df.residual(model)
qt(0.95, degree_freedom)

# Q5
summary(model)
tstat <- summary(model)$coefficients[, 3]

# Q6
## Significant variables are: Age, KM, HP, Automatic, Gears, Weight

# Q7
summary(model)$r.squared
var(df$Price)
var(model$fitted.values) / var(df$Price)

# Q8
library(car)
car::vif(model)
## No signs of multicollinearity as all VIF values are <5

# Q9i
weight_model <- lm(Weight ~ Age+KM+HP+Metallic+Automatic+CC+Doors+Gears, df)
summary(weight_model)

r_squared_list <- c()
vif_list <- c()

weight_model <- lm(Weight ~ Age, df)
r_squared_list <- c(r_squared_list, summary(weight_model)$r.squared)
weight_model <- lm(Weight ~ KM, df)
r_squared_list <- c(r_squared_list, summary(weight_model)$r.squared)
weight_model <- lm(Weight ~ HP, df)
r_squared_list <- c(r_squared_list, summary(weight_model)$r.squared)
weight_model <- lm(Weight ~ Metallic, df)
r_squared_list <- c(r_squared_list, summary(weight_model)$r.squared)
weight_model <- lm(Weight ~ Automatic, df)
r_squared_list <- c(r_squared_list, summary(weight_model)$r.squared)
weight_model <- lm(Weight ~ CC, df)
r_squared_list <- c(r_squared_list, summary(weight_model)$r.squared)
weight_model <- lm(Weight ~ Doors, df)
r_squared_list <- c(r_squared_list, summary(weight_model)$r.squared)
weight_model <- lm(Weight ~ Gears, df)
r_squared_list <- c(r_squared_list, summary(weight_model)$r.squared)

r_squared_list

# Q9ii
for (i in 0:8) {
  vif <- 1 / (1-r_squared_list[i])
  vif_list <- c(vif_list, vif)
}

vif_list

# Q10
final_model <- lm(Price ~ Age+KM+HP+Automatic+Gears+Weight, df)
summary(final_model)

# Q11
summary(model)
summary(final_model)
## R-squared remains largely the same but the adjusted R-squared of the new model is higher, likely due to lower penalties with fewer independent variables used

# Q12
## The better fit model is the new model with fewer independent variables
## 1 year older: Price will DECREASE by $129.9
## 10,000 more KM: Price will DECREASE by $146.3
