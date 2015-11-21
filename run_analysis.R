DATA.DIR = 'UCI HAR Dataset' # the directory with the Samsung data

# Build a path to the given file.
# Args:
#       fname - file's base name
#       group - (optional) if given, the path will contain the group's
#               directory, and the group will be supplanted to fname
#               in place of '%s'
# Example:
# > path('features.txt') # '<DATA.DIR>/features.txt'
# > path('y_%s.txt', 'test') # returns '<DATA.DIR'>/test/y_test.txt'
path <- function (fname, group = NULL) {
    if (!is.null(group))
        fname <- file.path(group, sprintf(fname, group))
    file.path(DATA.DIR, fname)
}

# read given column in given file
read.col <- function (fname, colnum)
    read.table(path(fname), stringsAsFactors = FALSE)[,colnum]



# Read a complete data frame for given group ('test', 'train')
read.data <- function (group)
    cbind(read.table(path('subject_%s.txt', group)),
          read.table(path('y_%s.txt', group)),
          read.table(path('X_%s.txt', group)))

prettify <- function (s) {
    # tBodyAcc* -> t.Body.Acc* -> t.body.acc*
    s <- tolower(gsub('([A-Z])', '.\\1', s))
    # body.acc-mean()-.x -> body.acc.x_mean
    s <- sub('(.*)-mean\\(\\)-?(.*)','\\1\\2_mean', s, perl=TRUE)
    s <- sub('(.*)-std\\(\\)-?(.*)','\\1\\2_std', s, perl=TRUE)
    # clarify some abbreviations
    s <- sub('^t', 'time', s)
    s <- sub('^f', 'fft', s)
    s <- sub('\\.acc', '.acceleration', s)
    s <- sub('\\.mag', '.magnitude', s)
    # body.body -> body
    s <- sub('body\\.body', 'body', s)
}


run_analysis <- function () {
    # measurments labels (variable names) and activity labels
    features <- read.col('features.txt', 2)
    activity.labels <- read.col('activity_labels.txt', 2)

    # 1
    # merge training and test data to create one data set

    df <- rbind(read.data('train'), read.data('test'))
    #df <- read.data('test')

    # 2
    # extract only values of *-mean and *-std variables

    wanted.features <- grep('std\\(\\)|mean\\(\\)', features)
    df <- df[, c(1, 2, wanted.features + 2)] # 2 for 'subject' and 'activity'

    # we can as well forget the other features' names
    features <- features[wanted.features]
    
    # 4
    # appropriately label the data

    # (re)use measurments labels for measurments columns
    names(df) <- c("subject", "activity", prettify(features))

    # 3
    # use descriptive activity names

    # activity labels are in the second column in file activity_labels.txt
    # change df$activities to factor with activity.labels as levels:
    activity <- factor(df$activity)
    attr(activity, 'levels') <- activity.labels
    df$activity <- activity

    # 5
    # create a tidy data set with the average of each variable
    # for each activity and each subject

    aggregate(df[,3:ncol(df)], by=df[,1:2], mean)
    
    # with dplyr:
    # summarize_each(group_by(df, subject, activity), funs(mean))
}