use "data/AEJ2018_HHmain.dta", clear

collapse village_hhs_baseline village_hhsu5_baseline village_distance_road village_distance_electricity ///
         village_distance_HF village_HF_within5km village_distance_HOSP, ///
         by(treatment villageid branchid)

* Step 1: Calculate Means, Standard Deviations, and P-Values

* Count unique clusters dynamically by treatment group
egen cluster_tag = tag(villageid)  // Tag one observation per unique cluster (villageid)

* Treatment group clusters
gen treatment_cluster = cluster_tag if treatment == 1
egen num_clusters_treatment = total(treatment_cluster)

* Control group clusters
gen control_cluster = cluster_tag if treatment == 0
egen num_clusters_control = total(control_cluster)

* Store results in locals
local treatment_clusters = num_clusters_treatment[1]
local control_clusters = num_clusters_control[1]
display "Number of clusters in treatment group: " `treatment_clusters'
display "Number of clusters in control group: " `control_clusters'


* Calculate mean and standard deviation for treatment group
su village_hhs_baseline if treatment==1
local treatment_hh_per_cluster_mean = r(mean)
local treatment_hh_per_cluster_sd = r(sd)

* Print results for treatment group
display "Treatment Group - Mean Households per Cluster: " `treatment_hh_per_cluster_mean'
display "Treatment Group - SD Households per Cluster: " `treatment_hh_per_cluster_sd'

* Calculate mean and standard deviation for control group
su village_hhs_baseline if treatment==0
local control_hh_per_cluster_mean = r(mean)
local control_hh_per_cluster_sd = r(sd)

* Print results for control group
display "Control Group - Mean Households per Cluster: " `control_hh_per_cluster_mean'
display "Control Group - SD Households per Cluster: " `control_hh_per_cluster_sd'


xi: reg village_hhs_baseline treatment i.branchid, robust
local p_value_hh_per_cluster = _b[treatment]

* Access the p-value using the stored results
test treatment  // Perform a hypothesis test on the treatment variable
local p_value_hh_per_cluster_test = r(p)

* Display the p-value
display "p-value for treatment: " `p_value_hh_per_cluster_test'






* Households with under-5 children per cluster
su village_hhsu5_baseline if treatment==1
local treatment_hh_u5_mean = r(mean)
local treatment_hh_u5_sd = r(sd)

* Print results for treatment group
display "Treatment Group - Mean Households with Under-5 Children: " `treatment_hh_u5_mean'
display "Treatment Group - SD Households with Under-5 Children: " `treatment_hh_u5_sd'

su village_hhsu5_baseline if treatment==0
local control_hh_u5_mean = r(mean)
local control_hh_u5_sd = r(sd)

* Print results for control group
display "Control Group - Mean Households with Under-5 Children: " `control_hh_u5_mean'
display "Control Group - SD Households with Under-5 Children: " `control_hh_u5_sd'

* Run the regression
xi: reg village_hhsu5_baseline treatment i.branchid, robust

* Access the p-value for the treatment variable from the regression
test treatment  // Perform a hypothesis test on the treatment variable

* Retrieve the p-value from the test result
local p_value_hh_u5_test = r(p)

* Display the p-value
display "p-value for treatment (Households with Under-5 Children): " `p_value_hh_u5_test'


* Distance to main road
su village_distance_road if treatment==1
local treatment_distance_road_mean = r(mean)
local treatment_distance_road_sd = r(sd)

* Print results for treatment group
display "Treatment Group - Mean Distance to Main Road: " `treatment_distance_road_mean'
display "Treatment Group - SD Distance to Main Road: " `treatment_distance_road_sd'
su village_distance_road if treatment==0
local control_distance_road_mean = r(mean)
local control_distance_road_sd = r(sd)
* Print results for control group
display "Control Group - Mean Distance to Main Road: " `control_distance_road_mean'
display "Control Group - SD Distance to Main Road: " `control_distance_road_sd'
* Run the regression
xi: reg village_distance_road treatment i.branchid, robust cluster(villageid)
* Access the p-value for the treatment variable from the regression
test treatment  // Perform a hypothesis test on the treatment variable
* Retrieve the p-value from the test result
local p_value_distance_road_test = r(p)

