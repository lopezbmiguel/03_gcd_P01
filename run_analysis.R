##### Dependencies ####
require(plyr)

##### Get list of test and train files ######

test_path = "UCI HAR Dataset/test/"
train_path = "UCI HAR Dataset/train/"
test_files <- list.files(path=test_path,pattern="*.txt", recursive = FALSE)
train_files <- list.files(path=train_path,pattern="*.txt", recursive = FALSE)

##### Read label files ######

labels_path = "UCI HAR Dataset/"
assign(sub(".txt", "", "activity_labels"), read.table(paste(labels_path,"activity_labels.txt",sep=""), as.is = TRUE, header = FALSE))
assign(sub(".txt", "", "features"), read.table(paste(labels_path,"features.txt",sep=""), as.is = TRUE, header = FALSE))

#### Rename columns from label files for later use #####

colnames(activity_labels) <- c("activity_id", "activity")
colnames(features) <- c("feature_id", "feature")

#### Read Test and train Files #####

for (i in test_files)
{
  
assign(sub(".txt", "", i), read.table(paste(test_path,i,sep=""), as.is = TRUE, header = FALSE))
    
}

for (i in train_files)
{
  
  assign(sub(".txt", "", i), read.table(paste(train_path,i,sep=""), as.is = TRUE, header = FALSE))
  
}


##### Assign variable names to test and train data ######

colnames(X_test) <- c(features$feature)
colnames(X_train) <- c(features$feature)
colnames(y_test) <- c("activity_id")
colnames(y_train) <- c("activity_id")
colnames(subject_test) <- c("subject")
colnames(subject_train) <- c("subject")

#### Adds subject and activity_id's to each dataset ####

full_data_test <- cbind(X_test, y_test, subject_test)
full_data_train <- cbind(X_train, y_train, subject_train)

#### Label datasets as test or train #####

full_data_test$data_segment <- c("test")
full_data_train$data_segment <- c("train")

#### Merge vertically both datasets #####

full_data <- rbind(full_data_test, full_data_train)

#### Add Activity Labels ####

full_data <- merge(full_data, activity_labels, by = "activity_id")

##### Extract mean and standard deviation measures ####

columns<- grep("mean[^Freq]|std", colnames(full_data), value = TRUE)
tidy_dataset <- full_data[,c(columns, "activity", "subject","data_segment")]

##### Rename variables #####

colnames(tidy_dataset)<-gsub("\\(\\)","",colnames(tidy_dataset))
colnames(tidy_dataset)<-gsub("^t","Time",colnames(tidy_dataset))
colnames(tidy_dataset)<-gsub("^f","Frequency",colnames(tidy_dataset))
colnames(tidy_dataset)<-gsub("Acc","Accelerometer",colnames(tidy_dataset))
colnames(tidy_dataset)<-gsub("Gyro","Gyroscope",colnames(tidy_dataset))
colnames(tidy_dataset)<-gsub("Mag","Magnitude",colnames(tidy_dataset))
colnames(tidy_dataset)<-gsub("-mean","Mean",colnames(tidy_dataset))
colnames(tidy_dataset)<-gsub("-std","StDeviation",colnames(tidy_dataset))

###### Change from wide dataset to long dataset #####

long_dataset <- reshape(tidy_dataset, varying=colnames(tidy_dataset[1:66]),v.names="measure",timevar = "variable",
                        times = colnames(tidy_dataset[1:66]), direction = "long")

#### Generates and exports final dataset #####

final_dataset <- ddply(long_dataset,c("activity","subject","variable"),summarize,average = mean(measure))
write.table(final_dataset,"tidy_data.txt",row.names = FALSE)

