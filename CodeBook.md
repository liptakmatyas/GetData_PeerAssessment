Code Book
=========

Introduction
------------

This is the code book for the course project of the _Getting and Cleaning Data_
course of the _Data Scientist Specialization_ on
[Coursera](https://www.coursera.org/).

The project uses the
[Human Activity Recognition Using Smartphones Data Set] [1]
from the article
_Human Activity Recognition on Smartphones
using a Multiclass Hardware-Friendly Support Vector Machine_ by
Davide Anguita, Alessandro Ghio, Luca Oneto,
Xavier Parra and Jorge L. Reyes-Ortiz [1]

The description of the original data set can be found in the `README.txt` and
`features_info.txt` files of the [original archive] [2].

This document describes the `averages.txt` file in detail.

The configuration variables referenced in this documents are described in the
`README.md` file of this project.


Contents of the data set
------------------------

The `averages.txt` file contains a tidy thin-and-tall data set, which stores
the average of each variable for each activity and each subject of the original
data set, taking only the "interesting" columns into account. The "interesting"
columns were defined as _"the mean and standard deviation for each
measurement"_.


Structure of the data set
-------------------------

The data set in `averages.txt` contains 4 variables:

*   `Subject`:
    The integer label of the subject.
*   `Activity`:
    One of the string labels from the `activity_labels.txt` file in the
    original archive indicating the type of activity:
    *   `WALKING`
    *   `WALKING_UPSTAIRS`
    *   `WALKING_DOWNSTAIRS`
    *   `SITTING`
    *   `STANDING`
    *   `LAYING`
*   `Variable`:
    The name of the measurement variable in the original data set. It will be
    one of the column names listed in the `features.txt` file of the original
    archive.
*   `Average`:
    The average value of the given variable for the given activity for the
    given subject.


Interpretation of the variable names
------------------------------------

The interpretation of the measurement variable names is based on their
components:

*   The first character of the name of the variable is the _domain_:
    *   `f` -- in the frequency domain
    *   `t` -- in the time domain
*   Next comes the _signal_:
    *   `BodyAcc`       -- body linear acceleration
    *   `BodyGyro`      -- body angular velocity
    *   `GravityAcc`    -- gravity linear acceleration
*   After the signal there can be optional _derived value_:
    *   `Jerk`  -- jerk
    *   `Mag`   -- magnitude
*   Because we are only interested in columns that contain summarized values,
    the column label will contain one of these _summary functions_,
    configured in the `HARDataSet.columnNames.pattern` configuration variable:
    *   `-mean()`   -- Mean of the
    *   `-std()`    -- Standard deviation of the
*   Finally, the variable name can optionally end in an _axis_:
    *   `-X` -- on the X axis
    *   `-Y` -- on the Y axis
    *   `-Z` -- on the Z axis

**NOTE:**
There are some variable names which contain `BodyBody` in their _signal_
component. These are treated as containing only `Body`, i.e. the repetition is
removed.

Then, these parts are assembled in the following order:

1.  Summary function
2.  Signal
3.  Derived values
4.  Axis
5.  Domain

For example:
`tBodyAccJerk-mean()-X` translates into
_"Mean of the body linear acceleration jerk on the X axis in the time domain"_.


Processing steps
----------------

The processing is done by the `run_analysis.R` script.

### Obtaining the original data

The original data set is available from the [Machine Learning Repostiory] [1],
as well from the [course resources] [2]. The `run_analysis.R` script uses the
latter to download the original data set. The data set is archived in [zip] [3]
format. 

The `downloadDataSetArchive` function will check if the archive already exists,
and downloads it from the configured URL if it is missing. If the file already
exists, it will not be changed.

**NOTE:**
If you want to download the original archive again, you have to delete the
local copy manually.

Relevant configuration variables:

*   `HARDataSet.URL`
*   `HARDataSet.localPath`


### Columns of interest

Instead of hard-coding the list of columns that contain the relevan mean and
standard deviation values, we will utilize the metadata that is available in
the original archive and hard-code only the high-level infomation contained in
the code book of the original data set, `features_info.txt`.

The values we're interested in are stored in columns having "`-mean()`" or
"`-std()`" in their names. The parenthesis are important, otherwise some
unwanted columns end up in our tidy data set, e.g. `-meanFreq()`. The
`features.txt` file in the original archive contains the mapping between the
column numbers and names. This text file contains one mapping per line, where
the column number and the column name are separated by a single space.

The `loadColumnNames` function loads this mapping and returns a simple vector
of the column names, where the index of a column name is its index in the data
sets.

The `getColumnsOfInterest` function returns a vector of column numbers that
correspond to the complete list of columns that we are interested in our
analysis. This list will be the result of filtering the names of the columns
for the configured patterns, i.e. `-mean()` or `-std()`, and returning the
indices of the matching columns. The returned list can be used to index the
columns of the original data set to narrow it down to only the part to be
analyzed.

Relevant configuration variables:

*   `HARDataSet.columnNames.fn`
*   `HARDataSet.columnNames.pattern`


### Loading, filtering, merging the original data sets

The original archive contains two separate data sets: one for training and one
for testing. We need one data set to do our analysis, thus we have to merge the
training and testing data sets. Both data sets are in the same format and share
the same columns, although they differ in the number of rows. Both the training
and the testing data sets are further split into three pieces, making it a
total of six:

*   the subjects of the training data set, `s_train`
*   the activities of the training data set, `y_train`
*   the measurements of the training data set, `X_train`
*   the subjects of the test data set, `s_test`
*   the activities of the test data set, `y_test`
*   the measurements of the test data set, `X_test`

There are 561 measurements in both the training and the testing data set, but
we are only interested in a subset of them.  The "uninteresting" columns will
be removed from the `X_train` and `X_test` data sets.

After the measuerement columns have been filtered, the six pieces are merged
together the following way:

*   The order of the rows within each data set is not changed.
*   All the rows of the training data set are at the beginning and all the rows
    of the test data set come after.
*   The first column will be the `Subject`.
*   The second column will be the `Activity`.
*   The rest of the columns will contain the (filtered) measurement variables.

<pre>
     Subject | Activity | tBodyAcc-mean()-X | ... | fBodyBodyGyroJerkMag-std() 
    ---------+----------+-------------------+-...-+----------------------------
        .    |     .    |                      .
        .    |     .    |                      .
        .    |     .    |                      .
             |          |
     s_train |  y_train |             ...   X_train   ...
             |          |
        .    |     .    |                      .
        .    |     .    |                      .
        .    |     .    |                      .
    ---------+----------+-------------------+-...-+----------------------------
        .    |     .    |                      .
        .    |     .    |                      .
        .    |     .    |                      .
      s_test |  y_test  |             ...    X_test   ...
        .    |     .    |                      .
        .    |     .    |                      .
        .    |     .    |                      .
</pre>

The `loadFilterAndMerge` function loads all three components of both data sets,
keeps only the "interesting" columns of the measurements, as indicated by the
`columnsOfInterest` parameter, and returns the result of merging these six
pieces together into a single data set as described above.

Relevant configuration variables:

*   `HARDataSet.training.subjects.fn`
*   `HARDataSet.training.activities.fn`
*   `HARDataSet.training.measurements.fn`
*   `HARDataSet.test.subjects.fn`
*   `HARDataSet.test.activities.fn`
*   `HARDataSet.test.measurements.fn`


### Labeling the data sets

The `addLabels` function takes a merged data set and returns the same data set
after assigning descriptive labels to its components:

*   The first column gets the label `Subject`.
*   The second column gets the label `Activity`.
*   The measurement variables (i.e. columns 3+) will be labelled with the
    descriptive variable names based on the ones used in the original data set.
*   The activities in the second column of each row will be represented by
    their human-readable labels.

#### Variable names

The `variableNames` function performs the assignment of the descriptive
variable names by fixing the repetative `BodyBody` substrings in some of the
variable names by replacing them with a single occurence of `Body`.

#### Activity labels

The different activities (e.g. "walking", "standing") are indicated by
numerical labels in the data set. To provide human readable representation for
the activities in our final data set, we will utilize the `activity_labels.txt`
file from the original archive. This text file contains the mapping between the
numerical activity labels used in the data sets and their corresponding
human-readable textual labels.

The `loadActivityLabels` function loads this mapping and returns a simple
vector of the textual labels, where the index of the label is its numerical
representation in the data sets.

Relevant configuration variables:

*   `HARDataSet.activityLabels.fn`


### Calculating the averages

The `calculateAverages` function first melts the merged data set based on the
two levels of subjects and activities, then it summarizes the melted data
for each variable for each activity for each subject by calculating the `mean`
using the `ddply` function.


### Saving the result

The final output of the project is a tidy data file with the average of each
variable for each activity and each subject. The `saveResult` function saves
the received data set in a plain text file using the `write.table` function.

Relevant configuration variables:

*   `HARDataSet.averages.fn`


References
----------

1.  Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L.
    Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass
    Hardware-Friendly Support Vector Machine. International Workshop of Ambient
    Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


[1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Human Activity Recognition Using Smartphones Data Set"
[2]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "Human Activity Recognition Using Smartphones Data Set / Coursera copy"
[3]: http://en.wikipedia.org/wiki/Zip_(file_format) "Zip (file format) / Wikipedia"

