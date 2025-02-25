
* -----------------------------------------------------
* Basic Stata Commands and Knowledge for New Users
* -----------------------------------------------------

* Clear the current environment (important when starting fresh)
clear all

* Stop Stata from pausing when output is long (e.g., large tables)
set more off

* -----------------------------------------------------
* Loading Built-in Data
* -----------------------------------------------------

* Load a built-in dataset provided by Stata (e.g., auto dataset)
sysuse auto

* Check the first few rows of the dataset
list in 1/10

* Show the structure of the dataset, including variable names, storage types, and labels
describe

* View the names and types of the variables, along with the total number of observations
codebook

* -----------------------------------------------------
* Understanding Variables and Data Structure
* -----------------------------------------------------

* Get a summary of all variables in the dataset (mean, std dev, min, max)
summarize

* Get summary statistics for specific variables (price, weight, mpg)
summarize price weight mpg

* -----------------------------------------------------
* Variable Labels and Value Labels
* -----------------------------------------------------

* Display the variable labels in the dataset
label list

* Display labels associated with variables (e.g., foreign cars)
label list foreign

* List the unique values and their frequency for a categorical variable (foreign)
tabulate foreign

* -----------------------------------------------------
* Data Inspection: Simple and Structured Data Views
* -----------------------------------------------------

* List specific variables for the first 10 observations (make, price, mpg)
list make price mpg in 1/10

* Find summary statistics broken down by a category (e.g., summarize by foreign)
bysort foreign: summarize price mpg

* -----------------------------------------------------
* Sorting and Organizing Data
* -----------------------------------------------------

* Sort the data by the price variable in ascending order
sort price

* Display the first 10 observations sorted by price
list make price mpg in 1/10

* Sort the data by price in descending order (using gsort)
gsort -price

* Display the first 10 observations after sorting in descending order
list make price mpg in 1/10

* -----------------------------------------------------
* Basic Graphs and Data Visualization
* -----------------------------------------------------

* Create a scatter plot of price vs. weight
scatter price weight

* Create a histogram of mpg (miles per gallon)
histogram mpg

* -----------------------------------------------------
* Saving and Exporting Data
* -----------------------------------------------------

* Save the dataset in Stata format with a new name
save auto_copy.dta, replace

* Export the dataset to a CSV file
export delimited using "auto_data.csv", replace

* -----------------------------------------------------
* Basic File Management
* -----------------------------------------------------

* Check the current working directory
pwd

* Change the working directory (use your desired folder path)
cd "C:/Your/Desired/Directory"

* List all the files in the current working directory
dir

* -----------------------------------------------------
* Help and Resources
* -----------------------------------------------------

* Get detailed help on any Stata command (e.g., summarize)
help summarize

* Search for commands or functions related to specific tasks (e.g., regression)
search regression

* -----------------------------------------------------
* Conclusion of Basic Stata Commands
* -----------------------------------------------------

* This session covered essential Stata operations:
* - Loading data (`sysuse`)
* - Inspecting datasets (`describe`, `codebook`, `summarize`)
* - Sorting data (`sort`, `gsort`)
* - Simple graphs (`scatter`, `histogram`)
* - Managing files and directories (`save`, `export`, `pwd`, `cd`)
* - Using Stata's help system (`help`, `search`)
* -----------------------------------------------------






* -----------------------------------------------------
* Introduction to Data Manipulation in Stata
* -----------------------------------------------------

clear all
set more off

* Load the built-in dataset
sysuse auto

* Inspect the data
list in 1/10

* -----------------------------------------------------
* Part 1: Renaming Variables
* -----------------------------------------------------

* Rename mpg to Miles_Per_Gallon
rename mpg Miles_Per_Gallon

* Inspect the first few rows to check the new variable name
list make Miles_Per_Gallon in 1/10

* -----------------------------------------------------
* Part 2: Filtering Data (using `keep` and `drop`)
* -----------------------------------------------------

* Keep cars with more than 3 cylinders (equivalent to filter() in R)
keep if rep78 > 3

* List the first few rows after filtering
list make rep78 in 1/10

* drop variables that you won't use

drop foreign gear_ratio


* -----------------------------------------------------
* Part 3: Creating and Modifying Variables (equivalent to mutate() in R)
* -----------------------------------------------------

* Create a new variable: price per weight (price/weight)
gen price_per_weight = price / weight

* List the first few rows to check the new variable
list make price weight price_per_weight in 1/10

* -----------------------------------------------------
* Creating Multiple Variables
* -----------------------------------------------------

* Create two new variables:
* 1. price per weight (price/weight)
* 2. mpg_class: classify as "Efficient" if Miles_Per_Gallon > 20, otherwise "Non-efficient"
gen price_per_weight = price / weight
gen mpg_class = cond(Miles_Per_Gallon > 20, "Efficient", "Non-efficient")

* List the first few rows to check both variables
list make price_per_weight mpg_class in 1/10

* -----------------------------------------------------
* Conditional Mutate with `gen` and `cond()` (Equivalent to `case_when()` in R)
* -----------------------------------------------------

* Classify cars based on their weight using cond():
* Light (<2500), Medium (2500-3500), Heavy (>3500)
gen weight_class = cond(weight < 2500, "Light", cond(weight >= 2500 & weight < 3500, "Medium", "Heavy"))

* List the first few rows to check the new classifications
list make weight weight_class in 1/10

* -----------------------------------------------------
* Modifying Existing Variables
* -----------------------------------------------------

* Modify the price variable by creating a new categorical variable
* Classify price into categories "Low", "Medium", "High"
gen price_class = cond(price > 10000, "High", cond(price > 5000 & price <= 10000, "Medium", "Low"))

* List the first few rows to check the new variable
list make price price_class in 1/10

* -----------------------------------------------------
* Working with Multiple Variables
* -----------------------------------------------------

* Apply the `egen` function to calculate the row-wise mean of mpg and weight

* The term row-wise mean refers to calculating the mean (average) for each row of 
* specific columns in a dataset, rather than calculating the mean across the entire 
* column (which would be a column-wise mean). In other words, instead of computing a single
* average for all values in a variable, you compute the mean for a group of variables 
* within each observation (row).

egen mean_mpg_weight = rowmean(Miles_Per_Gallon weight)

* List the first few rows to check the new variable
list make Miles_Per_Gallon weight mean_mpg_weight in 1/10


* This variable mean_mpg_weight is not meaningful here, but just immagine that you want to calculate
* someone's average working hours within 3 days 
* Each row of data is one person, and you have variables Day1 Day2 and Day3 that records how many hours
* each person works in one day
* the code here will be:

egen mean_work_hours = rowmean(Day1 Day2 Day3)


* -----------------------------------------------------
* Conclusion: Key Stata Functions Demonstrated
* - rename: to rename variables
* - keep: to filter rows based on conditions
* - gen: to create new variables
* - egen: to perform calculations across variables
* - cond(): to apply conditional logic
* - drop: to remove variables
* -----------------------------------------------------
