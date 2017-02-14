#This is my R script for the course project; below are the instructions
#provided:

#You should create one R script called run_analysis.R that does the following.

#1 Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation
#for each measurement.
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names.
#5 From the data set in step 4, creates a second, independent tidy data
#set with the average of each variable for each activity and each subject.
#
#
#1 Loading the datasets from the zip file:
#(From the UCI HAR DATASET DIRECTORY)
#
#
#Training set
trx <- read.table(file.choose()) #X_train.txt
try <- read.table(file.choose()) #y_train.txt
trs <- read.table(file.choose()) #subject_train.txt
train <- cbind(trs, try, trx)

#Test set
tex <- read.table(file.choose()) #X_test.txt
tey <- read.table(file.choose()) #y_test.txt
tes <- read.table(file.choose()) #subject_test.txt
test <- cbind(tes, tey, tex)


#merging the observations from both sets
merged <- rbind(train, test)

#2 Extracts only the measurements on the mean and standard deviation
#for each measurement.

#variable names
var_names <- read.table(file.choose()) #features.txt
var_corrected <- as.character(var_names[,2])

#setting names
colnames(merged) <- c("activity","subject",var_corrected)

names <- names(merged)

mean_std <- grepl(("activity|subject|mean|std"), names)

extract <- merged[ , mean_std == TRUE]

#3 Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table(file.choose()) #activity_labels.txt
colnames(activity_labels) <- c("activity","label")

#4 Appropriately labels the data set with descriptive variable names.
extract_with_labels <- merge(extract, activity_labels, by="activity", all.x=T)

##5 From the data set in step 4, creates a second, independent tidy data
#set with the average of each variable for each activity and each subject.

#install.packages("plyr",dep=T)
require(plyr)

tidy <- ddply(extract_with_labels, c("subject","activity"), numcolwise(mean))

if(!file.exists("./GCD_Assignment")){dir.create("./GCD_Assignment")}
write.table(tidy, "./GCD_Assignment/tidy_dataset_GCD.txt")
