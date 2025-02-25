* Load the dataset
use "CMPS_2016.dta", clear
* Part 1: Introduction to CMPS

*  The Collaborative Multiracial Post-Election Survey (CMPS) is a comprehensive national survey designed to
*  capture the attitudes, experiences, and political behaviors of various racial and ethnic groups in the United States. 

*  The CMPS is unique in its emphasis on multiracial perspectives and the diversity of political experiences among different 
*  racial and ethnic groups. By surveying a large and diverse sample, the CMPS allows researchers to analyze patterns in 
** political behavior and attitudes not only within racial and ethnic groups but also across them. 


* Part 2: Research Questions
* --------------------------------------
* Research Question 1: Is there a relationship between age and perception of discrimination against immigrants (C246)?
* Research Question 2: Is there a relationship between race and perception of discrimination against immigrants (C246)?
* Research Question 3: Is there a relationship between gender and perception of discrimination against immigrants (C246)?

* Part 3: Exploratory Data Analysis
* --------------------------------------

************** Prepare variables *****************

* RACE

* generate the categorical race variable
gen race = .

* Assign race categories based on dummy variables
replace race = 1 if S2_1 == 1  // White, Not-Hispanic
replace race = 2 if S2_2 == 1   // Hispanic or Latino
replace race = 3 if S2_3 == 1 // Black or African American
replace race = 4 if S2_4 == 1    // Asian American

* Label the race categories for clarity
label define race_lbl 1 "White, Not-Hispanic" 2 "Hispanic or Latino" 3 "Black or African American" 4 "Asian American"
label values race race_lbl

* Verify the distribution of the new race variable
tabulate race

* GENDER 

* recode gender variale 

tab S3
label list S3

drop if S3==3

clonevar gender = S3

* Discrimination
tab C246
label list C246

drop if C246==5


* numeric 
gen discrimination = 5-C246

tab discrimination C246


* Check for missing values in key variables and remove any rows with missing data in C246, age, race, or gender

gen age = AGE

drop if missing(C246) | missing(age) | missing(race) | missing(gender)

summarize C246 age race gender



* Plot 1: Percentage Distribution of Perceptions of Discrimination by Race
graph bar (percent), over(C246) over(race, label(angle(25))) asyvars stack percentages ///
    title("Perception of Discrimination by Race") ///
    ytitle("Percentage within Race Group")

* Plot 2: Percentage Distribution of Perceptions of Discrimination by Gender
graph bar (percent), over(C246) over(S3) asyvars stack percentages ///
    title("Perception of Discrimination by Gender") ///
    ytitle("Percentage within Gender Group")

* Plot 3: Age vs. Perception of Discrimination against Immigrants

graph bar (percent), over(C246) over(age, label(angle(45))) asyvars stack percentages ///
    title("Perception of Discrimination by Age") ///
    ytitle("Percentage within Age Group")

* Scatter plot with linear fit line to explore relationship between age and C246
twoway (scatter discrimination age) (lfit discrimination age), title("Age vs Perception of Discrimination") ytitle("Perception of Discrimination (C246)") xtitle("Age")

* Part 4: Inference
* --------------------------------------

* Chi-Squared Tests for Categorical Associations
* Chi-squared test between C246 and race
tabulate C246 race, chi2

* Chi-squared test between C246 and gender
tabulate C246 S3, chi2

* t-Test: Perception of Discrimination by Gender
* Comparing mean C246 perception between genders to see if there's a significant difference
ttest C246, by(gender)

* ANOVA: Race Differences Across Perception Levels of Discrimination (C246)
* Testing if mean age differs across levels of C246
anova discrimination i.race

* Linear Regression: Age and Perception of Discrimination
* Checking the linear relationship between age and discrimination
regress discrimination age

* Multiple Regression: Age, Race, and Gender on Perception of Discrimination
* Examines the relationship between discrimination and the combination of age, race, and gender
regress discrimination age i.race i.S3





