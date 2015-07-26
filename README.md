# Script explanation

The scrpit requires the plyr library, and to have the data unzipped in the working directory with the same file structure (folders and file names).

The script performs the following operations:

1. Get the list of files in the working directory.
2. Read each file in the memory, except for readme / explanation files and the intertial data.
3. Merge test and train datasets together.
4. Label the variables measured and the activities performed
5. Create a new dataset with the variables measured as mean or standard deviation, as well as the subject and the activity that corresponds to each vector of measurements
6. Reshape the dataset to long version
7. Summarize the dataset by calculating the average per activity, subject, variable
8. Create a new file with the name "tidy_data.txt" that contains the summarized dataset


