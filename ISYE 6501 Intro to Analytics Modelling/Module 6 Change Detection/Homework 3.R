# Load required libraries
library(outliers)
library(ggplot2) 
library(qcc)
library(rlist)

# Question 5.1
directory <- "C:/Users/Clayton/Documents/Gatech/ISYE 6501 Intro to Analytics Modelling/Module 6 Change Detection/Homework 3/"
crime_df <- read.table(paste0(directory, "uscrime.txt"), header = T, sep = "\t")

set.seed(31)  # Setting seed for reproducibility

ggplot(crime_df, aes(x = NULL, y = Crime)) +
  geom_boxplot(fill = "blue", color = "black") +
  labs(title = "Boxplot of Number of Crimes per 100,000 people", x = NULL, y = "Crime (per 100,000 people)") +
  theme_minimal()

crime_df[crime_df$Crime > 1900, ]

outlier_result <- grubbs.test(crime_df$Crime) 
print(outlier_result)

outliers <- crime_df$Crime[outlier_result$outliers]
print(outliers)


# Question 6.2.a
temps_df <- read.table(paste0(directory, "temps.txt"), header = T, sep = "\t")

for (year in 2:21) {
  temps <- cusum(temps_df[year], decision.interval = 17)
  
  for (i in 1:length(temps$neg)) {
    if (temps$neg[i] < -17) {
      first_dip_index <- i
      break
    }  
  }
  
  if (year == 2) {
    first_dip_df <- data.frame(colnames(temps_df[year]), temps_df[first_dip_index, ]$DAY)
    names(first_dip_df) <- c("year", "day")  
  } else {
    new_first_dip_df <- data.frame(colnames(temps_df[year]), temps_df[first_dip_index, ]$DAY)
    names(new_first_dip_df) <- c("year", "day")
    first_dip_df <- rbind(first_dip_df, new_first_dip_df)
  }
}

first_dip_df

# Question 6.2.b
for (year in 2:21) {
  temps <- cusum(temps_df[year], decision.interval = 17)
  
  for (i in 1:length(temps$neg)) {
    if (temps$neg[i] < -17) {
      first_dip_index <- i
      break
    }  
  }
  
  avg_temp <- mean(temps_df[1:first_dip_index, year])
  
  if (year == 2) {
    yearly_temps_df <- data.frame(colnames(temps_df[year]), avg_temp)
    names(yearly_temps_df) <- c("year", "avg_temp")  
  } else {
    new_yearly_temps_df <- data.frame(colnames(temps_df[year]), avg_temp)
    names(new_yearly_temps_df) <- c("year", "avg_temp")
    yearly_temps_df <- rbind(yearly_temps_df, new_yearly_temps_df)
  }
}

yearly_temps <- cusum(yearly_temps_df[2], decision.interval = 2)

for (i in 1:length(yearly_temps$neg)) {
  if (yearly_temps$pos[i] > 2) {
    warm_summer_index <- i
    cat("Atlanta's summer climate has gotten warmer in the year", yearly_temps_df[warm_summer_index, ]$year, "\n")
  }  
}

