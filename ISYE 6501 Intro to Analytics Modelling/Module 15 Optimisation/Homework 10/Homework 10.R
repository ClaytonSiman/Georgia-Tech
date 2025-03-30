library(Hmisc)
library(tidyverse)
library(mice)

# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.csv("C:/Users/Clayton/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 15 Optimisation/Homework 10/breast-cancer-wisconsin.data.txt", header = TRUE)

df <- df %>% 
  rename(
    Sample_code_number = X1000025,
    Clump_thickness = X5,
    Uniformity_of_cell_size = X1,
    Uniformity_of_cell_shape = X1.1,
    Marginal_adhesion = X1.2,
    Single_epithelial_cell_size = X2,
    Bare_nuclei = X1.3,
    Bland_chromatin = X3,
    Normal_nucleoli = X1.4,
    Mitoses = X1.5,
    Class = X2.1
  )

describe(df$Bare_nuclei)

ggplot(df, aes(Bare_nuclei)) +
  geom_histogram(color = "#000000", fill = "#0099F8", stat="count") +
  ggtitle("Bare_nuclei") +
  theme_classic() +
  theme(plot.title = element_text(size = 18))



mode_imputed_df <- data.frame(df)

mode_imputed_df$Bare_nuclei[mode_imputed_df$Bare_nuclei == '?'] <- '1'

sum(mode_imputed_df == '?')
ggplot(mode_imputed_df, aes(Bare_nuclei)) +
  geom_histogram(color = "#000000", fill = "#0099F8", stat="count") +
  ggtitle("Bare_nuclei") +
  theme_classic() +
  theme(plot.title = element_text(size = 18))



regression_imputed_df <- data.frame(df)

test_set <- regression_imputed_df[regression_imputed_df$Bare_nuclei == '?',]
train_set <- regression_imputed_df[regression_imputed_df$Bare_nuclei != '?',]

describe(train_set$Bare_nuclei)

model <- lm(Bare_nuclei ~ ., data=train_set) 

test_set$Bare_nuclei <- round(predict(model, newdata=test_set), 0)

regression_imputed_df <- rbind(train_set, test_set)

sum(regression_imputed_df == '?')
ggplot(regression_imputed_df, aes(Bare_nuclei)) +
  geom_histogram(color = "#000000", fill = "#0099F8", stat="count") +
  ggtitle("Bare_nuclei") +
  theme_classic() +
  theme(plot.title = element_text(size = 18))


mice_imputed_df <- data.frame(df)
mice_imputed_df$Bare_nuclei <- as.numeric(mice_imputed_df$Bare_nuclei)

temp_data <- mice(mice_imputed_df, method = 'norm.nob', print=FALSE)
summary(temp_data)

mice_imputed_df <- round(complete(temp_data), 0)

sum(is.na(mice_imputed_df))

ggplot(mice_imputed_df, aes(Bare_nuclei)) +
  geom_histogram(color = "#000000", fill = "#0099F8", stat="count") +
  ggtitle("Bare_nuclei") +
  theme_classic() +
  theme(plot.title = element_text(size = 18))









