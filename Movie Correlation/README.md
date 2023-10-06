# Movie Correlation Project
This project analyzes a dataset of movies to explore the correlation between different movie features such as budget, gross revenue, and more.
The dataset used for this analysis is available at Kaggle.

## This code does the following:

1.Imports the required Python libraries: pandas, seaborn, matplotlib, and numpy.

2.Sets the default style for Matplotlib to 'ggplot' and the default figure size.

3.Reads the dataset from movies.csv into a Pandas DataFrame.

4.Iterates through each column in the DataFrame to calculate the percentage of missing values.

5.Removes rows with non-finite values in the 'budget' and 'gross' columns and converts these columns to the 'int64' data type.

6.Sorts the DataFrame by the 'gross' column in descending order.

7.Creates a regression plot using Seaborn to visualize the relationship between the 'budget' and 'gross' columns.

8.Generates a correlation matrix for numeric features and displays it as a heatmap.

9.Converts categorical columns into numeric values for further analysis.

## Output

The code will display visualizations, including a regression plot and a correlation matrix heatmap, to help you understand the relationships between different movie features.

The final DataFrame df_numerized contains numeric representations of the categorical columns and can be used for further analysis or modeling.
