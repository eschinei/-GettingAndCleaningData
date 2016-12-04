runAnalysis <- function(){
        ## Read activities and features information from files
        activity_labels=read.table("activity_labels.txt", header=F)
        features=read.table("features.txt", header=F)
        
        ## Read TEST data set (subjects, activities and measures)
        subject_test=read.table("./test/subject_test.txt", header=F)
        X_test=read.table("./test/X_test.txt", header=F)
        Y_test=read.table("./test/Y_test.txt", header=F)
        
        ## Bind TEST set (subjects, activities and measures)
        XY_test=cbind(subject_test, Y_test,X_test)
        
        ## Read TRAIN data set (subjects, activities and measures)
        subject_train=read.table("./train/subject_train.txt", header=F)
        X_train=read.table("./train/X_train.txt", header=F)
        Y_train=read.table("./train/Y_train.txt", header=F)
        
        ## Bind TRAIN set (subjects, activities and measures)
        XY_train=cbind(subject_train, Y_train,X_train)
        
        ## Merges TEST & TRAINING sets to create one data set
        dataSet=rbind(XY_test,XY_train)
        
        ## Update Variables Names (Columns) to more descriptive 
        names(dataSet)=c("subject", "activity_label",as.character(features$V2))
        
        ## Function that will label Activities from numbers "1:6" to their more descriptive names
        gsub2 <- function(pattern, replacement, x) {
                for(i in 1:length(pattern)) x <- gsub(pattern[i], replacement[i], x)
                x
        }
        
        ## Call function 'gsub2' to change Activities' names
        dataSet$activity_label= gsub2(1:6, activity_labels$V2, dataSet$activity_label)
                
        ## Extract all 'mean' and 'std' measurements, along with 'Subjects' and 'Activities'
        ## 'FreqMean' is considered as 'mean' measurement
        XY_Extract=dataSet[,grepl("subject|activity_label|mean|std",names(dataSet))]
        ## Use 'ddply' to estimate the average of each variable for each activity and each subject
        tidyData=ddply(XY_Extract,.(subject,activity_label),colwise(mean))
        ## Save the new tidy data set
        write.table(tidyData,file = "tidyData.csv",row.names=F)
}