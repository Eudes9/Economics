*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table 1 in the paper 
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************

/*******************************************************************************
					Number of clusters and Households per cluster
*******************************************************************************/	
use "Data/AEJ2018_HHmain.dta", clear
	collapse village_hhs_baseline village_hhsu5_baseline village_distance_road village_distance_electricity village_distance_HF village_HF_within5km village_distance_HOSP, by(treatment villageid branchid) 

	*OUTPUT:
		*\Number of clusters and Households per cluster, Treatment Group
		su village_hhs_baseline if treatment==1

		*\Number of clusters and Households per cluster, Control Group 		
		su village_hhs_baseline if treatment==0
		
		*\Households per cluster, p-value	
		xi: reg village_hhs_baseline treatment i.branchid, robust
		
		
/*******************************************************************************
					Households with under-5 children per cluster
*******************************************************************************/

	*OUTPUT:
		*\Households with under-5 children per cluster, Treatment Group	
		su village_hhsu5_baseline if treatment==1
	
		*\Households with under-5 children per cluster, Control Group	 				
		su village_hhsu5_baseline if treatment==0
		
		*\*\Households with under-5 children per cluster, p-value	
		xi: reg village_hhsu5_baseline treatment i.branchid, robust


/*******************************************************************************
							Distance to main road
*******************************************************************************/		
	
	*OUTPUT:
		*\Distance to main road, Treatment Group
		su village_distance_road if treatment==1
		
		*\Distance to main road, Control Group		
		su village_distance_road if treatment==0
		
		*\Distance to main road, p-value
		xi: reg village_distance_road treatment i.branchid, robust cluster(villageid)

	
/*******************************************************************************
					Distance to electricity transmission line
*******************************************************************************/

	*OUTPUT:
		*\Distance to electricity transmission line, Treatment Group
		su village_distance_electricity if treatment==1
		
		*\Distance to electricity transmission line, Control Group			
		su village_distance_electricity if treatment==0
		
		*\Distance to electricity transmission line, p-value	
		xi: reg village_distance_electricity treatment i.branchid, robust cluster(villageid)


/*******************************************************************************
						Distance to health center 
*******************************************************************************/
	
	*OUTPUT:
		*\Distance to health center, Treatment Group 	
		su village_distance_HF if treatment==1	
		
		*\Distance to health center, Control Group	
		su village_distance_HF if treatment==0
		
		*\Distance to health center, p-value	
		xi: reg village_distance_HF treatment i.branchid, robust cluster(villageid)
		

/*******************************************************************************
					Number of health centers within 5km
*******************************************************************************/

	*OUTPUT:
		*\Number of health centers within 5km, Treatment Group 	
		su village_HF_within5km if treatment==1
	
		*\Number of health centers within 5km, Control Group				
		su village_HF_within5km if treatment==0
		
		*\Number of health centers within 5km, p-value	
		xi: reg village_HF_within5km treatment i.branchid, robust cluster(villageid)
	

/*******************************************************************************
								Distance to hospital
*******************************************************************************/
	
	*OUTPUT:
		*\Distance to hospital, Treatment Group 	
		su village_distance_HOSP if treatment==1
		
		*\Distance to hospital, Control Group 		
		su village_distance_HOSP if treatment==0
		
		*\Distance to hospital, p-value
		xi: reg village_distance_HOSP treatment i.branchid, robust cluster(villageid)



