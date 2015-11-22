Study design
------------


Code book
---------

### Tidy data

#### columns

There are 66 columns in the tidy data:

1. subject_id - (ordinal) integer (1 - 30)
2. activity - (categorical) character (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
3. to 66. _feature_* - (continuous) numeric

#### variables/features

The raw data provides many metrics (mean, std, max, min, etc.) for different features.
We're only interested in the _mean_ and _standard deviation (std)_ values.
And more precisely: in their averages.

_In the tidy dataset **each row concerns one unique (person, activity) pair**. For each such pair the
**average value of the features** across all 'raw' records for this (person, activity) pair is provided_.

The raw data dictionary (see "The instructions list" for how to obtain it) contains detailed info
about the variables, how they were obtained, and their units. 


##### names

The original feature names were changed to be more readable and more 'R-like'. In particular:

- CamelCase was changed to dot.separated.lowercase
- `-mean()` and `-std()` substrings were extracted from the middle and put at the end without parentheses (`abc-mean()-xyz` changes to `abc.xyz_mean`)
- some abbreviations were expanded (`acc` to `acceleration`, `t` to `time`, `f` to `fft` for Fast Fourier Transform domain)

```R
# in run_analysis.R lookup a prettify function to see how the original feature names are transformed
prettify <- function (s) { ... }
```

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

Please refer to the raw data documentation files `README.txt` and `features_info.txt` to find detailed
information about measurements.

As the tidy data takes averages of the measurments the units stay the same: in particular `gyro`
values are in `radians/sec`, acceleration values are in standard gravity units `g`.


### Cleaning of the data

Please refer to the [README.md](README.md) for more details on how the data is processed.

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

