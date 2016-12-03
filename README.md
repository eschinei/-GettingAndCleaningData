# GettingAndCleaningData
This repository contains the files needed and requested as part of the Peer-graded Assignment: Getting and Cleaning Data Course Project, where the main goal is to prepare tidy data that can be used for later analysis.
In this repo you can find the following files:
    1. The requested data set is tidy: tidyData.csv
    2. Script developed to prepare tidy data: runAnalysis.R
    3. A code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information: CodeBook.md
    4. README that explains the analysis files
    
The code used to process the data and produce the final tidy set is shown and explained below.
First, the data is extracted fromt he different files.
Activit labels and features, which will be later used to rename variables:
          runAnalysis <- function(){
                  ## Read activities and features information from files
                  activity_labels=read.table("activity_labels.txt", header=F)
                  features=read.table("features.txt", header=F)
                  
All test data is read:
                  ## Read TEST data set (subjects, activities and measures)
                  subject_test=read.table("./test/subject_test.txt", header=F)
                  X_test=read.table("./test/X_test.txt", header=F)
                  Y_test=read.table("./test/Y_test.txt", header=F)
                  
A first set with the Test data is created, including 'subjects' and 'activities' columns:
                  ## Bind TEST set (subjects, activities and measures)
                  XY_test=cbind(subject_test, Y_test,X_test)
                  
Same as for Test data, the training data is read:
                  ## Read TRAIN data set (subjects, activities and measures)
                  subject_train=read.table("./train/subject_train.txt", header=F)
                  X_train=read.table("./train/X_train.txt", header=F)
                  Y_train=read.table("./train/Y_train.txt", header=F)

Another set with the Training data is created, including 'subjects' and 'activities' columns:
                  ## Bind TRAIN set (subjects, activities and measures)
                  XY_train=cbind(subject_train, Y_train,X_train)

Training and Test sets are merged, as requested:
                  ## Merges TEST & TRAINING sets to create one data set
                  XY=rbind(XY_test,XY_train)

Once the data set is created, variables names are changed to more descriptive labels. For measurements, the variables provided by the documentation are used:
                  ## Update Variables Names (Columns) to more descriptive 
                  names(XY)=c("subject", "activity_label",as.character(features$V2))

A function with a loop to substitute the initial activity labels (numbers from 1 to 6) for their real names (Walking, Laying, etc.) is created:
                  ## Function that will label Activities from numbers "1:6" to their more descriptive names
                  gsub2 <- function(pattern, replacement, x) {
                          for(i in 1:length(pattern)) x <- gsub(pattern[i], replacement[i], x)
                          x
                  }

                  ## Call function 'gsub2' to change Activities' names
                  XY$activity_label= gsub2(1:6, activity_labels$V2, XY$activity_label)

Measurements on the mean and standard deviation are extracted for each measurement 'grepl':
                  ## Extract all 'mean' and 'std' measurements, along with 'Subjects' and 'Activities'
                  ## 'FreqMean' is considered as 'mean' measurement
                  XY_Ext=XY[,grepl("subject|activity_label|mean|std",names(XY))]
                  
An independent tidy data set with the average of each variable for each activity and each subject is created using 'ddply':
                  ## Use 'ddply' to estimate the average of each variable for each activity and each subject
                  XY_Ext2=ddply(XY_Ext,.(subject,activity_label),colwise(mean))
              
The tidy data is saved in a new file called 'tidyData.csv':              
                  ## Save the new tidy data set
                  write.table(XY_Ext2,file = "tidyData.csv",row.names=F)
          }
