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
gen White = .

* Assign race categories based on dummy variables
replace White = 1 if S2_1 == 1  // White, Not-Hispanic
replace White = 0 if White !=1

* Label the race categories for clarity
label define White_lbl 1 "White" 0 "Minority" 

label values White White_lbl

* Verify the distribution of the new race variable
tabulate White

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
gen discrimination = 4-C246

tab discrimination C246


* Check for missing values in key variables and remove any rows with missing data in C246, age, race, or gender

gen age = AGE

drop if missing(discrimination) | missing(age) | missing(White) | missing(gender)

summarize discrimination age White gender



* Plot 1: Percentage Distribution of Perceptions of Discrimination by Race
graph bar (percent), over(C246) over(White, label(angle(25))) asyvars stack percentages ///
    title("Perception of Discrimination by Race") ///
    ytitle("Percentage within Race Group")

* Plot 2: Percentage Distribution of Perceptions of Discrimination by Gender
graph bar (percent), over(C246) over(gender) asyvars stack percentages ///
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
tabulate discrimination White, chi2

* Chi-squared test between C246 and gender
tabulate C246 gender, chi2

* t-Test: Perception of Discrimination by Gender
* Comparing mean C246 perception between genders to see if there's a significant difference
ttest discrimination, by(gender)

* ANOVA: Race Differences Across Perception Levels of Discrimination (C246)
* Testing if mean age differs across levels of C246
anova  C246 age

* Linear Regression: Age and Perception of Discrimination
* Checking the linear relationship between age and discrimination
regress discrimination age

* Multiple Regression: Age, Race, and Gender on Perception of Discrimination
* Examines the relationship between discrimination and the combination of age, race, and gender
regress discrimination age i.White i.gender





