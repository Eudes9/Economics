*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table 6 in the paper 
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************


/******************************************************************************
						(i) Child delivery at HF 	 
*******************************************************************************/
use "data/AEJ2018_postnatal.dta", clear	
	
	*OUTPUT:
		*\Program Impact 	
		xi: reg postnatal_nothome treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control
		xi: reg postnatal_nothome treatment, robust cluster(villageid)
		

/******************************************************************************
				(ii) Follow up visit first week post delivery 	 
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg postnatal_followup treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control	
		xi: reg postnatal_followup treatment, robust cluster(villageid)	
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	/* Note: the merging below will be done with the goal of having all variables in one dataset, 
		so to run the avg_effect command. The auxiliary variable "merge" will be used for the merging.
		The merging will be such that the final dataset will contain: 
			1 observation per HH for variables defined at the HH level,
			1 observation per child, for variables defined at the child level,
			1 observation per woman for variables defined at the woman kevel, */
	keep  postnatal_nothome postnatal_followup hhid treatment branchid villageid postnatal_womanID
	gen  merge=postnatal_womanID // auxiliary variable for the merging
save "data/temp/AEJ2018_Table6_ASTE.dta", replace


/******************************************************************************
					(iii) Child was breastfed	 
*******************************************************************************/
use "data/AEJ2018_HHroster_u5.dta", clear

	*OUTPUT:
		*\Program Impact 		
		xi: reg HHroster_u5_breastfed treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control
		xi: reg HHroster_u5_breastfed treatment, robust cluster(villageid)
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep HHroster_u5_breastfed hhid treatment branchid villageid childID
	gen merge=childID // auxiliary variable for the merging
	merge 1:1 	hhid treatment villageid merge ///
				using "data/temp/AEJ2018_Table6_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table6_ASTE.dta", replace


/******************************************************************************
						(iv) Child took VitA
*******************************************************************************/
use "data/AEJ2018_fortified.dta", clear
	
	*OUTPUT:
		*\Program Impact 
		xi: reg fortified_vitA treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control 
		xi: reg fortified_vitA treatment, robust cluster(villageid)	
		
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep fortified_vitA hhid treatment branchid villageid childID
	gen merge=childID // auxiliary variable for the merging
	merge 1:1 	hhid treatment villageid merge ///
				using "data/temp/AEJ2018_Table6_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table6_ASTE.dta", replace
	
	
/******************************************************************************
					(v) Child under treated net last ngiht
*******************************************************************************/
use "data/AEJ2018_malaria.dta", clear

	*OUTPUT:
		*\Program Impact 	
		xi: reg malaria_treatednet treatment i.branchid,  robust cluster(villageid)	
		
		*\Mean control	
		xi: reg malaria_treatednet treatment, robust cluster(villageid)

	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep malaria_treatednet hhid treatment branchid villageid childID
	gen merge=childID // auxiliary variable for the merging,
	merge 1:1  	hhid treatment villageid merge ///
				using "data/temp/AEJ2018_Table6_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table6_ASTE.dta", replace
		
/******************************************************************************
					(vi) Treated water before drinking
*******************************************************************************/	
use "data/AEJ2018_HHmain.dta", clear	

	*OUTPUT:
		*\Program Impact 
		xi: reg HH_bheavior_treatwater treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control
		xi: reg HH_bheavior_treatwater treatment, robust cluster(villageid)
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep HH_bheavior_treatwater hhid treatment branchid villageid
	gen merge=1 // in this way will only merged with 1 obs per HH (variable defined at the HH level)
	merge 1:1 hhid treatment villageid merge ///
			  using "data/temp/AEJ2018_Table6_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table6_ASTE.dta", replace
			

/******************************************************************************
					(vii) Child fully immunized 	 
*******************************************************************************/			
use "data/AEJ2018_postnatal.dta", clear

	*OUTPUT:
		*\Program Impact 	
		xi: reg postnatal_fully_immunized treatment i.branchid, robust cluster(villageid)	
			
		*\Mean control
		xi: reg postnatal_fully_immunized treatment, robust cluster(villageid)	

	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep postnatal_fully_immunized hhid treatment villageid postnatal_womanID
	gen merge=postnatal_womanID
	merge 1:1 hhid treatment villageid merge ///
		  using "data/temp/AEJ2018_Table6_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table6_ASTE.dta", replace


/******************************************************************************
				(viii) Child with diarrea trated with ORS/Zinc
*******************************************************************************/
use "data/AEJ2018_diarrhea.dta", clear 		

	*OUTPUT:
		*\Program Impact 		
		xi: reg diarrhea_ORSZinc treatment i.branchid, robust cluster(villageid)
		
		*\Mean control 		
		xi: reg diarrhea_ORSZinc treatment, robust cluster(villageid)
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep diarrhea_ORSZinc hhid treatment branchid villageid childID
	gen merge=childID
	merge 1:1 hhid treatment villageid merge ///
		  using "data/temp/AEJ2018_Table6_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table6_ASTE.dta", replace


/******************************************************************************
				(ix) Child with malaria treated with ACT
*******************************************************************************/
use "data/AEJ2018_malaria.dta", clear
	
	*OUTPUT:
		*\Program Impact 
		xi: reg malaria_ACT_3d treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control
		xi: reg malaria_ACT_3d treatment, robust cluster(villageid)	
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep  malaria_ACT_3d hhid treatment branchid villageid childID
	gen merge=childID
	merge 1:1   hhid treatment villageid merge ///
				using "data/temp/AEJ2018_Table6_ASTE.dta", nogen 			
save "data/temp/AEJ2018_Table6_ASTE.dta", replace


/******************************************************************************
					(x) Average Standardized Effect 
*******************************************************************************/
use	"data/temp/AEJ2018_Table6_ASTE.dta", clear
	xi i.branchid // generate _Ibranchid*
	
	*OUTPUT:
		*\Program Impact 	
		avg_effect 	postnatal_nothome postnatal_followup HHroster_u5_breastfed fortified_vitA malaria_treatednet ///
					HH_bheavior_treatwater postnatal_fully_immunized diarrhea_ORSZinc malaria_ACT_3d ///
					, x(treatment _Ibranchid* ) effectvar(treatment) controltest(treatment==0) keepmissing cluster(villageid)	
	
*** Generate AEJ2018_FigureA5_temp.dta to be used to generate Figure A.5 in Appendix ***
collapse postnatal_nothome postnatal_followup HHroster_u5_breastfed  ///
				 fortified_vitA malaria_treatednet HH_bheavior_treatwater  ///
				 postnatal_fully_immunized diarrhea_ORSZinc malaria_ACT_3d, by(treatment villageid) 
save "data/temp/AEJ2018_FigureA5.dta", replace				 
