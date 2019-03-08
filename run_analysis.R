#Coursera
#Getting and Cleaning Data
#by Johns Hopkins University

#Stephen Beaver
#05Mar2019

#End Course: Peer Graded Project

#You should create one R script called run_analysis.R that does the following.

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with
#the average of each variable for each activity and each subject.

#Here are the data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#Set Working Dir
setwd("~/Coursera/Data Science Specialization/Cleaning Data")

#Download Zip
download.file(
'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 
destfile= 'data.zip')

#Unzip
unzip('data.zip')

#Change Working Dir
setwd("~/Coursera/Data Science Specialization/Cleaning Data/UCI HAR Dataset")

# read train data 
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
sub_train <- read.table("./train/subject_train.txt")

# read test data 
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
sub_test <- read.table("./test/subject_test.txt")

# read features description 
features <- read.table("./features.txt") 

# read activity labels 
activity_labels <- read.table("./activity_labels.txt") 

#update column names
colnames(x_train) = features[,2]
colnames(x_test) = features[,2]

colnames(y_train) = "activityId"
colnames(y_test) = "activityId"

colnames(sub_train) = "subjectId"
colnames(sub_test) = "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

#merge data sets
merged_train = cbind(x_train, y_train, sub_train)
merged_test = cbind(x_test, y_test, sub_test)

#add variable for which set each came from
merged_test$data_set_origin = "test"
merged_train$data_set_origin = "train"

#combine test and train data sets
combined_data_set = rbind(merged_test, merged_train)

#subset columns with 'mean' OR 'std' in name
columns_mean_std = grep(".*Mean.*|.*Std.*", names(combined_data_set), ignore.case=TRUE)

tidy_columns = c(columns_mean_std, 562,563,564)

final_data_set = combined_data_set[, tidy_columns]

#Add Activity Name column from the ActivityID number
for (i in 1:6){
    final_data_set$Activity[final_data_set$activityId == i] <- as.character(activity_labels[i,2])
}

#make factor columns
final_data_set$activityId <- as.factor(final_data_set$activityId)
final_data_set$Activity <- as.factor(final_data_set$Activity)
final_data_set$subjectId <-as.factor(final_data_set$subjectId)

#make tidy data set
#aggregate(x = testDF, by = list(by1, by2), FUN = "mean")
tidy_data_set <- aggregate(x = final_data_set, by = list(activity=final_data_set$Activity, subjectid=final_data_set$subjectId), FUN="mean")

#write tidy data set
write.table(tidy_data_set[,1:88], file = "TidyDataSet.txt", row.names = FALSE, sep='\t')

#make codebook
#install.packages('dataMaid')
library(dataMaid)
makeCodebook(tidy_data_set)

