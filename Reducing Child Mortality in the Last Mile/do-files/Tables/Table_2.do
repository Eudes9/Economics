*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Purpose: Generate output for Table 2 in the paper 
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************

/* Preliminary step: run the file PRE_Table_2.do to 
	1) Define the program to compute infant mortality at baseline 
	2) Run the program and generate the infant_mortality_computation_2018 dataset	
	3) Prepare the dataset for the household-level analysis (Panel B) */
do "data/do-files/Tables/PRE_Table_2.do"

			
/*******************************************************************************
						Panel A. Infant Mortality
*******************************************************************************/
use "Data/temp/AEJ2018_infant_mortality_computation.dta", clear // dataset generated in PRE_Table_2.do
preserve
	collapse (sum)  death_under1 count_month_u1, by (treatment)
	replace count_month_u1=count_month_u1/12
	
	*OUTPUT:
		*\Years of exposure to risk of death under 1 year, Treatment Group 	
		sum count_month_u1 if treatment==1
			scalar mean_count_1=r(mean)
			
		*\Years of exposure to risk of death under 1 year, Control Group 
		sum count_month_u1 if treatment==0
			scalar mean_count_0=r(mean)
					
		*\Deaths under 1 year, Treatment Group 	
		sum death_under1 if treatment==1
			scalar mean_death_1=r(mean)
	
		*\Deaths under 1 year, Control Group 
		sum death_under1 if treatment==0
			scalar mean_death_0=r(mean)
		
		*\Mortality rate per 1000 years of exposure, Treatment Group 	
		scalar mrate_1 = (mean_death_1/mean_count_1)*1000
			di mrate_1
			
		*\Mortality rate per 1000 years of exposure, Control Group 
		scalar mrate_0 = (mean_death_0/mean_count_0)*1000
			di mrate_0		
	restore
		
	*\Mortality rate per 1000 years of exposure, p-value
	collapse (sum)  death_under1 count_month_u1, by (villageid branchid treatment)
	replace count_month_u1=count_month_u1/12
	gen mrate_u1= (death_under1/count_month_u1)*1000
	
	* obtain the p-value
	xi: reg mrate_u1 treatment i.branchid, robust	
		
		
/*******************************************************************************
							Panel B. Households
*******************************************************************************/

* Merge main dataset with dataset from HH rasters
use "Data/temp/AEJ2018_HHmembers_A.dta", clear
	merge 1:1 hhid treatment villageid branchid using "Data/temp/AEJ2018_HHmembers_B.dta", nogen
	merge 1:1 hhid treatment villageid branchid using "Data/temp/AEJ2018_HHmembers_C.dta", nogen
	recode HHmembers_A HHmembers_B HHmembers_C (.=0)
	gen hhsize=	HHmembers_A+HHmembers_B+HHmembers_C
							
	*OUTPUT:
		*\Number of household and Household size, Treatment Group 	
		sum hhsize if treatment==1
			
		*\Number of household and Household size, Control Group 
		sum hhsize if treatment==0

		*\Number of household and Household size, p-value
		xi: reg hhsize treatment i.branchid, robust cluster(villageid)	

		
use "Data/AEJ2018_HHroster_ab18.dta", clear
	gen HH_age_hhh=(HHroster_ab18_age-3) if HHroster_ab18_relation==100 // rescale the age variable to baseline
	gen HH_education_hhh=HHroster_ab18_education if HHroster_ab18_relation==100
	collapse (max)  HH_age_hhh HH_education_hhh, by(branchid treatment villageid hhid)

			
	*OUTPUT:
		*\Age household head, Treatment Group 	
			sum HH_age_hhh if treatment==1
			
		*\Age household head, Control Group 
			sum HH_age_hhh if treatment==0

		*\Age household head, p-value
		xi: reg HH_age_hhh treatment i.branchid, robust cluster(villageid)
						
			
	*OUTPUT:
		*\Years of education household head, Treatment Group 	
			sum HH_education_hhh if treatment==1
			
		*\Years of education household head, Control Group 
			sum HH_education_hhh if treatment==0

		*\Years of education household head, p-value
		xi: reg HH_education_hhh treatment i.branchid, robust cluster(villageid)


