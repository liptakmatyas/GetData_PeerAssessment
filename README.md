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


Viewing the results
-------------------

The results saved in `averages.txt` can be loaded back into _R_ and inspected the
usual way:

    data <- read.table("averages.txt", header = TRUE)
    names(data)
    str(data)
    head(data)
    View(data)

(Example based on [David's project FAQ] [4] on the Coursera forums.)


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
