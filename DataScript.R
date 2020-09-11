setwd("C:/Users/gerge/Desktop/data/UCI HAR Dataset")
library(dplyr)
features<-read.table("Features.txt",col.names = c("n","functions"))
activ<-read.table("activity_labels.txt",col.names = c("code","activity"))
subtest<-read.table("test/subject_test.txt",col.names = "subject")
xtest<-read.table("test/X_test.txt",col.names = features$functions)
ytest<-read.table("test/y_test.txt",col.names = "code")
subtrain<-read.table("train/subject_train.txt",col.names = "subject")
xtrain<-read.table("train/X_train.txt",col.names = features$functions)
ytrain<-read.table("train/y_train.txt",col.names = "code")

X<-rbind(xtrain,xtest)
Y<-rbind(ytrain,ytest)
subject<-rbind(subtrain,subtest)
mergeddata<-cbind(subject,Y,X)

tidydata<-mergeddata %>% select(subject,code,contains("mean"),contains("std"))

tidydata$code<-activ[tidydata$code,2]

names(tidydata)[2]="activity"
names(tidydata)<-gsub("Acc","Accelerometer",names(tidydata))
names(tidydata)<-gsub("Gyro","Gyroscope",names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))

finaldata<-tidydata %>% group_by(subject,activity) %>% summarise_all(funs(mean))
write.table(finaldata,"FinalData.txt",row.name=FALSE)

str(finaldata)


