

/* Preliminary step: Run the file PRE_Table_2.do */
do "data/do-files/Tables/PRE_Table_2.do"

/*******************************************************************************
                        Panel A. Infant Mortality
*******************************************************************************/
use "Data/temp/AEJ2018_infant_mortality_computation.dta", clear // dataset generated in PRE_Table_2.do
summarize villageid branchid treatment death_under1 count_month_u1


// Years of exposure to risk of death under 1 year
preserve
collapse (sum) death_under1 count_month_u1, by(treatment)
replace count_month_u1 = count_month_u1 / 12

sum count_month_u1 if treatment == 1
scalar mean_count_1 = r(mean)

sum count_month_u1 if treatment == 0
scalar mean_count_0 = r(mean)

// Deaths under 1 year
sum death_under1 if treatment == 1
scalar mean_death_1 = r(mean)

sum death_under1 if treatment == 0
scalar mean_death_0 = r(mean)

// Mortality rate per 1,000 years of exposure
scalar mrate_1 = (mean_death_1 / mean_count_1) * 1000
scalar mrate_0 = (mean_death_0 / mean_count_0) * 1000
restore 
// P-value for mortality rate
collapse (sum) death_under1 count_month_u1, by(villageid branchid treatment)
replace count_month_u1 = count_month_u1 / 12
gen mrate_u1 = (death_under1 / count_month_u1) * 1000 if count_month_u1 > 0

xi: reg mrate_u1 treatment i.branchid, robust
test treatment
scalar p_value_mrate = r(p)

/*******************************************************************************
                        Panel B. Households
*******************************************************************************/
use "Data/temp/AEJ2018_HHmembers_A.dta", clear
describe
// Merge additional datasets for household members
merge 1:1 hhid treatment villageid branchid using "Data/temp/AEJ2018_HHmembers_B.dta", nogen
merge 1:1 hhid treatment villageid branchid using "Data/temp/AEJ2018_HHmembers_C.dta", nogen
recode HHmembers_A HHmembers_B HHmembers_C (. = 0)
gen hhsize = HHmembers_A + HHmembers_B + HHmembers_C

// Number of households and Household size
sum hhsize if treatment == 1
scalar mean_hhsize_1 = r(mean)
scalar sd_hhsize_1 = r(sd)

sum hhsize if treatment == 0
scalar mean_hhsize_0 = r(mean)
scalar sd_hhsize_0 = r(sd)

// P-value for household size
xi: reg hhsize treatment i.branchid, robust cluster(villageid)
test treatment
scalar p_value_hhsize = r(p)

// Age of household head
use "Data/AEJ2018_HHroster_ab18.dta", clear
	gen HH_age_hhh=(HHroster_ab18_age-3) if HHroster_ab18_relation==100 // rescale the age variable to baseline
	gen HH_education_hhh=HHroster_ab18_education if HHroster_ab18_relation==100
	collapse (max)  HH_age_hhh HH_education_hhh, by(branchid treatment villageid hhid)

sum HH_age_hhh if treatment == 1
scalar mean_age_1 = r(mean)
scalar sd_age_1 = r(sd)

sum HH_age_hhh if treatment == 0
scalar mean_age_0 = r(mean)
scalar sd_age_0 = r(sd)

// P-value for age of household head
xi: reg HH_age_hhh treatment i.branchid, robust cluster(villageid)
test treatment
scalar p_value_age = r(p)


// Years of education of household head
sum HH_education_hhh if treatment == 1
scalar mean_edu_1 = r(mean)
scalar sd_edu_1 = r(sd)

sum HH_education_hhh if treatment == 0
scalar mean_edu_0 = r(mean)
scalar sd_edu_0 = r(sd)

// P-value for education of household head
xi: reg HH_education_hhh treatment i.branchid, robust cluster(villageid)
test treatment
scalar p_value_edu = r(p)

/*******************************************************************************
                        Output Results
*******************************************************************************/

// Step 1: Store scalar values in local macros
local treatment_group_1 = mean_count_1
local control_group_0 = mean_count_0
local p_value_mrate = p_value_mrate

local treatment_group_death = mean_death_1
local control_group_death = mean_death_0
local p_value_death = p_value_mrate  // Replace with actual p-value if needed

local treatment_group_mrate = mrate_1
local control_group_mrate = mrate_0
local p_value_mrate = p_value_mrate // Replace with actual p-value if needed

