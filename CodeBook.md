CodeBook

This is a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.


1. Data source

dataset: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


2. The dataset includes the following files:

'features_info.txt'

'features.txt'

'activity_labels.txt'

'train/X_train.txt'

'train/y_train.txt'

'test/X_test.txt'

'test/y_test.txt'

3.  transformationparts:

Merges the training and the test sets to create one data set.

Extracts only the measurements on the mean and standard deviation for each measurement.

Uses descriptive activity names to name the activities in the data set

Appropriately labels the data set with descriptive activity names.

Creates a second, independent tidy data set with the average of each variable for each activity and each subject.




4.run_analysis.R implements the above steps:

  Unzip dataSet to /data directory

  read data

  assign column names

  merge data

  Extract the mean and standard deviation

  clean up and aggregate the data

  export the data as .txt
