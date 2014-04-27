#read tables
xtest <- read.table("test/x_test.txt", header = F, stringsAsFactors = F)
ytest <- read.table("test/y_test.txt", header = F, stringsAsFactors = F)
ytrain <- read.table("train/y_train.txt", header = F, stringsAsFactors = F)
xtrain <- read.table("train/x_train.txt", header = F, stringsAsFactors = F)
Colnames<- read.table("features.txt")
subtest<-read.table("test/subject_test.txt")
subtrain<-read.table("train/subject_train.txt")
a_labels<- read.table("activity_labels.txt")

#examine tables
head(read.table("test/y_test.txt"))

head(read.table("test/x_test.txt"))

# 4name the columns
names(xtrain)<- Colnames[,2]
names(xtest)<- Colnames[,2]
names(subtrain)<- "s_id"
names(subtest)<- "s_id"
names(ytest)<- "y"
names(ytrain)<- "y"

# 1merge tables
xystest<- cbind(ytest, subtest, xtest)
xystrain<- cbind(ytrain, subtrain, xtrain)
master<- rbind(xystest, xystrain)

# 2extract mean and standard deviation columns
extractM1 <- subset(master, select = grep("mean\\(\\)", colnames(master)))
extractM2 <- subset(master, select = grep("std\\(\\)", colnames(master)))
extractM3 <- subset(master, select = (1:2))
extractM <- cbind(extractM3, extractM1, extractM2)

#3 & 4 adding descriptive activity names
eMaL<- cbind(mapvalues(extractM$activity, from = c(1,2,3,4,5,6), 
                       to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                              "SITTING", "STANDING", "LAYING")), extractM)
colnames(eMaL)[1]<-"activity_labels"
colnames(eMaL)[3]<- "subject_id"



# 5create a second independent tidy data set
library(reshape2)
masterMelt<- melt(eMaL, id.vars = c("subject_id", "activity_labels"), measure.vars = c(4:69))
tidymM<- dcast(masterMelt, subject_id + activity_labels ~ variable, mean)
write.table(tidymM, "FinalTidyData.txt")