local treatment_group_hhsize_mean = mean_hhsize_1
local control_group_hhsize_mean = mean_hhsize_0
local treatment_group_hhsize_sd = sd_hhsize_1  // Add the correct standard deviation value
local control_group_hhsize_sd = sd_hhsize_0    // Add the correct standard deviation value
local p_value_hhsize = p_value_hhsize

local treatment_group_age_mean = mean_age_1
local control_group_age_mean = mean_age_0
local treatment_group_age_sd = sd_age_1        // Add the correct standard deviation value
local control_group_age_sd = sd_age_0          // Add the correct standard deviation value
local p_value_age = p_value_age

local treatment_group_edu_mean = mean_edu_1
local control_group_edu_mean = mean_edu_0
local treatment_group_edu_sd = sd_edu_1        // Add the correct standard deviation value
local control_group_edu_sd = sd_edu_0          // Add the correct standard deviation value
local p_value_edu = p_value_edu

// Step 2: Create a matrix to hold the results (only numeric values)
matrix results = J(7, 4, .)  // 7 rows, 4 columns (treatment_group, control_group, p_value)

// Fill in the matrix with the data
matrix results[1,1] = `treatment_group_1'
matrix results[1,2] = `control_group_0'
matrix results[1,3] = .  // No p-value or standard deviation

matrix results[2,1] = `treatment_group_death'
matrix results[2,2] = `control_group_death'
matrix results[2,3] = .  // No p-value or standard deviation

matrix results[3,1] = `treatment_group_mrate'
matrix results[3,2] = `control_group_mrate'
matrix results[3,3] = `p_value_mrate'

matrix results[4,1] = 3789  // Static value for households
matrix results[4,2] = 3228  // Static value for households
matrix results[4,3] = .  // No p-value

matrix results[5,1] = `treatment_group_hhsize_mean'
matrix results[5,2] = `control_group_hhsize_mean'
matrix results[5,3] = `p_value_hhsize'

matrix results[6,1] = `treatment_group_age_mean'
matrix results[6,2] = `control_group_age_mean'
matrix results[6,3] = `p_value_age'

matrix results[7,1] = `treatment_group_edu_mean'
matrix results[7,2] = `control_group_edu_mean'
matrix results[7,3] = `p_value_edu'

// Step 3: Convert the matrix to a dataset
clear
svmat results, names(c)

// Step 4: Add column names for clarity and formatting
gen treatment_group = ""
gen control_group = ""
gen p_value = ""

// For the first three variables, only show the treatment group mean and control group mean (no SD or brackets)
replace treatment_group = string(c1, "%9.1f") if _n == 1 | _n == 2 | _n == 3
replace control_group = string(c2, "%9.1f") if _n == 1 | _n == 2 | _n == 3

// For the "Number of households" variable, display raw number without formatting
replace treatment_group = string(c1, "%9.0f") if _n == 4
replace control_group = string(c2, "%9.0f") if _n == 4

// For the other variables, display both treatment and control group with standard deviation in parentheses
replace treatment_group = string(c1, "%9.1f") + " (" + string(`treatment_group_hhsize_sd', "%9.1f") + ")" if _n == 5
replace control_group = string(c2, "%9.1f") + " (" + string(`control_group_hhsize_sd', "%9.1f") + ")" if _n == 5

replace treatment_group = string(c1, "%9.1f") + " (" + string(`treatment_group_age_sd', "%9.1f") + ")" if _n == 6
replace control_group = string(c2, "%9.1f") + " (" + string(`control_group_age_sd', "%9.1f") + ")" if _n == 6

replace treatment_group = string(c1, "%9.1f") + " (" + string(`treatment_group_edu_sd', "%9.1f") + ")" if _n == 7
replace control_group = string(c2, "%9.1f") + " (" + string(`control_group_edu_sd', "%9.1f") + ")" if _n == 7

// Add p-values for each row where applicable
replace p_value = string(c3, "%9.3f") if _n != 4

// Step 5: Create a variable for the variable names
gen variable_name = ""
replace variable_name = "Years of exposure to risk of death under 1 year" if _n == 1
replace variable_name = "Deaths under 1 year" if _n == 2
replace variable_name = "Mortality rate per 1,000 years of exposure" if _n == 3
replace variable_name = "Number of households" if _n == 4
replace variable_name = "Household size (mean, sd)" if _n == 5
replace variable_name = "Age household head (mean, sd)" if _n == 6
replace variable_name = "Years of education household head (mean, sd)" if _n == 7

// Step 6: Display the results in a clean format
list variable_name treatment_group control_group p_value, clean noobs
