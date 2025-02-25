* -----------------------------------------------
* DO-FILE: summary_and_regression_tables.do
* Description: Generate summary statistics and regression tables using esttab and outreg2
* Author: Wali Reheman
* Date: 2024-10-04
* -----------------------------------------------
* -----------------------------------------------
* -----------------------------------------------
* DO-FILE: summary_and_regression_outreg2_v2.do
* Description: Generate summary statistics and regression tables using outreg2, following the guidelines from the PDF.
* -----------------------------------------------

* 1. Load the necessary package for outreg2
ssc install outreg2, replace

* 2. Load example dataset 'auto' provided by Stata
sysuse auto, clear

* -----------------------------------------------
* PART 1: Summary Statistics using outreg2
* -----------------------------------------------

* Use outreg2 to generate summary statistics for all variables in the dataset. 
* The option 'sum(log)' is used to summarize all variables.

outreg2 using "summary_stats_all.doc", replace sum(log)

* Next, generate summary statistics for selected variables only.
* We will keep 'price', 'mpg', and 'weight'.

outreg2 using "summary_stats_selected.doc", replace sum(log) ///
    keep(price mpg weight)

* -----------------------------------------------
* PART 2: Regression Models using outreg2
* -----------------------------------------------

* Regress 'price' on 'mpg' and 'weight', and save the results to a Word file.
regress price mpg weight

outreg2 using "regression_results.doc", replace ctitle(Model 1) label

* Now, add the 'foreign' variable to the model.
regress price mpg weight foreign
outreg2 using "regression_results.doc", append ctitle(Model 2) label

* Add 'length' to the model as the third regression.
regress price mpg weight foreign length
outreg2 using "regression_results.doc", append ctitle(Model 3) label

* -----------------------------------------------
* PART 3: Summary Statistics Grouped by 'foreign' Variable
* -----------------------------------------------

* Use outreg2 to generate summary statistics by the 'foreign' variable (Domestic vs. Foreign).
* The 'bysort' command groups the data by 'foreign' before summarizing.
bysort foreign: outreg2 using "grouped_summary_stats.doc", replace sum(log) ///
    keep(price mpg weight)

* -----------------------------------------------
* PART 4: Coefficient Plot of Regression Models
* -----------------------------------------------

* Install the 'coefplot' package if it's not already installed
 ssc install coefplot

* Estimate and store Model 4
regress price mpg rep78 gear_ratio headroom
est store model4

* Check stored models
estimates dir   // This will list all the stored models to confirm they are available.

* Create coefficient plot for all three models

* Create coefficient plot for Model 3
coefplot model4, ///
    drop(_cons)                                 /// Drop the intercept (_cons)
    xline(0, lpattern(dash) lwidth(medium) lcolor(black)) /// Add a vertical reference line at zero
    title("Coefficient Plot for Model 3") ///
    xlabel(, labsize(medium))                   /// Adjust label size for better readability
    ylabel(, labsize(medium))                   /// Adjust label size for better readability
    lcolor(black)                               /// Set color of confidence interval lines to black
    pstyle(p1) msize(medium)                    /// Set point style and size for coefficient markers
    mlcolor(black)                              /// Set marker color to black for uniformity
    ciopts(lwidth(medium) lcolor(black))        /// Set confidence interval line width and color
    legend(off)                                 /// Turn off the legend for a cleaner plot
    ysize(8) xsize(12)                          /// Adjust plot size for clarity
    scheme(s1mono)                              /// Use a monochrome scheme for a professional appearance

graph export "coefficient_plot.png", replace


* -----------------------------------------------
* End of Do-file
* -----------------------------------------------
