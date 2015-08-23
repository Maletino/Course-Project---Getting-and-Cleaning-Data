# Getting and Cleaning Data - Course Project
# By Maletino Hola
# Date: 21 August 2015

## ************************************************************************
## 1.Merges the training and the test sets to create one data set.
## ************************************************************************

# Download data

# Run ONCE if script is repeatedly run-------------------------------------
#if (!file.exists("./data")){
#  dir.create("./data")
#}

#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl, destfile = "./data/dataset.zip")

#unzip("./data/dataset.zip")
# Dataset is extracted to the "UCI HAR Dataset" folder
# RUN ONCE ended ----------------------------------------------------------

## Reading data
# Data were manually copied to the "./data" folder

# Read variables' names from - features.txt
features <- read.table("./data/features.txt")

# Column names for all data
features_variables <- as.character(features[,2])
col_names <- c("Subject", features_variables, "Activity")

# Read Test data ----------------------------------------------------------
# identify files in folder
test_files <- list.files("./data/test/", full.names = TRUE)

# create a list to hold data frames read
test_list <- list()

# read test subfolder files
for (i in 2:length(test_files)){
  df <- read.table(test_files[i], header = FALSE)
  test_list[[i-1]] <- df
}

# append together data for all missions using rbind in do.call()
test_data <- do.call(cbind, test_list)

# rename variables - columns' names
colnames(test_data) <- col_names
tail(test_data)

# Read Train data ----------------------------------------------------------
# identify files in folder
train_files <- list.files("./data/train/", full.names = TRUE)
train_files

# create a list to hold data frames read
train_list <- list()

# read test subfolder files
for (i in 2:length(train_files)){
  df <- read.table(train_files[i], header = FALSE)
  train_list[[i-1]] <- df
}

# append together data for all missions using rbind in do.call()
train_data <- do.call(cbind, train_list)

# rename variables
colnames(train_data) <- col_names

# Combine the two datasets -------------------------------------------------
final_data <- rbind(train_data, test_data)
dim(final_data)
final_data[1:3,]

## ************************************************************************
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## ************************************************************************

# determine columns that has 'mean' or 'std' in its name
mean_std <- grep("mean|std", col_names)

mean_std_df <- final_data[,mean_std]
dim(mean_std_df)
mean_std_df[1:5,]

## ************************************************************************
## 3. Uses descriptive activity names to name the activities in the data set
## ************************************************************************

# Create a vector of activity labels
activity_labels_df <- read.table("./test/activity_labels.txt")
activity_labels <- activity_labels_df[,2]
activity_labels <- as.character(activity_labels) # may not required

# create a vector of activities based on the labels
labels <- activity_labels[final_data$Activity]

# update activity label column
final_data$Activity <- labels
final_data$Activity[1:60]

## ************************************************************************
# 4. Appropriately labels the data set with descriptive variable names. 
## ************************************************************************

# replace 'Acc' with 'Accelometer'
for (i in seq_along(col_names)){
  strName <- col_names[i]
  col_names[i] <- sub("Acc", "Accelemeter", strName)
}

# replace 'Gyro' with 'Gyroscope'
for (i in seq_along(col_names)){
  strName <- col_names[i]
  col_names[i] <- sub("Gyro", "Gyroscope", strName)
}

# replace 'Mag' with 'Magnitude'
for (i in seq_along(col_names)){
  strName <- col_names[i]
  col_names[i] <- sub("Mag", "Magnitude", strName)
}

# Rename column names to avoid duplicates
# remove '()' and ')' from variables
for (i in seq_along(col_names)){
  strName <- col_names[i]
  strName <- gsub("\\(\\)", "", strName) 
  col_names[i] <- gsub("\\)", "", strName)
}

# make column names unique
col_names <- make.names(col_names, unique = TRUE)

# further processing - replace period(.) with an underscore
for (i in seq_along(col_names)){
  strName <- col_names[i]
  col_names[i] <- gsub("(\\.)+", "_", strName) 
}

# Replace old with new column names
colnames(final_data) <- col_names
col_names[100:120]

## ************************************************************************
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## ************************************************************************

library(dplyr)
#library(reshape2)
# create a copy of the tidy data
final_data_tbl <- tbl_df(final_data)
final_data_tbl

# group 'final_data' by 'Subject' and then 'Activity' and then find mean
final_data_gp1 <- final_data_tbl %>%
  group_by(Subject, Activity) %>%
  summarise_each(funs(mean))

dim(final_data_gp)
View(final_data_gp)