* Display the p-value
display "p-value for treatment (Distance to Main Road): " `p_value_distance_road_test'


* Distance to electricity transmission line
su village_distance_electricity if treatment==1
local trt_distance_electricity_mean = r(mean)
local trt_distance_electricity_sd = r(sd)
* Print results for treatment group
display "Treatment Group - Mean Distance to Electricity Transmission Line: " `trt_distance_electricity_mean'
display "Treatment Group - SD Distance to Electricity Transmission Line: " `trt_distance_electricity_sd'
su village_distance_electricity if treatment==0
local ctrl_distance_electricity_mean = r(mean)
local ctrl_distance_electricity_sd = r(sd)
* Print results for control group
display "Control Group - Mean Distance to Electricity Transmission Line: " `ctrl_distance_electricity_mean'
display "Control Group - SD Distance to Electricity Transmission Line: " `ctrl_distance_electricity_sd'
* Run the regression (updated to use modern factor-variable notation)
reg village_distance_electricity treatment i.branchid, robust cluster(villageid)
* Access the p-value for the treatment variable from the regression
test treatment  // Perform a hypothesis test on the treatment variable
* Retrieve the p-value from the test result (p-value stored in r(p))
local p_value_distance_electricity = r(p)
* Display the p-value
display "p-value for treatment (Distance to Electricity Transmission Line): " `p_value_distance_electricity'

* Distance to health center
su village_distance_HF if treatment==1
local treatment_distance_HF_mean = r(mean)
local treatment_distance_HF_sd = r(sd)
* Print results for treatment group
display "Treatment Group - Mean Distance to Health Center: " `treatment_distance_HF_mean'
display "Treatment Group - SD Distance to Health Center: " `treatment_distance_HF_sd'
su village_distance_HF if treatment==0
local control_distance_HF_mean = r(mean)
local control_distance_HF_sd = r(sd)
* Print results for control group
display "Control Group - Mean Distance to Health Center: " `control_distance_HF_mean'
display "Control Group - SD Distance to Health Center: " `control_distance_HF_sd'
* Run the regression
xi: reg village_distance_HF treatment i.branchid, robust cluster(villageid)
* Access the p-value for the treatment variable from the regression
test treatment  // Perform a hypothesis test on the treatment variable
* Retrieve the p-value from the test result
local p_value_distance_HF_test = r(p)
* Display the p-value
display "p-value for treatment (Distance to Health Center): " `p_value_distance_HF_test'


* Number of health centers within 5 km
su village_HF_within5km if treatment==1
local treatment_HF_within5km_mean = r(mean)
local treatment_HF_within5km_sd = r(sd)
* Print results for treatment group
display "Treatment Group - Mean Number of Health Centers within 5 km: " `treatment_HF_within5km_mean'
display "Treatment Group - SD Number of Health Centers within 5 km: " `treatment_HF_within5km_sd'
su village_HF_within5km if treatment==0
local control_HF_within5km_mean = r(mean)
local control_HF_within5km_sd = r(sd)
* Print results for control group
display "Control Group - Mean Number of Health Centers within 5 km: " `control_HF_within5km_mean'
display "Control Group - SD Number of Health Centers within 5 km: " `control_HF_within5km_sd'
* Run the regression
xi: reg village_HF_within5km treatment i.branchid, robust cluster(villageid)
* Access the p-value for the treatment variable from the regression
test treatment  // Perform a hypothesis test on the treatment variable
* Retrieve the p-value from the test result
local p_value_HF_within5km_test = r(p)
* Display the p-value
display "p-value for treatment (Number of Health Centers within 5 km): " `p_value_HF_within5km_test'


* Distance to hospital
su village_distance_HOSP if treatment==1
local treatment_distance_HOSP_mean = r(mean)
local treatment_distance_HOSP_sd = r(sd)
* Print results for treatment group
display "Treatment Group - Mean Distance to Hospital: " `treatment_distance_HOSP_mean'
display "Treatment Group - SD Distance to Hospital: " `treatment_distance_HOSP_sd'
su village_distance_HOSP if treatment==0
local control_distance_HOSP_mean = r(mean)
local control_distance_HOSP_sd = r(sd)
* Print results for control group
display "Control Group - Mean Distance to Hospital: " `control_distance_HOSP_mean'
display "Control Group - SD Distance to Hospital: " `control_distance_HOSP_sd'
* Run the regression
xi: reg village_distance_HOSP treatment i.branchid, robust cluster(villageid)
* Access the p-value for the treatment variable from the regression
test treatment  // Perform a hypothesis test on the treatment variable
* Retrieve the p-value from the test result
local p_value_distance_HOSP_test = r(p)

