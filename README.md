# getdata-runanalysis
Getting and Cleaning Data Course Project

This project contains R code tidying data from [Human Activity Recognition Using Smartphones]
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

About the data
--------------

In the experiment 30 _subjects_ (volunteers) performed six kinds of _activites_
(walking, sittings, etc.). With smartphones, they wore on the waist, certain
measurements were taken.

Conceptually, the data constitute a table:

    | subject_id | activity | <feature_1> | <feature_2> | ... 
    ---------------------------------------------------------
    |     1      | walking  |  2.57e-001  |  2.33e-002  | ...

Each _record_ concerns a given person performing a given activity and
it contains 561 measurements of certain _variables_ (_features_), e.g.
body linear acceleration, angular velocity etc.

### How the raw data is organized

The data is organized in files that fall into 2 groups:

1. metadata files - contain information about variable names and activity labels
2. data files - contain actual data

The second group is further divided into _test_ and _train_ sets.

Each set contains files about: a subject, an activity performed and the measured values.
In the files each one line provides data on one record.

Let's have a look at the first lines of the 'train' files:

    # head -1 train/subject_train.txt
    1

This means that the very first record (of the 'train' group) concerns
a person of id 1.

    # head -1 train/y_train.txt
    5

This person's performing activity 5 which (according to `activity_labels.txt`)
is STANDING

    # head -1 train/X_train.txt
    2.8858451e-001 -2.0294171e-002 -1.3290514e-001 ...

These are the actual measurements (for person 5 standing); what's exactly been
measured?

    # head -4 features.txt
    1 tBodyAcc-mean()-X
    2 tBodyAcc-mean()-Y
    3 tBodyAcc-mean()-Z
    ...

We see the first three measurements are the mean values of body acceleration along
X, Y and Z axis respectively.

### What is the tidy data we want?

What we need is a:
<quote>
"_tidy data set with the average of each variable for each activity and each subject_"
</quote>

So, for each person and each activity they performed we must find the average
of `-mean()` and `-std()` variables.

#### Example - variables we're interested in

    # mean value of acceleration of the body in time domain along x axis
    tBodyAcc-mean()-X
    
    # standard deviation of gravity acceleration along z axis
    tGravityAcc-std()-Z


#### Example - variables we discard

    # maximum value of acceleration of the body in time domain along x axis
    tBodyAcc-max()-X
    
    # minimum value of gravity acceleration along z axis
    tGravityAcc-min()-Z

#### Tidy data columns

1. subject_id - as integer (e.g 3)
2. activity - as character (e.g. "WALKING")
3. _feature_* - as numeric (e.g -0.3816)

#### variables/features

The raw data provides many metrics for different features (mean, std, max, min, ...).
We're only interested in the _mean_ and _standard deviation (std)_ values.
And more precisely: in their averages.

##### names

The variables in the tidy data have labels of the following form:

    <domain>.<signal-group>.<physical-quantity>[.<aspect>][.<axis>]_<metric>

Where:

- domain - `time` for time domain or `fft` for values obtained by applying Fast Fourier Transform
- signal-group - `body` or `gravity`
- physical-quantity/sensor - `acceleration` (`accelerometer`) or `gyroscope` 
- aspect - `magnitue` or `jerk`
- axis - `x`, `y` or `z`
- metric - `mean` or `std`

##### units

`gyro` values are in `radians/sec`. Acceleration values are in standard gravity units `g`.

**Detailed information about the data is distributed with the raw data itself**


#### Example - tidy data
Let's suppose the person #5 did only three experiments (2 when SITTING
and 1 when LAYING) and that we're only interested in `tBodyAcc-mean()-Y` variable.
If the measurements for this variable were:

    1 # for the first sitting experiment,
    3 # for the second sitting experiment and...
    2 # for the first and only laying experiment

then in our tidy data we expect to have:

    # subject_id, activity, time.body.acceleration.y_mean
    5, SITTING, 2
    5, LAYING, 2



The code
--------

The code does what follows:

- reads the data and metadata files
```R
# Read a complete data frame for given group ('test', 'train')
read.data <- function (group)
    cbind(read.table(path('subject_%s.txt', group)),
          read.table(path('y_%s.txt', group)),
          read.table(path('X_%s.txt', group)))
```
- combines the data into one data.frame
```R
df <- rbind(read.data('train'), read.data('test'))
```
- selects only the interesing (`mean` and `std`) columns
```R
wanted.features <- grep('std\\(\\)|mean\\(\\)', features)
df <- df[, c(1, 2, wanted.features + 2)] # 2 for 'subject' and 'activity'
```
- "prettifies" column labels, puts explicit action labels (e.g. "STANDING" instead of 5)
```R
names(df) <- c("subject", "activity", prettify(features))
```
- groups the data by (subject, activity) and for each such group computes the average (mean)
  of the chosen features.
```R
aggregate(df[,3:ncol(df)], by=df[,1:2], mean)
    
# with dplyr:
# summarize_each(group_by(df, subject, activity), funs(mean))
```
_More details about how the code works on the data can be found in the [CodeBook](CodeBook.md)_

### Running the code

All the R code that transforms the raw data (files) into the tidy data (R frame)
lives in `run_analysis.R`.

```R
source('run_analysis.R')
```

The actual work is done within `run_analysis` function.
This function (and some other helper functions) use `DATA.DIR` variable
to find data files.
By default it points to `"UCI HAR Dataset"` folder in current directory:

```R
# DATA.DIR = 'UCI HAR Dataset' # the directory with the Samsung data
```

To clean the data call the `run_analysis` function

```R
tidy.data <- run_analysis()

# We can save tidy data to file
write.table(tidy.data, "tidy.txt", row.names = FALSE)
```
