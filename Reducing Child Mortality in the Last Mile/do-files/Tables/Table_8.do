*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table 8 in the paper 
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************
	
/*******************************************************************************
							Rate of in-migration
*******************************************************************************/	
use "data/AEJ2018_HHmain.dta", clear
	collapse village_hhs_baseline village_hhs_endline village_share_immigrants, by(villageid branchid treatment)
	gen village_i=round(village_hhs_endline*village_share_immigrants,1)
	gen village_o=round(village_hhs_baseline-village_hhs_endline*(1-village_share_immigrants),1)
	gen village_INmigration_rate=village_i/village_hhs_baseline
	gen village_OUTmigration_rate=village_o/village_hhs_baseline
	
	*OUTPUT:
		*\Rate of in-migration, Intervention Group	
		su village_INmigration_rate if treatment==1
		
		*\Rate of in-migration, Control Group	
		su village_INmigration_rate if treatment==0
		
		*\Rate of in-migration, p-value
		xi: reg village_INmigration_rate treatment i.branchid, robust
		
		
/*******************************************************************************
							Rate of out-migration
*******************************************************************************/	
		
	*OUTPUT:
		*\Rate of in-migration, Intervention Group	
		su village_OUTmigration_rate if treatment==1
		
		*\Rate of in-migration, Control Group	
		su village_OUTmigration_rate if treatment==0
		
		*\Rate of in-migration, p-value
		xi: reg village_OUTmigration_rate treatment i.branchid, robust

		
/*******************************************************************************
							Share of migrants
*******************************************************************************/	
		
	*OUTPUT:
		*\Rate of in-migration, Intervention Group	
		su village_share_immigrants if treatment==1
		
		*\Rate of in-migration, Control Group	
		su village_share_immigrants if treatment==0
		
		*\Rate of in-migration, p-value
		xi: reg village_share_immigrants treatment i.branchid, robust
