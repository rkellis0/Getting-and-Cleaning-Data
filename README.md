<<<<<<< HEAD
---
title: "README"
output: html_document
---

The following script was created in order to read the various text files into r to begin the process of clean data for analysis.

```{r}
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
```
 
Once the files were read into r, the code chunk below depicts the methods I used to merge the training and test datasets into one.

```{r}
testdata <- cbind(subtest, ytest, xtest)
traindata <- cbind(subtrain, ytrain, xtrain)
comdata <- rbind(traindata, testdata)
```

now that the training and test datasets are in one table, I was able to extract the data that was required within the instructions

```{r}
getfeat <- grep(".*mean.*|.*std.*", feat[,2])
getfeat.names <- feat[getfeat,2]
getfeat.names = gsub('-mean', 'Mean', getfeat.names)
getfeat.names = gsub('-std', 'Std', getfeat.names)
getfeat.names <- gsub('[-()]', '', getfeat.names)
```

After establishing which variables were to be extracted I went back to the merged table I created and seperated the table and remerged the table to ensure the dataset I created only contained the mean and standard deviation.

```{r}
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
```

With a new dataset that contains the mean and standard deviation, the variables have to be accurately named.

```{r}

#add column names

colnames(comdata2) <- c("subject", "activity", getfeat.names)

comdata2$activity <- factor(comdata2$activity, levels = actlables[,1], labels = actlables[,2])
comdata2$subject <- as.factor(comdata2$subject)
```


The final code creates a tidy set with a average of each variable for activity and each subject. 

```{r}
comdata2.melted <- melt(comdata2, id = c("subject", "activity"))
comdata2.mean <- dcast(comdata2.melted, subject + activity ~ variable, mean)

#Create tidy.txt file

write.table(comdata2.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

```

=======
# Getting-and-Cleaning-Data
>>>>>>> d205c6b9ad3d6e7a5d1fc5444f21c88b45bc7382
