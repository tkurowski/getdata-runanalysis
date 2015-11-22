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

### How is the raw data organized?

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

## What is the clean data we want?

What we need is a:
<quote>
"_tidy data set with the average of each variable for each activity and each subject_"
</quote>

So, for each person and each activity they performed we must find the average
of `-mean()` and `-std()` variables.

#### Example
Let's suppose the person #5 did only three experiments (2 when SITTING
and 1 when LAYING) and that we're only interested in tBodyAcc-mean()-Y variable.
If the measurements for the variable were

    1 # for the first sitting experiment,
    3 # for the second sitting experiment and...
    2 # for the first and only laying experiment

then in our tidy data we expect to have

    # person_id, activity, time.body.acceleration.y_mean
    5, SITTING, 2
    5, LAYING, 2

