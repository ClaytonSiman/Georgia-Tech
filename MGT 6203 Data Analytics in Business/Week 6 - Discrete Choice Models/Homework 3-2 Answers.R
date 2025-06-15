# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 6 - Discrete Choice Models\\Commute_Mode.csv", header = TRUE, sep=",")

# Q1
library(mlogit)
mlogit_data = mlogit.data(df, choice='choice', shape='long', alt.var='mode', chid.var='id')

# Q2
model = mlogit(formula=choice~time+cost, data=mlogit_data)
summary(model)

# Q3
## Yes the signs of the coefficients are reasonable as the baseline alternative is by bus, 
## which the frequencies of car & rail are higher than bus so the average utility 
## from these alternatives are higher, therefore utility coefficients are positive; 
## vice-versa for carpool

## When cost goes up, the utility of choosing that alternative goes down
## When commute time goes up, the utility of choosing that alternative goes down

## 3 intercept coefficients because there are 3 alternatives other than the baseline alternative

# Q4
head(fitted(model, outcome=FALSE))

## First row, last column: Probability of choosing rail as transport for first person

# Q5 
time.avg = tapply(mlogit_data$time, mlogit_data$mode, mean)
time.avg
cost.avg = tapply(mlogit_data$cost, mlogit_data$mode, mean)
cost.avg

xval = data.frame(time=time.avg, cost=cost.avg)
xval

effects(model, covariate='cost', data=xval)
effects(model, covariate='time', data=xval)

## The marginal effect matrix measures the effect on choice probability if the covariate increases by 1 unit
## e.g. Marginal effect on time
##          bus          car       carpool         rail
## bus     -0.010359065  0.006554077  0.0009151041  0.002889884
## car      0.006554080 -0.021179563  0.0035174460  0.011108038
## carpool  0.000915104  0.003517445 -0.0059834926  0.001550944
## rail     0.002889884  0.011108035  0.0015509441 -0.015548863

## row-axis: if time increases by 1 unit is on this alternative
## col-axis: the marginal effect on choice probability on each alternative

## e.g. for the first row (time increase by 1 unit on bus), 
## this will cause the choice probability of bus to decrease by about 1.04%;
## the other alternative choice probabilities will increase because the choice probability of bus has decreased
## car will increase by 0.66%, carpool +0.09%, rail +0.29%
## net effect from all alternatives (-1.04% + 0.66% + 0.09% + 0.29%) = 0%