* Display the p-value
display "p-value for treatment (Distance to Hospital): " `p_value_distance_HOSP_test'

* Create matrix to hold the results
matrix results = J(8, 4, .)  // 8 rows for variables, 4 columns: Treatment mean, Treatment SD, Control mean, Control SD

* Number of clusters
matrix results[1,1] = `treatment_clusters'
matrix results[1,3] = `control_clusters'
matrix results[1,2] = .
matrix results[1,4] = .

* Households per cluster
matrix results[2,1] = `treatment_hh_per_cluster_mean'
matrix results[2,2] = `treatment_hh_per_cluster_sd'
matrix results[2,3] = `control_hh_per_cluster_mean'
matrix results[2,4] = `control_hh_per_cluster_sd'

* Households with under-5 children
matrix results[3,1] = `treatment_hh_u5_mean'
matrix results[3,2] = `treatment_hh_u5_sd'
matrix results[3,3] = `control_hh_u5_mean'
matrix results[3,4] = `control_hh_u5_sd'

* Distance to main road
matrix results[4,1] = `treatment_distance_road_mean'
matrix results[4,2] = `treatment_distance_road_sd'
matrix results[4,3] = `control_distance_road_mean'
matrix results[4,4] = `control_distance_road_sd'

* Distance to electricity transmission line
matrix results[5,1] = `trt_distance_electricity_mean'
matrix results[5,2] = `trt_distance_electricity_sd'
matrix results[5,3] = `ctrl_distance_electricity_mean'
matrix results[5,4] = `ctrl_distance_electricity_sd'

* Distance to health center
matrix results[6,1] = `treatment_distance_HF_mean'
matrix results[6,2] = `treatment_distance_HF_sd'
matrix results[6,3] = `control_distance_HF_mean'
matrix results[6,4] = `control_distance_HF_sd'

* Number of health centers within 5 km
matrix results[7,1] = `treatment_HF_within5km_mean'
matrix results[7,2] = `treatment_HF_within5km_sd'
matrix results[7,3] = `control_HF_within5km_mean'
matrix results[7,4] = `control_HF_within5km_sd'

* Distance to hospital
matrix results[8,1] = `treatment_distance_HOSP_mean'
matrix results[8,2] = `treatment_distance_HOSP_sd'
matrix results[8,3] = `control_distance_HOSP_mean'
matrix results[8,4] = `control_distance_HOSP_sd'

* Add p-values separately
matrix p_values = J(8, 1, .)
matrix p_values[1,1] = .
matrix p_values[2,1] = real("`p_value_hh_per_cluster_test'")
matrix p_values[3,1] = real("`p_value_hh_u5_test'")
matrix p_values[4,1] = real("`p_value_distance_road_test'")
matrix p_values[5,1] = real("`p_value_distance_electricity'")
matrix p_values[6,1] = real("`p_value_distance_HF_test'")
matrix p_values[7,1] = real("`p_value_HF_within5km_test'")
matrix p_values[8,1] = real("`p_value_distance_HOSP_test'")

* Save results to variables for formatted output
clear
svmat results, names(c)
svmat p_values, names(p)  // Prefix for p-values


* Generate formatted treatment and control group columns
gen treatment_group = ""
gen control_group = ""

* Format treatment and control group for "Number of clusters"
replace treatment_group = string(c1, "%9.1f") if _n == 1
replace control_group = string(c3, "%9.1f") if _n == 1

* Format treatment and control group for other variables
replace treatment_group = string(c1, "%9.1f") + " (" + string(c2, "%9.1f") + ")" if _n != 1
replace control_group = string(c3, "%9.1f") + " (" + string(c4, "%9.1f") + ")" if _n != 1

* Add variable names for clarity
gen variable_name = ""
replace variable_name = "Number of clusters" if _n == 1
replace variable_name = "Households per cluster" if _n == 2
replace variable_name = "Households with under-5 children" if _n == 3
replace variable_name = "Distance to main road" if _n == 4
replace variable_name = "Distance to electricity transmission line" if _n == 5
replace variable_name = "Distance to health center" if _n == 6
replace variable_name = "Number of health centers within 5 km" if _n == 7
replace variable_name = "Distance to hospital" if _n == 8


* Rename p1 to P_value
rename p1 p_value

* Output the results
list variable_name treatment_group control_group p_value, clean noobs

