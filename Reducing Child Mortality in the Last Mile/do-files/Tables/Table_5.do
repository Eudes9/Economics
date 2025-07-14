*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table 5 in the paper 
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************

/* Note: to run this do file you first need to install the package avg_effect
		available from http://fmwww.bc.edu/RePEc/bocode/a/ */
ssc install avg_effect	
		
use "data/AEJ2018_HHmain.dta", clear		
/******************************************************************************
					(i) HH visited by a CHP in last 30 days 	 
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_interactions_CHPlastmonth treatment i.branchid, robust cluster(villageid)
			
		*\Mean control
		xi: reg HH_interactions_CHPlastmonth treatment, robust cluster(villageid)
		
		
/******************************************************************************
				 (ii) Diarrhea from drinking untrated water 	 
*******************************************************************************/
		
	*OUTPUT:
		*\Program Impact 
		xi: reg HH_knowledge_diarrhea treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control
		xi: reg HH_knowledge_diarrhea treatment, robust cluster(villageid)


/******************************************************************************
				 (iii) Zinc is effective against diarrhea
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_knowledge_diarrheazinc treatment i.branchid, robust cluster(villageid)
		
		*Mean control
		xi: reg HH_knowledge_diarrheazinc treatment, robust cluster(villageid)

		
/******************************************************************************
			(iv) Mosquito bites are the only cause of malaria
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_knowledge_malaria_onlymosq treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control
		xi: reg HH_knowledge_malaria_onlymosq treatment, robust cluster(villageid)
		
		
/******************************************************************************
					(v) Aware of food with added nutrients
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_knowledge_nutrients treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control 	
		xi: reg HH_knowledge_nutrients treatment, robust cluster(villageid)


/******************************************************************************
					(vi) Bednets can help prevent malaria
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 		
		xi: reg HH_knowledge_nets treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control		
		xi: reg HH_knowledge_nets treatment, robust cluster(villageid)
	

/******************************************************************************
					(vi) Women should deliver at hospital
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_knowledge_delivery_hf treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control
		xi: reg HH_knowledge_delivery_hf treatment, robust cluster(villageid)	
	
/******************************************************************************
					(vii) Average standardized effects
*******************************************************************************/

	xi i.branchid // generate _Ibranchid*
	*OUTPUT:
		*\Program Impact 		
		avg_effect 	HH_knowledge_diarrhea HH_knowledge_diarrheazinc HH_knowledge_malaria_onlymosq HH_knowledge_nutrients ///
					HH_knowledge_nets HH_knowledge_delivery_hf, ///
					x(treatment _Ibranchid* ) effectvar(treatment) controltest(treatment==0) keepmissing cluster(villageid)	
