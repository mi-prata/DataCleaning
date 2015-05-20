#######      Code by Miguel Prata     #######
setwd("~/Dropbox/Minhas/Coursera/Data Science Specialization/3 - Getting and Cleaning Data/project")
library(dplyr)

###Importing the data <- must be extracted in the working directory
#Features
features = tbl_df(read.table("./UCI\ HAR\ Dataset/features.txt"))
features <- as.character(features$V2)
#Test data
Xtest = tbl_df(read.table("./UCI\ HAR\ Dataset/test/X_test.txt"))
ytest = tbl_df(read.table("./UCI\ HAR\ Dataset/test/y_test.txt"))
subject_test = tbl_df(read.table("./UCI\ HAR\ Dataset/test/subject_test.txt"))

#Train data
Xtrain = tbl_df(read.table("./UCI\ HAR\ Dataset/train/X_train.txt"))
ytrain = tbl_df(read.table("./UCI\ HAR\ Dataset/train/y_train.txt"))
subject_train = tbl_df(read.table("./UCI\ HAR\ Dataset/train/subject_train.txt"))

#Creating a test and train data tbls
subject_test <- rename(subject_test, SubjectNumber = V1)
ytest <- rename(ytest, Activity = V1)

subject_train <- rename(subject_train, SubjectNumber = V1)
ytrain <- rename(ytrain, Activity = V1)

myTestData <- tbl_df(bind_cols(subject_test,ytest,Xtest))
myTrainData <- tbl_df(bind_cols(subject_train,ytrain,Xtrain))

#1 - Merges the training and the test tbls to create one data set
merged <- bind_rows(myTestData, myTrainData) 

#4 - Appropriately labels the data set with descriptive variable names. 
ColunmnNames <- append(features,c("SubjectNumber","Activity"),0)
#Remove invaled characters from variable names and name the columns
holder <- make.names(ColunmnNames, unique = TRUE)
names(merged) <- holder

#3 - Uses descriptive activity names to name the activities in the data set
merged$Activity <- replace(as.character(merged$Activity), merged$Activity == 1, "Walking")
merged$Activity <- replace(as.character(merged$Activity), merged$Activity == 2, "Walking Upstairs")
merged$Activity <- replace(as.character(merged$Activity), merged$Activity == 3, "Walking Downstairs")
merged$Activity <- replace(as.character(merged$Activity), merged$Activity == 4, "Sitting")
merged$Activity <- replace(as.character(merged$Activity), merged$Activity == 5, "Standing")
merged$Activity <- replace(as.character(merged$Activity), merged$Activity == 6, "Lying")

#2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
extracted <- tbl_df(select(merged, SubjectNumber, Activity, contains(".mean."),contains(".std.")))

#5 Creates a tidy data set with the average of each variable for each activity and each subject.
tidy <- tbl_df(extracted %>%group_by(SubjectNumber, Activity) %>% summarise_each(funs(mean)))
write.table(tidy, "mydata.txt",row.name=FALSE)
