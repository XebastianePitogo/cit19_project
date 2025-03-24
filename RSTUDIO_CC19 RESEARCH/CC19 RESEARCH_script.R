library(tidyr)
library(dplyr)
library(FSelector)
#For model
library(caret)
library(rpart)
library(rpart.plot)
library(ggplot2)

# one hot encoding
# df$CLASS <- model.matrix(~CLASS-1, data=df)

#Read df csv file located in github
df <- read.csv("https://raw.githubusercontent.com/XebastianePitogo/cit19_project/refs/heads/main/Student-Employability-Datasets.csv")

#Find missing values within our df. There are (0) missing values hence no imputations to be done.
sum(is.na(df))


#Example of code statement for handling missing values through imputations and removal.
#To remove missing values, we use, <variable> <- na.omit(df)
#And to impute missing values, we use 
# value_imputed <- data.frame(
#   original = df$<feature>,
#   imputed_zero = replace(df$<feature>, is.na(df$<feature>), 0),
#   imputed_mean = replace(df$<feature>, is.na(df$<feature>), mean(df$<feature>, na.rm = TRUE)),
#   imputed_median = replace(df$<feature>, is.na(df$<feature>), median(df$<feature>, na.rm = TRUE))
# )

#We cannot detect and impute for outlier in our likert scale data but outliers can be detected in continuous data using <boxplot(<dataframe>)>
#However, we use straight-lining in likert scale data to find data noise (lazy answering by respondents).

summary(df)
#We have char in our dataframe, so we one-hot encoded it.


#Check column 2 to end that computes for variance in df row wise. If variance is (0)
# then respondent chose all one answer (all 2 in self confidence for example) probably due to lazyness.
df$variance <- apply(df[, 2:ncol(df)], 1, var)

#Show output if there are any straight-liners (lazy answers)
low_variance <- df[df$variance == 0, ]  # Detect straight-liners

low_variance


df <- df %>%
  select(variance, everything())

# <0 rows> means no straight-liners

#No data normalization because we are using likert-scale ordinal data

#convert class to as factor (useful for categorical data)
df$CLASS_factor <- as.factor(df$CLASS)

#Remove features that does not contribute/not meaningful to
# CLASS_factor target variable for feature selection
df_filtered <- df[, !colnames(df) %in% c("Name.of.Student", "variance","CLASS")]

#Check for feature importance using chi-square and mutual info
#Mutual info shows each feature contribution only to target variable (CLASS_factor)
mutual_info <- information.gain(CLASS_factor ~ ., df_filtered)  
#Chi-Square scoring measures how strongly each categorical feature is associated with
# the target variable (CLASS_factor). Higher scores indicate stronger relationships.
chi_scores <- chi.squared(CLASS_factor ~ ., df_filtered)

print("CHI SCORES: ")
print(chi_scores)
cat("\n")
print("MUTUAL INFO:")
print(mutual_info)
#Student performance should be removed as it has zero mutual score and chi score

preprocessed_df <- df_filtered[, !colnames(df_filtered) %in% c("Student.Performance.Rating")]




