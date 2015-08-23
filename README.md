---
title: "Course Project - Getting and Cleaning Data"
author: "Maletino"
date: "August 21, 2015"
output: html_document
---

## Purpose

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 

1. a tidy data set as described below, 
2. a link to a Github repository with your script for performing the analysis, and 
3. a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called **CodeBook.md**. You should also include a **README.md** in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

## Scenario

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

 You should create one R script called `run_analysis.R` that does the following. 

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!

## Steps to achieve a tidy dataset

### 1. Merges the training and the test sets to create one data set.

#### 1.1 Download data

The following script downloads the dataset required

```
if (!file.exists("./data")){
  dir.create("./data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/dataset.zip")

unzip("./data/dataset.zip")
# Dataset is extracted to the "UCI HAR Dataset" folder
```

#### 1.2 Reading data

- As stated in 1.1 above, the dataset by default was unzipped to the folder "./UCI HAR Dataset". For this analysis, data were manually copied to the "./data" folder to be used.
- More information about the set can be found in the main folder files such as:
    + **README.txt** - general information
    + **features.txt** - list of variables
    + **features_info.txt** - information about the variables
    + **activity_labels.txt** - activities performed

Order of data reading are as follows:

1. **Variables or columns names:**
    + The variables' names were read first from features.txt. This will be the names for 562 of the columns in a data set. 
    + In addition, there are two other columns, one for the subject that participated in the experiment as well as for the activities on which measurement were care carried out. The other column names are "Subject" and "Activity".
    + Variables names will be cleaned up later for clarity and uniqueness.
2. **Test data:**
    + List of files to be read are identified.
    + Each file is then read as a data frame and then add to the list.
    + Three files (*subject_test.txt*, *X_test*, *y_test*) are read which include the Subject, Activity and the 562 measurements.
    + Once reading is done the list of 3 data frames will be combined onto a single data set (test_data) using `rbind` in `do.call()`
        - `test_data <- do.call(cbind, test_list)`
    + Last step in this case is to rename the column names as in #1 above.
3. **Read Train data:** 
    + Reading the train data is similar to that of the test data.
4. **Combine the two datasets:** `test_data` and `train_data`
    + Use `rbind` as both datasets have the same variables or columns.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    + Use the `grep` function to extract these measurements.
    + See result after running the script.

### 3. Uses descriptive activity names to name the activities in the data set
3.1 Create a vector of activity labels from file `activity_labels.txt`. There are 6 activities.
3.2 Create a vector of activities based on the labels in 3.1.
3.3 Update the Activity column replacing the labels (1 to 6) with actual activities.

### 4. Appropriately labels the data set with descriptive variable names. 

Use `sub`, `gsub`, regular expressions others to make the variables' names more descriptive.

The following changes were made:

1. Replace '`Acc`' with '`Accelometer`'
2. Replace '`Gyro`' with '`Gyroscope`'
3. Replace '`Mag`' with '`Magnitude`'
4. Replace certain special characters such as ".,()-" and so on.
5. Use `make.names` to ensure there is no duplicate in the variable or column names. This will be useful is Step 5.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

- Use `dplyr` functions or verbs to group '`final_data`' by '`Subject`' and then '`Activity`' and then find mean for each measurement.

## Submission

- Follow the instructions stated in the Course Project.