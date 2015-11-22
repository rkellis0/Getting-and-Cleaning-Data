#Set work space

library(reshape2)
library(plyr)
install.packages("RCurl")
library(RCurl)

#Set working directory to the location of the downloaded file

setwd("C:/Users/Ricky/Desktop/course/Getting and Cleaning Data")

#Download and unzip file

fileloc <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filenm <- "data.zip"

download.file(fileloc, filenm, method="libcurl")

unzip(filenm)

#load activity, features, test and train datasets
actlables <- read.table("UCI HAR Dataset/activity_labels.txt")
actlables[,2] <- as.character(actlables[,2])
feat <- read.table("UCI HAR Dataset/features.txt")
feat[,2] <- as.character(feat[,2])

subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")

subtest <- read.table("UCI HAR Dataset/test/subject_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")

#Merge Datasets

testdata <- cbind(subtest, ytest, xtest)
traindata <- cbind(subtrain, ytrain, xtrain)
comdata <- rbind(traindata, testdata)

# extraxt desired features

getfeat <- grep(".*mean.*|.*std.*", feat[,2])
getfeat.names <- feat[getfeat,2]
getfeat.names = gsub('-mean', 'Mean', getfeat.names)
getfeat.names = gsub('-std', 'Std', getfeat.names)
getfeat.names <- gsub('[-()]', '', getfeat.names)

#Reload datasets to with wanted features

subtrain2 <- read.table("UCI HAR Dataset/train/subject_train.txt")
ytrain2 <- read.table("UCI HAR Dataset/train/y_train.txt")
xtrain2 <- read.table("UCI HAR Dataset/train/X_train.txt")[getfeat]

traindata2 <- cbind(subtrain2, ytrain2, xtrain2)

subtest2 <- read.table("UCI HAR Dataset/test/subject_test.txt")
ytest2 <- read.table("UCI HAR Dataset/test/y_test.txt")
xtest2 <- read.table("UCI HAR Dataset/test/X_test.txt")[getfeat]

testdata2 <- cbind(subtest2, ytest2, xtest2)

#merge new datasets
 
comdata2 <- rbind(traindata2, testdata2)

#add column names

colnames(comdata2) <- c("subject", "activity", getfeat.names)

#clean dataset

comdata2$activity <- factor(comdata2$activity, levels = actlables[,1], labels = actlables[,2])
comdata2$subject <- as.factor(comdata2$subject)

comdata2.melted <- melt(comdata2, id = c("subject", "activity"))
comdata2.mean <- dcast(comdata2.melted, subject + activity ~ variable, mean)

#Create tidy.txt file

write.table(comdata2.mean, "tidy.txt", row.names = FALSE, quote = FALSE)





