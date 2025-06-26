*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table A.5 in the Online Appendix of the paper 
*               Date: June 2018       
*                                                      
*******************************************************************************************************************************************

/* Preliminary step: run the file PRE_Table_5.do to generate the dataset wealth_quantiles.dta for the analysis  */
run "do files/Tables/PRE_Table_A5.do"

use "data/temp/AEJ2018_child_mortality_computation.dta", clear // dataset generated previously for Table_3.do
	merge m:1 hhid using "data/temp/AEJ2018_wealth_quantiles.dta", nogen
		
/*******************************************************************************
				Under-5 mortality per 1000 years of exposure
								50-50 Split
*******************************************************************************/
	preserve
		keep if quantile_2==1
		collapse (sum)  death_under5 count_month_u5 death_under1 ///
						count_month_u1 death_under1m count_month_u1m, ///
						by (villageid branchid treatment)
		replace count_month_u5=count_month_u5/12
		replace count_month_u1=count_month_u1/12
		
		gen mrate_u5= (death_under5/count_month_u5)*1000
		gen mrate_u1= (death_under1/count_month_u1)*1000
		gen mrate_u1m= (death_under1m/count_month_u1m)*1000
		
		*OUTPUT:
		*\Poorest (i)
			*Program impact
			xi: reg mrate_u5 treatment i.branchid, robust
			
			*Rate ration
			xi: poisson death_under5 treatment i.branchid, exposure(count_month_u5) vce(robust) irr
			
			*Mean control
			xi: reg mrate_u5 treatment, robust

	restore
	preserve
		keep if quantile_2==2
		collapse (sum)  death_under5 count_month_u5 death_under1 ///
						count_month_u1 death_under1m count_month_u1m, ///
						by (villageid branchid treatment)
		replace count_month_u5=count_month_u5/12
		replace count_month_u1=count_month_u1/12
	
		gen mrate_u5= (death_under5/count_month_u5)*1000
		gen mrate_u1= (death_under1/count_month_u1)*1000
		gen mrate_u1m= (death_under1m/count_month_u1m)*1000
		
		*OUTPUT:
		*\Richest (ii)
			*Program impact	
			xi: reg mrate_u5 treatment i.branchid, robust
			
			*Rate ratio
			xi: poisson death_under5 treatment i.branchid, exposure(count_month_u5) vce(robust) irr
			
			*Mean control
			xi: reg mrate_u5 treatment, robust
	restore	
			
			
/*******************************************************************************
				Under-5 mortality per 1000 years of exposure
								Quartiles
*******************************************************************************/			
	
	preserve
		keep if quartile==1
		collapse (sum) death_under5 count_month_u5 death_under1 ///
				count_month_u1 death_under1m count_month_u1m, ///
				by (villageid branchid treatment)
		replace count_month_u5=count_month_u5/12
		replace count_month_u1=count_month_u1/12
		
		gen mrate_u5= (death_under5/count_month_u5)*1000
		gen mrate_u1= (death_under1/count_month_u1)*1000
		gen mrate_u1m= (death_under1m/count_month_u1m)*1000		
	
		*OUTPUT:
		*\Poorest Quartile (iii)
			*Program impact	
			xi: reg mrate_u5 treatment i.branchid, robust
			
			*Rate ratio
			xi: poisson death_under5 treatment i.branchid, exposure(count_month_u5) vce(robust) irr

			*Mean control
			xi: reg mrate_u5 treatment, robust
	restore
	
	preserve
		keep if quartile>1
		collapse (sum) death_under5 count_month_u5 death_under1 ///
				count_month_u1 death_under1m count_month_u1m, ///
				by (villageid branchid treatment)
		replace count_month_u5=count_month_u5/12
		replace count_month_u1=count_month_u1/12
		
		gen mrate_u5= (death_under5/count_month_u5)*1000
		gen mrate_u1= (death_under1/count_month_u1)*1000
		gen mrate_u1m= (death_under1m/count_month_u1m)*1000	
	
		*OUTPUT:
		*\Others (iv)
			*Program impact	
			xi: reg mrate_u5 treatment i.branchid, robust
			
			*Rate ratio
			xi: poisson death_under5 treatment i.branchid, exposure(count_month_u5) vce(robust) irr

			*Mean control
			xi: reg mrate_u5 treatment, robust
	restore
	
	preserve
		keep if quartile==4
		collapse (sum) death_under5 count_month_u5 death_under1 ///
				count_month_u1 death_under1m count_month_u1m, ///
				by (villageid branchid treatment)
		replace count_month_u5=count_month_u5/12
		replace count_month_u1=count_month_u1/12
		
		gen mrate_u5= (death_under5/count_month_u5)*1000
		gen mrate_u1= (death_under1/count_month_u1)*1000
		gen mrate_u1m= (death_under1m/count_month_u1m)*1000
			
	
		*OUTPUT:
		*\Richest Quantile (v)
			*Program impact	
			xi: reg mrate_u5 treatment i.branchid, robust
			
			*Rate ratio
			xi: poisson death_under5 treatment i.branchid, exposure(count_month_u5) vce(robust) irr

			*Mean control
			xi: reg mrate_u5 treatment, robust
	restore
	
		keep if quartile<4
		collapse (sum) death_under5 count_month_u5 death_under1 ///
					   count_month_u1 death_under1m count_month_u1m, ///
					   by (villageid branchid treatment)
		replace count_month_u5=count_month_u5/12
		replace count_month_u1=count_month_u1/12
		
		gen mrate_u5= (death_under5/count_month_u5)*1000
		gen mrate_u1= (death_under1/count_month_u1)*1000
		gen mrate_u1m= (death_under1m/count_month_u1m)*1000	
		
		
		*OUTPUT:
		*\Others (vi)
			*Program impact	
			xi: reg mrate_u5 treatment i.branchid, robust
			
			*Rate ratio
			xi: poisson death_under5 treatment i.branchid, exposure(count_month_u5) vce(robust) irr

			*Mean control
			xi: reg mrate_u5 treatment, robust
			
			
	



