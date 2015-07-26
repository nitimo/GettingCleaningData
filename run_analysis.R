setwd("./github/gettingcleaningdata/getdata-projectfiles-UCI HAR Dataset")

features <-read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

# Training set
setwd("./train/")
x_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
subject_train<-read.table("subject_train.txt")
# Test set
setwd("../test")
x_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")
subject_test<-read.table("subject_test.txt")

# Stack training on top of test
x <-rbind(x_train, x_test)
y <-rbind(y_train, y_test)
subject <-rbind(subject_train, subject_test)

# Uses descriptive activity names to name the activities in the data set
y <-merge(activity_labels, y, by="V1")

# Appropriately labels the data set with descriptive variable names.
names(x) <- features$V2

# Extracts only the measurements on the mean and standard deviation for each 
# measurement. 
mean_names<-grep(glob2rx("*mean()*"), names(x), value = TRUE)
std_names<-grep(glob2rx("*std()*"), names(x), value=TRUE)
x<-x[,c(mean_names, std_names)]


# Merges the training and the test sets to create one data set.
tidy_data <- cbind(y$V2, subject, x)
names(tidy_data)[1:2] <- c("Activity", "Subject")


# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
s <- split(tidy_data, list(tidy_data$Activity, tidy_data$Subject), drop=TRUE)
tidy_data_summary <- sapply(s, function(x) colMeans(x[, c(mean_names, std_names)], na.rm=TRUE))
