
/* Preliminary step: Prepare data */
run "data/do-files/Tables/PRE_Table_3.do"

/* Create a matrix to store results */
matrix output = J(8, 8, .)  // 8 rows for outcomes, 8 columns for variables

*****************************************************************************
                          // Number of deaths
******************************************************************************
use "data/AEJ2018_child_mortality.dta", clear 
drop if datedeath_cmc < 1333  // Drop if died before the study period

* Generate death variables
gen death_u5 = (died == 1 & aad < 60)
gen death_u1 = (died == 1 & aad < 12)
gen death_u1m = (died == 1 & aad < 1)

* Collapse the data to get the sum of deaths by villageid, branchid, and treatment
collapse (sum) death_u5 death_u1 death_u1m, by(villageid branchid treatment)

/* Under-5 deaths regression */
xi: reg death_u5 treatment i.branchid, robust
margins, at(treatment=0)  // Compute the mean for control group (treatment = 0)

matrix output[1,1] = _b[treatment]  // Coefficient for treatment effect
matrix output[1,2] = _se[treatment]  // Standard error for treatment effect
matrix output[1,3] = e(r2)  // R²
matrix output[1,4] = e(N)  // Number of observations
* Capture the real mean control using r(b), which contains the marginal means
xi: reg death_u5 treatment , robust
matrix output[1,7] = _b[_cons]   // Real mean control (from margins, the first element is the intercept)

* Display the matrix to check values
matrix list output

/* Infant deaths regression */
xi: reg death_u1 treatment i.branchid, robust
margins, at(treatment=0)  // Compute the mean for control group (treatment = 0)

matrix output[2,1] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,2] = _se[treatment]  // Standard error for treatment effect
matrix output[2,3] = e(r2)  // R²
matrix output[2,4] = e(N)  // Number of observations

* Capture the real mean control using r(b)
xi: reg death_u1 treatment, robust
matrix output[2,7] = _b[_cons] // Real mean control (from margins, the first element is the intercept)

/* Neonatal deaths regression */
xi: reg death_u1m treatment i.branchid, robust
margins, at(treatment=0)  // Compute the mean for control group (treatment = 0)

matrix output[3,1] = _b[treatment]  // Coefficient for treatment effect
matrix output[3,2] = _se[treatment]  // Standard error for treatment effect
matrix output[3,3] = e(r2)  // R²
matrix output[3,4] = e(N)  // Number of observations

* Capture the real mean control using r(b)
xi: reg death_u1m treatment, robust
matrix output[3,7] = _b[_cons] // Real mean control (from margins, the first element is the intercept)


/* Convert matrix to dataset */
clear
svmat output, names(c)

* Add variable labels
gen Variable = ""
replace Variable = "Under-5 deaths" if _n == 1
replace Variable = "Infant deaths" if _n == 2
replace Variable = "Neonatal deaths" if _n == 3

*****************************************************************************
* Mortality per 1000 years of exposure
*****************************************************************************

use "data/temp/AEJ2018_child_mortality_computation.dta", clear 
collapse (sum) death_under5 count_month_u5 death_under1 count_month_u1 ///
    death_under1m count_month_u1m, by (villageid branchid treatment)

replace count_month_u5 = count_month_u5 / 12
replace count_month_u1 = count_month_u1 / 12

gen mrate_u5 = (death_under5 / count_month_u5) * 1000
gen mrate_u1 = (death_under1 / count_month_u1) * 1000
gen mrate_u1m = (death_under1m / count_month_u1m) * 1000


/* Under-5 mortality: OLS regression for mean rate */
xi: reg mrate_u5 treatment i.branchid, robust

/* Store the coefficient and standard error for 'treatment' */
matrix output[4,1] = _b[treatment]  // Coefficient from OLS regression
matrix output[4,2] = _se[treatment]  // Robust standard error from OLS regression
matrix output[4,3] = e(r2)  // R² from the regression
matrix output[4,4] = e(N)  
/* Under-5 mortality: Poisson regression for rate ratio */
xi: poisson death_under5 treatment i.branchid, exposure(count_month_u5) vce(robust) irr

