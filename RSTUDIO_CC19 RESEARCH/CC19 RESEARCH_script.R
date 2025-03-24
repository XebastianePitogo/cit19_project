#For Data Preprocessing.
library(tidyr)
library(dplyr)
#For Modeling.
library(caret)
library(rpart)
library(rpart.plot)
library(ggplot2)

#Read df csv file located in github
df <- read.csv("https://raw.githubusercontent.com/XebastianePitogo/cit19_project/refs/heads/main/Student-Employability-Datasets.csv?token=GHSAT0AAAAAAC6TSJRLWU5UZB6JYYGJ3UI6Z7A4JPA")

#Find missing values within our df. There are (0) missing values hence no imputations to be done.
sum(is.na(df))

#Example of code statement for handling missing values through imputations and removal.
#To remove missing values we use <variable> <- na.omit(df)
#


