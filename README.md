Getting and Cleaning Data Peer Assessment submission
====================================================

Introduction
------------

This is a submission for the course project of the
_Getting and Cleaning Data_ course of the _Data Scientist Specialization_
on [Coursera](https://www.coursera.org/).

The project uses the
[Human Activity Recognition Using Smartphones Data Set] [1]
from the article
_Human Activity Recognition on Smartphones
using a Multiclass Hardware-Friendly Support Vector Machine_ by
Davide Anguita, Alessandro Ghio, Luca Oneto,
Xavier Parra and Jorge L. Reyes-Ortiz [1]

The main goal of the project is to perform basic data obtaining and cleaning
tasks by creating a scirpt (`run_analysis.R`) that

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each
    measurement. 
3.  Uses descriptive activity names to name the activities in the data set.
4.  Appropriately labels the data set with descriptive variable names. 
5.  From the data set in step 4, creates a second, independent tidy data set
    with the average of each variable for each activity and each subject
    (`averages.txt`).


Files in this repository
------------------------

*   `README.md` --
    This file you're reading, containing the high-level information about the
    repository and the `run_analysis.R` script.
*   `CodeBook.md` --
    The code book containing the technical details about the cleaning and
    transforming of the original data set.
*   `averages.txt` --
    The average of each variable for each activity and each subject in the
    format described by `CodeBook.md`.
*   `run_analysis.R` --
    The _R_ script that generated the `averages.txt` output. This includes the
    complete pipeline from downloading the original dataset, tidying it up
    (according to `CodeBook.md`), to calculating and saving the contents of the
    final output, `averages.txt`.


Running the analysis
--------------------

The analysis can be executed with the `run_analysis.R` script. For the details
of all the data transformations that are performed on the original data and the
structure and meaning of the resulting data set, see the `CodeBook.md` in the
repository.

### Preparations

First, you have to obtain the script itself. A simple way to do it would be to
clone the [GitHub repository] [5] by executing the following in the directory
where you want to create the copy of the repository:

    git clone https://github.com/liptakmatyas/GetData_PeerAssessment

### Execution

#### In RStudio

In the [RStudio] [6] console navigate into the repository (e.g. by using
`setwd`), then `source` the analysis script to start the execution:

    > source('run_analysis.R')
    Downloading original data set
    ... from source URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    ... to local copy: UCI_HAR_Dataset.zip ... DONE
    Loading 'UCI HAR Dataset/features.txt' from the original data set ... DONE
    Loading 'UCI HAR Dataset/train/subject_train.txt' from the original data set ... DONE
    Loading 'UCI HAR Dataset/train/y_train.txt' from the original data set ... DONE
    Loading 'UCI HAR Dataset/train/X_train.txt' from the original data set ... DONE
    Loading 'UCI HAR Dataset/test/subject_test.txt' from the original data set ... DONE
    Loading 'UCI HAR Dataset/test/y_test.txt' from the original data set ... DONE
    Loading 'UCI HAR Dataset/test/X_test.txt' from the original data set ... DONE
    Loading 'UCI HAR Dataset/activity_labels.txt' from the original data set ... DONE
    Calculating averages ... DONE
    Saving result to averages.txt ... DONE

**NOTE**:
If you already have a local copy of the original data set, the beginning of the
output will reflect the fact that the download is being skipped:

    > source('run_analysis.R')
    Local copy of the original data set already exists
    ... at path: UCI_HAR_Dataset.zip
    ... DOWNLOAD SKIPPED

The rest of the output will not change.

#### From command line

Assuming you're already in the repository directory, the following command
executes the analysis script without using workspaces and exit after saving the
results, all this while omitting everything other than the script's own output:

    R --slave --vanilla -f run_analysis.R

The output will be similar as in RStudio (see above).

### Viewing the results

The results saved in `averages.txt` can be loaded back into _R_ and inspected the
usual way:

    data <- read.table("averages.txt", header = TRUE)
    names(data)
    str(data)
    head(data)
    View(data)

(Example based on [David's project FAQ] [4] on the Coursera forums.)


Configuration variables
-----------------------

There a few configuration variables defined at the beginning of the
`run_analysis.R` script:

*   `HARDataSet.URL` --
    The [URL] [2] of the `.zip` archive to download.
*   `HARDataSet.localPath` --
    The (path and) filename to use locally for the `.zip` archive.
*   `HARDataSet.columnNames.fn` --
    The (path and) filename within the `.zip` archive of the file that
    contains the mapping between the column numbers and column names (i.e.
    `features.txt`).
*   `HARDataSet.columnNames.pattern` --
    The column name patterns to be used for filtering the relevant columns.
    Should be configured based on the code book of the original dataset.
*   `HARDataSet.activityLabels.fn` --
    The (path and) filename within the `.zip` archive of the file that
    contains the mapping between the activity numbers and activity names (i.e.
    `activity_labels.txt`).
*   `HARDataSet.training.subjects.fn` --
    The (path and) filename within the `.zip` archive of the subjects in
    the training data set
*   `HARDataSet.training.activities.fn` --
    The (path and) filename within the `.zip` archive of the activities in
    the training data set
*   `HARDataSet.training.measurements.fn` --
    The (path and) filename within the `.zip` archive of the measurements in
    the training data set
*   `HARDataSet.test.subjects.fn` --
    The (path and) filename within the `.zip` archive of the subjects in
    the test data set
*   `HARDataSet.test.activities.fn` --
    The (path and) filename within the `.zip` archive of the activities in
    the test data set
*   `HARDataSet.test.measurements.fn` --
    The (path and) filename within the `.zip` archive of the measurements in
    the test data set
*   `HARDataSet.averages.fn` --
    The (path and) filename to use when saving the final tidy data set
    containing the averages.


References
----------

1.  Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L.
    Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass
    Hardware-Friendly Support Vector Machine. International Workshop of Ambient
    Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


[1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Human Activity Recognition Using Smartphones Data Set"
[2]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "Human Activity Recognition Using Smartphones Data Set / Coursera copy"
[3]: http://en.wikipedia.org/wiki/Zip_(file_format) "Zip (file format) / Wikipedia"
[4]: https://class.coursera.org/getdata-007/forum/thread?thread_id=49 "David's project FAQ"
[5]: https://github.com/liptakmatyas/GetData_PeerAssessment "GitHub repository"
[6]: http://www.rstudio.com/ "RStudio"

