library(plyr)
library(reshape2)

#
#   CONFIGURATION
#
#   Check README.md for the description of these configuration variables
#

HARDataSet.URL                      <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
HARDataSet.localPath                <- "UCI_HAR_Dataset.zip"
HARDataSet.columnNames.pattern      <- "-mean\\(\\)|-std\\(\\)"
HARDataSet.columnNames.fn           <- "UCI HAR Dataset/features.txt"
HARDataSet.activityLabels.fn        <- "UCI HAR Dataset/activity_labels.txt"
HARDataSet.training.subjects.fn     <- "UCI HAR Dataset/train/subject_train.txt"
HARDataSet.training.activities.fn   <- "UCI HAR Dataset/train/y_train.txt"
HARDataSet.training.measurements.fn <- "UCI HAR Dataset/train/X_train.txt"
HARDataSet.test.subjects.fn         <- "UCI HAR Dataset/test/subject_test.txt"
HARDataSet.test.activities.fn       <- "UCI HAR Dataset/test/y_test.txt"
HARDataSet.test.measurements.fn     <- "UCI HAR Dataset/test/X_test.txt"
HARDataSet.averages.fn              <- "averages.txt"


#
#   HELPER FUNCTIONS
#

#   Download the original zipped data set
downloadDataSetArchive <- function() {
    if (!file.exists(HARDataSet.localPath)) {
        cat(sprintf(
            paste(sep = "", collapse = "\n... ",
                  c("Downloading original data set",
                    "from source URL: %s",
                    "to local copy: %s ...")),
            HARDataSet.URL, HARDataSet.localPath))
        download.file(HARDataSet.URL, HARDataSet.localPath,
                      method    = "curl",
                      quiet     = TRUE)
        cat(" DONE\n")
    }
    else {
        cat(sprintf(
            paste(sep = "", collapse = "\n... ",
                  c("Local copy of the original data set already exists",
                    "at path: %s",
                    "DOWNLOAD SKIPPED\n")),
            HARDataSet.localPath))
    }
}

#   Load a data file from inside the .zip archive
loadFromArchive <- function(fn) {
    cat(sprintf("Loading '%s' from the original data set ...", fn))
    data <- read.table(unz(HARDataSet.localPath, fn))
    cat(" DONE\n")
    
    data
}

#   Load, fix and return the list of column names
loadColumnNames <- function() {
    as.character(loadFromArchive(HARDataSet.columnNames.fn)[, 2])
}

#   Load activity labels
loadActivityLabels <- function() {
    as.character(loadFromArchive(HARDataSet.activityLabels.fn)[, 2])
}

#   Return the indices of the column names to be used in the analysis
getColumnsOfInterest <- function(columnNames) {
    grep(pattern    = HARDataSet.columnNames.pattern,
         x          = columnNames)
}

#   keep only the columnsOfInterest from the measurement variables,
#   Load all six pieces of the original data set,
#   merge the six pieces together,
#   and return the result.
loadFilterAndMerge <- function(columnsOfInterest) {
    s_train <- loadFromArchive(HARDataSet.training.subjects.fn)
    y_train <- loadFromArchive(HARDataSet.training.activities.fn)
    X_train <- loadFromArchive(HARDataSet.training.measurements.fn)

    s_test  <- loadFromArchive(HARDataSet.test.subjects.fn)
    y_test  <- loadFromArchive(HARDataSet.test.activities.fn)
    X_test  <- loadFromArchive(HARDataSet.test.measurements.fn)

    rbind(
        cbind(s_train, y_train, X_train[, columnsOfInterest]),
        cbind(s_test,  y_test,  X_test[, columnsOfInterest]))
}

#   Return the descriptive variable names for the original column names
variableNames <- function(columnNames) {
    #   There are a few column names that have "BodyBody" in their name.
    #   Remove the repetition.
    columnNames <- sub("BodyBody", "Body", columnNames)
}
    
#   Label data set with descriptive column names and category labels
addLabels <- function(dataset, columnNames, activityLabels) {
    names(dataset)      <- c("Subject", "Activity", variableNames(columnNames))
    dataset$Activity    <- activityLabels[dataset$Activity]
    
    dataset
}
#   Create the tidy base data set by loading, filtering, merging and labeling
#   the original data set
createTidyBaseDataSet <- function() {
    allColumnNames      <- loadColumnNames()
    columnsOfInterest   <- getColumnsOfInterest(allColumnNames)
        
    addLabels(loadFilterAndMerge(columnsOfInterest),
              allColumnNames[columnsOfInterest],
              loadActivityLabels())
}

#   Calculate the averages per variable per subject in the data set
calculateAverages <- function(dataset) {
    cat("Calculating averages ...")
    moltenData  <- melt(dataset,
                        id.vars         = c("Subject", "Activity"),
                        variable.name   = "Variable",
                        value.name      = "Value")
    avg <- ddply(moltenData,
                 .(Subject, Activity, Variable),
                 summarize,
                 Average = mean(Value))
    cat(" DONE\n")
    
    avg
}

#   Save the data set as the final result
saveResult <- function(result) {
    cat(sprintf("Saving result to %s ...", HARDataSet.averages.fn))
    write.table(result, HARDataSet.averages.fn, row.names = FALSE)
    cat(" DONE\n")
}


#   Run the analysis:
#
#   1.  Download the original .zip archive if we do not have it yet
#   2.  Assemble our tidy base data set
#   3.  Calculate and save the averages
runAnalysis <- function() {
    downloadDataSetArchive()
    baseData <- createTidyBaseDataSet()
    averages <- calculateAverages(baseData)
    saveResult(averages)

    averages
}

HAR.averages <- runAnalysis()
