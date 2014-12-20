## Read in all relevant data files from working directory.
## Combine the training and test datasets with subject code and activity labels.
## Finally merged both training and test data to arrive at one dataset.
act_label = read.table("./UCI HAR Dataset/activity_labels.txt", sep = "")
features = read.table("./UCI HAR Dataset/features.txt", sep = "")

## Load training datasets.
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "")
y_train = read.table("./UCI HAR Dataset//train/y_train.txt", sep = "")
x_train = read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
## Load test datasets.
subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, 
                          sep = "")
y_test = read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
x_test = read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
## Step 1 - Combine training datasets and merged them to arrive at one merged 
## dataset.
comb_train = cbind(subject_train, y_train, x_train)
comb_test = cbind(subject_test, y_test, x_test)
merged_data = rbind(comb_train, comb_test)

## Step 2 - Extract only measurements on mean and std. deviation for each 
## measurement.
merged_extracted = merged_data[,c(1,2,3,4,5,6,7,8,43,44,45,46,47,48,83,84,85,
                                  86,87,88,123,124,125,126,127,128,163,164,
                                  165,166,167,168,203,204,216,217,229,230,
                                  242,243,255,256,268,269,270,271,272,273,
                                  347,348,349,350,351,352,426,427,428,429,
                                  430,431,505,506,518,519,531,532,544,545)]

## Step 3 - Use descriptive activity names to describe activities variable
## and removing the int labels.
merged_actdesc = merge(act_label,merged_extracted, by.x = "V1", by.y = "V1.1")
merged_actdesc[1] = NULL

## Step 4 - Appropriately name the variables with descriptive names from the 
## features table.
features_vec = as.vector(features[c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,
                          122,123,124,125,126,161,162,163,164,165,166,201,202,
                          214,215,227,228,240,241,253,254,266,267,268,269,270,
                          271,345,346,347,348,349,350,424,425,426,427,428,429,
                          503,504,516,517,529,530,542,543),2])
colnames(merged_actdesc) = c("ActivityLabels", "Subject", features_vec)

## Step 4 - Create second tidy dataset with average of each variable for each 
## activity and each subject. "SQLDF" package is used for grouping.
varnames = names(merged_actdesc)
colnames(merged_actdesc) = c("Act", "Sub", as.character(1:66))
install.packages("sqldf")
libarary(sqldf)
data_final = sqldf('select "Act", "Sub", avg("1"), avg("2"), avg("3"), avg("4"),avg("5"),
                   avg("6"), avg("7"), avg("8"), avg("9"),avg("10"), avg("11"), avg("12"),
                   avg("13"), avg("14"), avg("15"), avg("16"),avg("17"), avg("18"), 
                   avg("19"), avg("20"), avg("21"), avg("22"),avg("23"), avg("24"),
                   avg("25"), avg("26"), avg("27"), avg("28"),avg("29"), avg("30"),
                   avg("31"), avg("32"), avg("33"), avg("34"),avg("35"), avg("36"),
                   avg("37"), avg("38"), avg("39"), avg("40"),avg("41"), avg("42"),
                   avg("43"), avg("44"), avg("45"), avg("46"),avg("47"), avg("48"),
                   avg("49"), avg("50"), avg("51"), avg("52"),avg("53"), avg("54"),
                   avg("55"), avg("56"), avg("57"), avg("58"),avg("59"), avg("60"),
                   avg("61"), avg("62"), avg("63"), avg("64"),avg("65"), avg("66")
                   from merged_actdesc group by "Act", "Sub"')
colnames(data_final) = varnames

## Write out the final dataset to working directory.
write.table(data_final, file = "FinalData.txt", sep = " ", row.names = FALSE)

testRead = read.table("FinalData.txt", sep = "", header = TRUE)
