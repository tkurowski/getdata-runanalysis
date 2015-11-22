Study design
------------


Code book
---------


The instructions list
---------------------

PRE: The current directory is the one with `run_analysis.R` script

1. Download and unzip the data [_zip_ file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
In the current directory you should have a `UCI HAR Dataset` folder
with at least the follwing content:

        UCI HAR Dataset/
            activity_labels.txt
            features.txt
            test/
                subject_test.txt
                X_test.txt
                y_test.txt
            train/
                subject_train.txt
                X_train.txt
                y_train.txt

2. Open R console

        $ R

3. In R repl, source the `run_analysis.R` file

        > source('run_analysis.R')

4. If the data folder is `UCI HAR Dataset` in the current directory, you're
ready to go. Otherwise you may need to set the `DATA.DIR` to point to
the data directory.

        # e.g. if your current directory is the data directory itself,
        # you might do
        # > DATA.DIR = '.'

5. Call `run_analysis`

        > tidy.data <- run_analysis()

6. The tidy data is now yours to work on! For example, you might want to
save it:

        > write('tidy_data.txt', tidy.data, row.names = FALSE)

