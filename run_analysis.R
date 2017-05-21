##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## 2017-05-21
## Derek Geng

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Clean up workspace
rm(list=ls())

library(reshape2)
library(plyr)

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip", method="auto")

# Unzip dataSet to /data directory
unzip(zipfile="Dataset.zip",exdir="./data")

# 1. Merge the training and the test sets to create one data set.

# read data (training & testing)
features        <- read.table("./data/UCI HAR Dataset/features.txt",header=FALSE)
activityLabel   <- read.table("./data/UCI HAR Dataset/activity_labels.txt",header=FALSE)

subjectTrain    <-read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
xTrain          <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=FALSE)
yTrain          <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=FALSE)

subjectTest    <-read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
xTest         <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=FALSE)
yTest         <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=FALSE)

#Assign column names.

colnames(activityLabel)<-c("activityID","activityType")

colnames(subjectTrain) <- "subjectID"
colnames(xTrain) <- features[,2]
colnames(yTrain) <- "activityID"

colnames(subjectTest) <- "subjectID"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityID"

# merge data
trainData <- cbind(yTrain,subjectTrain,xTrain)
testData <- cbind(yTest,subjectTest,xTest)
finalData <- rbind(trainData,testData)
colNames <- colnames(finalData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

mean_and_std <-finalData[,grepl("mean|std|subjectID|activityID",colnames(finalData))]

# 3. Use descriptive activity names to name the activities in the data set

mean_and_std <- merge(mean_and_std, activityLabel,by='activityID',all.x=TRUE)

# 4. Appropriately label the data set with descriptive activity names. 

#Remove parentheses

names(mean_and_std) <- gsub("\\(|\\)", "", names(mean_and_std), perl  = TRUE)

#correct syntax in names

names(mean_and_std) <- make.names(names(mean_and_std))


#add descriptive names

names(mean_and_std) <- gsub("Acc", "Acceleration", names(mean_and_std))
names(mean_and_std) <- gsub("^t", "Time", names(mean_and_std))
names(mean_and_std) <- gsub("^f", "Frequency", names(mean_and_std))
names(mean_and_std) <- gsub("BodyBody", "Body", names(mean_and_std))
names(mean_and_std) <- gsub("mean", "Mean", names(mean_and_std))
names(mean_and_std) <- gsub("std", "Std", names(mean_and_std))
names(mean_and_std) <- gsub("Freq", "Frequency", names(mean_and_std))
names(mean_and_std) <- gsub("Mag", "Magnitude", names(mean_and_std))

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# tidydata_mean_and_std <- aggregate(. ~subjectID + activityID, mean_and_std, mean)

tidydata_mean_and_std<- ddply(mean_and_std, c("subjectID","activityID"), numcolwise(mean))

write.table(tidydata_mean_and_std,file="./tidydata.txt",row.name=FALSE)
