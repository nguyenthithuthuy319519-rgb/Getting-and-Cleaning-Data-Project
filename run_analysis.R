R
library(dplyr)

# 1. Merge training and test sets
# (Giả định dữ liệu đã được tải và giải nén trong thư mục làm việc)
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Sub <- rbind(subject_train, subject_test)

# 2. Extract mean and std
selected_features <- grep("-(mean|std)\\(\\)", features[,2])
X <- X[, selected_features]
names(X) <- features[selected_features, 2]

# 3. Use descriptive activity names
Y[,1] <- activities[Y[,1], 2]
names(Y) <- "activity"

# 4. Label data set
names(Sub) <- "subject"
TidyData <- cbind(Sub, Y, X)

# 5. Create second tidy data set with averages
FinalData <- TidyData %>% group_by(subject, activity) %>% summarise_all(mean)
write.table(FinalData, "FinalData.txt", row.name=FALSE)
