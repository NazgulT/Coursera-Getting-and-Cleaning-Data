# Coursera-Getting-and-Cleaning-Data

Current repository was created as part of the Data Science: Getting and Cleaning Data course work on Coursera.com. 

The purpose of this project is to learn how to get and tidy the data set. We were provided with the data collected from Samsung Galaxy S smartphone accelerometers. The code for downloading and cleaning up the initial data is written in run_analysis.R file. In particular, the code performs the following steps:

run_analysis.R - description of main operations.
1. Download and unzip data set called "UHC HAR Dataset" - the code is provided in run_analysis.R
2. Unzip the motion file
3. We will need only the following files to load into R

test/subject_test.txt, test/X_test.txt, test/y_test.txt, train/subject_train.txt, train/X_train.txt, train/y_train.txt

4. Read training and testing data sets into R variables

5. Merge the training and testing datasets into one big data table. For that we need to first rbind test and train sets for each category: subject, activity, and our main data

6. Set the names columns in each data table

7. Merged all tables together to get on huge data set

8. Extract only the measurements on the mean and standard deviation for each measurement.
Filter out only column names with mean and std in it using regular expression: "mean\\(\\)|std\\(\\)" and select from dplyr

9. Use descriptive activity names to name the activities in the data set i.e. take activity names from file called "activity_lables.txt".  


10. Appropriately label the data set with descriptive variable names. For example, Acc into Accelerometer and etc., using gsub.

11. From the data set in step 4, creates a second, independent tidy data 
set with the average of each variable for each activity and each subject.

12. Convert subject to a factor

13. Save the result to a tidy data set

codeBook_tidyData.pdf - is a codebook for the tidy data set we created in run_analysis.R
Generated with dataMaid library.



