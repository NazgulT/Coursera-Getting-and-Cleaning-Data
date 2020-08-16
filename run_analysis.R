#1. Read train and test sets into R

#Download the zip
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data")) {dir.create("./data")}
download.file(zipUrl, destfile = "./data/motion.zip", method = "curl")

#Unzip the motion file
unzip(zipfile = "./data/motion.zip", exdir = "./data")

#Read data from the neccessary files
zip_path <- file.path("./data", "UCI HAR Dataset")

#We will need only the following files to load into R
#test/subject_test.txt
#test/X_test.txt
#test/y_test.txt
#train/subject_train.txt
#train/X_train.txt
#train/y_train.txt

#Read the train and test sets
trainset <- data.table::fread(file.path(zip_path, "train", "X_train.txt"))
testset <- data.table::fread(file.path(zip_path,"test", "X_test.txt"))

#Read the subject files
trainsubject <- data.table::fread(file.path(zip_path, "train", "subject_train.txt"))
testsubject <- data.table::fread(file.path(zip_path, "test", "subject_test.txt"))

#Read the activitiy files
trainactivity <- data.table::fread(file.path(zip_path, "train", "y_train.txt"))
testactivity <- data.table::fread(file.path(zip_path, "test", "y_test.txt"))


#2. Merges the training and the test sets to create one data set.

#Merge the subject data
subjectData <- rbind(trainsubject, testsubject)

#Merge the activity data
activityData <- rbind(trainactivity, testactivity)

#Merge the train and test data sets
observationsAll <- rbind(trainset, testset)

#Set names to each merged data table
names(subjectData) <- c("subject")
names(activityData) <- c("activity")
obsNames <- data.table::fread(file.path(zip_path, "features.txt"))
names(observationsAll) <- obsNames$V2

#Merget all tables together to get on huge data set
dataInter <- cbind(subjectData, activityData)
data <- cbind(dataInter, observationsAll)

#3. Extracts only the measurements on the mean and standard deviation for each measurement.
#Filter out only column names with mean and std in it using regular expression
namesRequired <- obsNames$V2[grep("mean\\(\\)|std\\(\\)", obsNames$V2)]

library(dplyr)
data <- select(data, "subject", "activity", as.character(namesRequired))

#4. Uses descriptive activity names to name the activities in the data set
#Download the activity labels
activity_labels <- data.table::fread(file.path(zip_path, "activity_labels.txt"))
#data <- mutate(data, activity = activity_labels[data$activity, 2])
for(i in 1:6)
  data$activity[data$activity == i] <- as.character(activity_labels[i, 2])

#Make it as a factor
data$activity <- as.factor(data$activity)

#5. Appropriately labels the data set with descriptive variable names.

names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("-mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("-std()", "STD", names(data), ignore.case = TRUE)
names(data)<-gsub("-freq()", "Frequency", names(data), ignore.case = TRUE)
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))

#5. From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.

#Convert subject to factor
data$subject <- as.factor(data$subject)

tidyData <- aggregate(. ~subject + activity, data, mean)
tidyData <- tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)

