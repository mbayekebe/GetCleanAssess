# Getting and Cleaning Data : Peer Assessment 

# Purpose

# R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#  1.

# set working directory
setwd("H:/Rproga/UCI HAR Dataset")
cat("Begin processing...\n")
# read initial data sets into temporary ones
# and check number of records read and columns
tempds1 <- read.table("train/X_train.txt") # X training set
tempds2 <- read.table("test/X_test.txt")  # X test set
# we  rbind() them into XDS and check the rows and cols
XDS <- rbind(tempds1, tempds2)
# All ok, we reapeat for the labels data
tempds1 <- read.table("train/y_train.txt") # training set labels
tempds2 <- read.table("test/y_test.txt")  # test set labels
# we  rbind() them into LDS and check the rows and cols
LDS <- rbind(tempds1, tempds2)
# All ok, we reapeat for the subjects data
tempds1 <- read.table("train/subject_train.txt") # training set labels
tempds2 <- read.table("test/subject_test.txt")  # test set labels
# we  rbind() them into SDS and check the rows and cols
SDS <- rbind(tempds1, tempds2)

# 2.

# We read in the features table and look for varibale names with mean() and std()
# some varibales have Mean in them but we are sticking to what is required in 2. above
meanstd <- read.table("features.txt")
select_meanstd <- grep("mean()|std()", meanstd[,2])   # from second column
str(select_meanstd)   # just checking
# We can now subset XDS 
XDS <- XDS[,select_meanstd]
Nmeanstd <- meanstd[select_meanstd,]   #subsetting meanstd
# Check columns in XDS, then give corresponding names
names(XDS) <- Nmeanstd[,2]
# Remove the () from names and convert to lower case
names(XDS) <-gsub("\\(|\\)", "", tolower(names(XDS)))

# 3.

# We read in the activities table
ADS <- read.table("activity_labels.txt")
# we remove underscore and convert to lower case
ADS[,2] <- gsub("_", "", tolower((ADS[,2])))
# replace the numbers  by activity labels in LDS
for (line in 1:nrow(LDS)){
  LDS[line,1] <- ADS[LDS[line,1],2]
}
# Just give name to the column of LDS
names(LDS) <- "activity"

# 4.

# We name the column of subject data set SDS
names(SDS) <- "subject"
# We now join the three data sets
FinalDS <- cbind(SDS,LDS,XDS)
# we save it
write.table(FinalDS, "H:/Rproga/UCI HAR Dataset/FirstTidy.txt", sep="\t")
cat("The merge table written to file FirstTidy.txt\n")
# 5.

# We create the second tidy data set with the averages
TidyDS <- aggregate(FinalDS[,-c(1,2)], by = list(subject= FinalDS$subject,activity = FinalDS$activity), FUN= "mean")
# we save it
write.table(TidyDS, "H:/Rproga/UCI HAR Dataset/SecondTidy.txt", sep="\t")
cat("The second independant table written to file SecondTidy.txt\n")
cat("run_analysis completed!\n")

