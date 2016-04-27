library(plyr)

# Merging training and test 

xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
subjectTrain <- read.table("train/subject_train.txt")

xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
subjectTest <- read.table("test/subject_test.txt")

# x data frame
xData <- rbind(xTrain, xTest)

# y data frame
yData <- rbind(yTrain, yTest)

# subject data frame
subjectData <- rbind(subjectTrain, subjectTest)


# Extracting mean and standard deviation  measurements 

features <- read.table("features.txt")

# get only columns with mean() or std() in their names
meanStandardFeatures <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
xData <- xData[, meanStandardFeatures]

# correct the column names
names(xData) <- features[meanStandardFeatures, 2]


# Use descriptive activity 

activities <- read.table("activity_labels.txt")

# update values with correct activity names
yData[, 1] <- activities[yData[, 1], 2]

# correct column name
names(yData) <- "activity"

# Step 4
# Labeling data frame, changing column name

names(subjectData) <- "subject"

# bind all the data in a single data set
allData <- cbind(xData, yData, subjectData)


# Creating new tidy data frame averaging variables
# columns rearanging
tidy <- ddply(allData, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy, "tidy.txt", row.name=FALSE)