matrix output[4,5] = exp(_b[treatment])  // Rate ratio (Exponentiated coefficient)
matrix output[4,6] = _se[treatment]  // Robust standard error from Poisson regression

/* Under-5 mortality: Mean control from OLS regression (mrate_u5) */
xi: reg mrate_u5 treatment, robust
/* Access the first element of r(b) corresponding to 'treatment' */
matrix output[4,7] = _b[_cons]  // Access the second row (treatment) from r(b)

/* Infant Mortality Rate Ratio */
xi: reg mrate_u1 treatment i.branchid, robust

/* Store results in a matrix */
matrix output[5,1] = _b[treatment]  // Coefficient for 'treatment'
matrix output[5,2] = _se[treatment]  // Robust standard error for 'treatment'
matrix output[5,3] = e(r2)  // R² from the regression
matrix output[5,4] = e(N)  //
xi: poisson death_under1 treatment i.branchid, exposure(count_month_u1) vce(robust) irr

/* Store rate ratio and its robust standard error */
matrix output[5,5] = exp(_b[treatment])  // Rate ratio (Exponentiated coefficient)
matrix output[5,6] = _se[treatment]  // Standard error for the rate ratio

xi: reg mrate_u1 treatment, robust

/* Store mean control (constant term) */
matrix output[5,7] = _b[_cons]  // Constant term (mean control)

matrix list output



/* OLS Regression for Neonatal Mortality Rate (mrate_u1m) */
xi: reg mrate_u1m treatment i.branchid, robust

/* Store OLS regression results */
matrix output[6,1] = _b[treatment]  // Coefficient for 'treatment'
matrix output[6,2] = _se[treatment]  // Robust standard error for 'treatment'
matrix output[6,3] = e(r2)  // R² from the regression
matrix output[6,4] = e(N)  //

/* Poisson Regression for Neonatal Mortality Rate Ratio */
xi: poisson death_under1m treatment i.branchid, exposure(count_month_u1m) vce(robust) irr

/* Store Poisson regression results */
matrix output[6,5] = exp(_b[treatment])  // Rate ratio (Exponentiated coefficient)
matrix output[6,6] = _se[treatment]  // Standard error for the rate ratio

/* OLS Regression to Calculate Mean Control */
xi: reg mrate_u1m treatment, robust

/* Store mean control (constant term) */
matrix output[6,7] = _b[_cons]  // Constant term (mean control)
/* Display the results matrix */
matrix list output




*****************************************************************************
* Mortality per 1000 births
******************************************************************************

use "data/temp/AEJ2018_child_mortality_computationDHS.dta", clear 
collapse (sum) cohort* died_*, by(treatment branchid villageid) 
	gen cdp_0_5= died_0_5 / cohort0_5

* 1-2 months
	gen cdp_12_5=((0.5*died_12_5A) + died_12_5B + died_12_5C)/((0.5*cohort12_5A) + cohort12_5B + (0.5* cohort12_5C))
	
* 3-5 months
	gen cdp_35_5=((0.5*died_35_5A) + died_35_5B + died_35_5C)/((0.5*cohort35_5A) + cohort35_5B + (0.5* cohort35_5C))
	
* 6-11 months
	gen cdp_611_5=((0.5*died_611_5A) + died_611_5B + died_611_5C)/((0.5*cohort611_5A) + cohort611_5B + (0.5* cohort611_5C))
	
* 12-23 months
	gen cdp_1223_5=((0.5*died_1223_5A) + died_1223_5B + died_1223_5C)/((0.5*cohort1223_5A) + cohort1223_5B + (0.5* cohort1223_5C))
	
* 24-35 months
	gen cdp_2435_5=((0.5*died_2435_5A) + died_2435_5B + died_2435_5C)/((0.5*cohort2435_5A) + cohort2435_5B + (0.5* cohort2435_5C))
	
