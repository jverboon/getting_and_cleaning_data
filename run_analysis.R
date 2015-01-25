## from workinging directory containing the UCI HAR Dataset

require(plyr)


## read in important datasets

features <- read.table("./UCI HAR Dataset/features.txt", colClasses = c("character"))
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", colClasses = c("character"))
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", colClasses = c("character"))

## give appropriate headers to columns (variables)

colnames(X_train) = features[,2]
colnames(X_test) = features[,2]
colnames(y_test) = "label"
colnames(y_train) = "label"
colnames(subject_train) = "subject"
colnames(subject_test) = "subject"
colnames(activity_labels) = c("label", "activity")

## replace the activity index with the activity name
y_test <- merge(activity_labels, y_test, by = "label", all.x = T, all.y = T)
y_train <- merge(activity_labels, y_train, by = "label", all.x = T, all.y = T)

## combine data.frames

train <- cbind(subject_test, y_test, X_test)
test <- cbind(subject_train, y_train, X_train)
full <- rbind(test, train)

## extracts only measurements on the mean and std (and subject and activity)
full_mean_std <- full[,grepl("mean|std|subject|activity", names(full))]

## remove the parentheses, dashes to underscores
colnames(full_mean_std) <- gsub('\\(|\\)',"",names(full_mean_std))
colnames(full_mean_std) <- gsub('-',"_",names(full_mean_std))

## tidy data set with average of each variable for each activity and each
## subject
tidy <- ddply(full_mean_std, c("subject","activity"), numcolwise(mean))
write.table(tidy, file = "tidy.txt", row.name = FALSE)
