# the working directory is set
setwd("~/R/DataScience/03Getting_Cleaning_Data/Week4/Final_Project/UCI HAR Dataset")

#import required librarys
library("dplyr")
library("tidyr")

#import data for test subjects
test_activities <- as_tibble(read.table("./test/y_test.txt"))
test_var <- as_tibble(read.table("./test/x_test.txt"))
test_subject <- as_tibble(read.table("./test/subject_test.txt"))

#import data for train subjects
train_activities <- as_tibble(read.table("./train/y_train.txt"))
train_var <- as_tibble(read.table("./train/X_train.txt"))
train_subject <- as_tibble(read.table("./train/subject_train.txt"))

#importing names for variables and subseting in a vector
var_names <- as_tibble(read.table("./UCI HAR Dataset/features.txt"))
var_names <- select(var_names, V2)
var_names <- t(var_names)

#assigning names to test and train variables
names(test_var) <- var_names
names(train_var) <- var_names

#changing names for activity columns
names(train_activities) <- "activity"
names(test_activities) <- "activity"

#subseting column names that contain mean and std in the name
test_var <- select(test_var, contains(c("mean()", "std()")))
train_var <- select(train_var, contains(c("mean()", "std()")))


#changing names for subject columns
names(test_subject) <- "subject"
names(train_subject) <- "subject"

#bind all test data
test <- bind_cols(test_subject, test_activities, test_var)

#bind all train data
train <- bind_cols(train_subject, train_activities, train_var)

#bind test and train data
data <- bind_rows(test, train)

#creating variable x
x <- 0

#replacing activity data with descriptive names
for (i in 1:nrow(data[,2])) {
        y <- unlist(data[i,2])
        if (y == 1) {
                x[i] <- "WALKING"   
        }
        if (y == 2) {
                x[i] <- "WALKING_UPSTAIRS"   
        }
        if (y == 3) {
                x[i] <- "WALKING_DOWNSTAIRS"   
        }
        if (y == 4) {
                x[i] <- "SITTING"   
        }
        if (y == 5) {
                x[i] <- "STANDING"   
        }
        if (y == 6) {
                x[i] <- "LAYING"   
        }
        i <- i+1
}

#replacing the activity column
data$activity <- x

#creating summary data table 
new <- summarize_each(group_by(data, subject, activity), mean)

#removing unnecessary variables
rm(test_activities)
rm(test_subject)
rm(test_var)
rm(train)
rm(train_activities)
rm(train_subject)
rm(train_var)
rm(x)
rm(var_names)
rm(y)
rm(i)
rm(test)