*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table 3 in the paper 
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************

/* Preliminary step: run the file PRE_Table_2.do to 
	1) Define the program to compute infant mortality at baseline 
	2) 2) Run the program and generate the child_mortality_computation dataset	
	3) Define the program to compute child mortality measures using the life-table (DHS) approach	
	4) Run the program and generate the child_mortality_computationDHS dataset	*/
run "data/do-files/Tables/PRE_Table_3.do"


/******************************************************************************
							Number of deaths
*******************************************************************************/

use "data/AEJ2018_child_mortality.dta", clear 
	drop if datedeath_cmc<1333 // drop if died before the study period	
	gen death_u5=( died==1 & aad<60)
	gen death_u1=( died==1 & aad<12)
	gen death_u1m=( died==1 & aad<1)
	collapse (sum) death_u5 death_u1 death_u1m, by(villageid branchid treatment)
	
	*OUTPUT:
		*\Dependent var. : Under-5 deaths 
			*Program impact 		
			xi: reg death_u5 treatment i.branchid, robust
			
			*Mean control		
			xi: reg death_u5 treatment, robust
		
		*\Dependent var. : Infant deaths
			*Program impact
			xi: reg death_u1 treatment i.branchid, robust
			
			*Mean control
			xi: reg death_u1 treatment, robust
		
		*\Dependent var. : Neonatal deaths
			*Program impact
			xi: reg death_u1m treatment i.branchid, robust	
			
			*Mean control
			xi: reg death_u1m treatment, robust	


/******************************************************************************
					Mortality per 1000 years of exposure
*******************************************************************************/

use "data/temp/AEJ2018_child_mortality_computation.dta", clear // dataset generated in PRE_Table_3.do
	collapse (sum) death_under5 count_month_u5 death_under1 count_month_u1 ///
		death_under1m count_month_u1m, by (villageid branchid treatment)
	replace count_month_u5=count_month_u5/12
	replace count_month_u1=count_month_u1/12
	
	gen mrate_u5= (death_under5/count_month_u5)*1000
	gen mrate_u1= (death_under1/count_month_u1)*1000
	gen mrate_u1m= (death_under1m/count_month_u1m)*1000


	*OUTPUT:
		*\Dependent var. : Under-5 mortality 
			*Program impact	
			xi: reg mrate_u5 treatment i.branchid, robust

			*Rate ratio		
			xi: poisson death_under5 treatment i.branchid, ///
				exposure(count_month_u5) vce(robust) irr
			
			*Mean control		
			xi: reg mrate_u5 treatment, robust


		*\Dependent var. : Infant mortality
			*Program impact	
			xi: reg mrate_u1 treatment i.branchid, robust

			*Rate ratio		
			xi: poisson death_under1 treatment i.branchid, ///
				exposure(count_month_u1) vce(robust) irr
			
			*Mean control	
			xi: reg mrate_u1 treatment, robust


	*OUTPUT:
		*\Dependent var. : Neonatal Mortality
			*Program impact	
			xi: reg mrate_u1m treatment i.branchid, robust

			*Rate ratio		
			xi: poisson death_under1m treatment i.branchid, ///
			exposure(count_month_u1m) vce(robust) irr 
			
			*Mean control
			xi: reg mrate_u1m treatment, robust
			
			
/******************************************************************************
						Mortality per 1000 births
*******************************************************************************/
			
use "data/temp/AEJ2018_child_mortality_computationDHS.dta", clear // dataset generated in PRE_Table_3.do
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

	*OUTPUT:
		*\Dependent var. : Under-5 Mortality
			*Program impact	
			xi: reg imr_5y_5 treatment i.branchid, robust
			
			*Mean control
			xi: reg imr_5y_5 treatment, robust

		*\Dependent var. : Infant Mortality
			*Program impact	
			xi: reg imr_1y_5 treatment i.branchid, robust
			
			*Mean control
			xi: reg imr_1y_5 treatment, robust
			
		*\Dependent var. : Neonatal Mortality
			*Program impact	
			xi: reg imr_1m_5 treatment i.branchid, robust
			
			*Mean control
			xi: reg imr_1m_5 treatment, robust
	


	
	