* 36 - 47 months
	gen cdp_3647_5=((0.5*died_3647_5A) + died_3647_5B + died_3647_5C)/((0.5*cohort3647_5A) + cohort3647_5B + (0.5* cohort3647_5C))
	
* 48 -59 months
	gen cdp_4859_5=((0.5*died_4859_5A) + died_4859_5B + died_4859_5C)/((0.5*cohort4859_5A) + cohort4859_5B + (0.5* cohort4859_5C))
	
* Calculate the component survival probability by subtracting the component death probability from one:
	gen csp_0_5=1-cdp_0_5
	gen csp_12_5=1-cdp_12_5
	gen csp_35_5=1-cdp_35_5
	gen csp_611_5=1-cdp_611_5
	gen csp_1223_5=1-cdp_1223_5
	gen csp_2435_5=1-cdp_2435_5
	gen csp_3647_5=1-cdp_3647_5
	gen csp_4859_5=1-cdp_4859_5
	
* Calculate the product of the component survival probabilities for 0, 1-2, 3-5, and 6-11 months of age.
	gen produ_csp_1y_5= csp_0_5* csp_12_5* csp_35_5* csp_611_5
	gen produ_csp_5y_5= csp_0_5* csp_12_5* csp_35_5* csp_611_5* ///
						csp_1223_5* csp_2435_5* csp_3647_5* csp_4859_5
	
* Subtract the product from 1 and multiply by 1000 to get the mortality rates:
	gen imr_1m_5=(1-csp_0_5)*1000
	gen imr_1y_5=(1-produ_csp_1y_5)*1000
	gen imr_5y_5=(1-produ_csp_5y_5)*1000




* Under-5 Mortality */
/* OLS Regression for Under-5 Mortality Rate (imr_5y_5) */
xi: reg imr_5y_5 treatment i.branchid, robust

/* Store OLS regression results */
matrix output[7,1] = _b[treatment]  // Coefficient for 'treatment'
matrix output[7,2] = _se[treatment]  // Robust standard error for 'treatment'
matrix output[7,3] = e(r2)  // R² from the regression
matrix output[7,4] = e(N)  //
/* OLS Regression to Calculate Mean Control */
xi: reg imr_5y_5 treatment, robust

/* Store mean control (constant term) */
matrix output[7,7] = _b[_cons]  // Constant term (mean control)


/* Infant Mortality */
/* OLS Regression for Program Impact (imr_1y_5) */
xi: reg imr_1y_5 treatment i.branchid, robust
/* Store OLS regression results for Program Impact */
matrix output[8,1] = _b[treatment]  // Coefficient for 'treatment'
matrix output[8,2] = _se[treatment]  // Robust standard error for 'treatment'
matrix output[8,3] = e(r2)  // R² from the regression
matrix output[8,4] = e(N)  //
/* OLS Regression to Calculate Mean Control */
xi: reg imr_1y_5 treatment, robust
/* Store mean control (constant term) */
matrix output[8,7] = _b[_cons]  // Constant term (mean control)


*****************************************************************************
* Output the Results
******************************************************************************
clear
svmat output, names(c)
/* Rename the variables in the dataset */
rename c1 ProgramImpact
rename c2 SE
rename c3 R2
rename c4 Observations
rename c5 Rateratio
rename c7 MeanControl

gen Variable = ""
replace Variable = "Under-5 Deaths " if _n == 1
replace Variable = "Infant Deaths " if _n == 2
replace Variable = "Neonatal Deaths" if _n == 3
replace Variable = "Under-5 Mortality " if _n == 4
replace Variable = "Infant Mortality " if _n == 5
replace Variable = "Neonatal Mortality " if _n == 6
replace Variable = "Under-5 Mortality " if _n == 7
replace Variable = "Infant Mortality " if _n == 8


/* Add a new column 'Branch FE' with value 'YES' for all rows */
gen Branch_FE = "YES"





list Variable ProgramImpact  SE  R2 Observations Rateratio MeanControl Branch_FE, noobs clean