*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table A.4 in the Online Appendix of the paper 
*               Date: June 2018       
*                                                      
*******************************************************************************************************************************************
	
/*******************************************************************************
							Panel A: Any Health Care Provider 
*******************************************************************************/	
use "data/AEJ2018_postnatal.dta", clear
	*OUTPUT:
		*\Dependent var: ...first week post delivery
			*Program impact
			xi: reg postnatal_followup treatment i.branchid, robust cluster(villageid)
			
			*Mean control
			xi: reg postnatal_followup treatment, robust cluster(villageid)	

	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	/* Note: the merging below will be done with the goal of having all variables in one dataset, 
		so to run the avg_effect command. The auxiliary variable "merge" will be used for the merging.
		The merging will be such that the final dataset will contain: 
			1 observation per child, for variables defined at the child level,
			1 observation per woman for variables defined at the woman kevel, */
	keep postnatal_followup hhid treatment branchid villageid postnatal_womanID
	gen  merge=postnatal_womanID // auxiliary variable for the merging
	save "data/temp/AEJ2018_TableA4_ASTE_A.dta", replace			

	
use "data/AEJ2018_malaria.dta", clear
	*OUTPUT:
		*\Dependent var: ...after child sick with malaria
			*Program impact	
			xi: reg malaria_followup treatment i.branchid, robust cluster(villageid)	
			
			*Mean control
			xi: reg malaria_followup treatment, robust cluster(villageid)
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep malaria_followup treatment hhid branchid villageid childID
	gen merge=childID
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_TableA4_ASTE_A.dta", nogen 
	save "data/temp/AEJ2018_TableA4_ASTE_A.dta", replace		
		
		
use "data/AEJ2018_diarrhea.dta", clear
	*OUTPUT:
		*\Dependent var: ...after child sick with diarrhea
			*Program impact		
			xi: reg diarrhea_followup treatment i.branchid, robust cluster(villageid)	
			
			*Mean control
			xi: reg diarrhea_followup treatment, robust cluster(villageid)
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep diarrhea_followup  treatment hhid branchid villageid childID
	gen merge=childID
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_TableA4_ASTE_A.dta", nogen 
	save "data/temp/AEJ2018_TableA4_ASTE_A.dta", replace		
		

use	"data/temp/AEJ2018_TableA4_ASTE_A.dta", clear // generated with Table_7.do
	xi i.branchid
	*OUTPUT:
		*\Average starndardized effects
		avg_effect postnatal_followup malaria_followup diarrhea_followup,  ///
			x(treatment _Ibranchid* ) effectvar(treatment) controltest(treatment==0) keepmissing cluster(villageid)


			
/*******************************************************************************
							Panel B: CHPs
*******************************************************************************/

use "data/AEJ2018_postnatal.dta", clear
	gen postnatal_followupCHP=(postnatal_followup_who_1==5 | postnatal_followup_who_2==5 | ///
						postnatal_followup_who_3==5 | postnatal_followup_who_4==5) ///
						if postnatal_followup!=.  									
	*OUTPUT:
		*\Dependent var: ...first week post delivery
			*Program impact							
			xi: reg postnatal_followupCHP treatment i.branchid, robust cluster(villageid)
			
			*Mean control
			xi: reg postnatal_followupCHP treatment, robust cluster(villageid)

	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep postnatal_followupCHP hhid treatment branchid villageid postnatal_womanID
	gen  merge=postnatal_womanID // auxiliary variable for the merging
	save "data/temp/AEJ2018_TableA4_ASTE_B.dta", replace	
	
	
use "data/AEJ2018_malaria.dta", clear
	gen malaria_followupCHP=(malaria_followup_who==3) if malaria_followup!=.
	
	*OUTPUT:
		*\Dependent var: ...after child sick with malaria
			*Program impact	
			xi: reg malaria_followupCHP treatment i.branchid, robust cluster(villageid)	
	
			*Mean control
			xi: reg malaria_followupCHP treatment, robust cluster(villageid)
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep malaria_followupCHP treatment hhid branchid villageid childID
	gen merge=childID
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_TableA4_ASTE_B.dta", nogen 
	save "data/temp/AEJ2018_TableA4_ASTE_B.dta", replace


use "data/AEJ2018_diarrhea.dta", clear
	gen diarrhea_followupCHP=(diarrhea_followup_who==3) if diarrhea_followup!=.
	
	*OUTPUT:
		*\Dependent var: ...after child sick with diarrhea
			*Program impact		
			xi: reg diarrhea_followupCHP treatment i.branchid, robust cluster(villageid)		
			
			*Mean control
			xi: reg diarrhea_followupCHP treatment, robust cluster(villageid)
		
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep diarrhea_followupCHP  treatment hhid branchid villageid childID
	gen merge=childID
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_TableA4_ASTE_B.dta", nogen 
	save "data/temp/AEJ2018_TableA4_ASTE_B.dta", replace	

	
use	"data/temp/AEJ2018_TableA4_ASTE_B.dta", clear
	xi i.branchid
	*OUTPUT:
		*\Average starndardized effects
		avg_effect postnatal_followupCHP malaria_followupCHP diarrhea_followupCHP,  ///
			x(treatment _Ibranchid* ) effectvar(treatment) controltest(treatment==0) keepmissing cluster(villageid)
			

			
/*******************************************************************************
						Panel A: Any Other Health Care Provider 
*******************************************************************************/

use "data/AEJ2018_postnatal.dta", clear
	gen postnatal_followupOthers=((postnatal_followup_who_1!=5 & postnatal_followup_who_1!=.) & ///
							(postnatal_followup_who_2!=5 & postnatal_followup_who_1!=.) & ///
							(postnatal_followup_who_3!=5 & postnatal_followup_who_1!=.) & ///
							(postnatal_followup_who_4!=5 & postnatal_followup_who_1!=.)) ///
							if postnatal_followup!=.  				 
						
	*OUTPUT:
		*\Dependent var: ...first week post delivery
			*Program impact							
			xi: reg postnatal_followupOthers treatment i.branchid, robust cluster(villageid)	
			
			*Mean control
			xi: reg postnatal_followupOthers treatment, robust cluster(villageid)
									 
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep postnatal_followupOthers hhid treatment branchid villageid postnatal_womanID
	gen  merge=postnatal_womanID // auxiliary variable for the merging
	save "data/temp/AEJ2018_TableA4_ASTE_C.dta", replace	
	
	
use "data/AEJ2018_malaria.dta", clear
	gen malaria_followupOthers=(malaria_followup_who==1 | malaria_followup_who==2 | malaria_followup_who==4 | ///
							malaria_followup_who==5 | malaria_followup_who==777) if malaria_followup!=.
							
	*OUTPUT:
		*\Dependent var: ...after child sick with malaria
			*Program impact	
			xi: reg malaria_followupOthers treatment i.branchid, robust cluster(villageid)	

			*Mean control
			xi: reg malaria_followupOthers treatment, robust cluster(villageid)
			
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep malaria_followupOther treatment hhid branchid villageid childID
	gen merge=childID
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_TableA4_ASTE_C.dta", nogen 
	save "data/temp/AEJ2018_TableA4_ASTE_C.dta", replace		
							
	
use "data/AEJ2018_diarrhea.dta", clear	
	gen diarrhea_followupOther=(diarrhea_followup_who==1 | diarrhea_followup_who==2 | ///
							diarrhea_followup_who==4 | diarrhea_followup_who==5 | ///
							diarrhea_followup_who==777) if diarrhea_followup!=.
	
	*OUTPUT:
		*\Dependent var: ...after child sick with diarrhea
			*Program impact		
			xi: reg diarrhea_followupOther treatment i.branchid, robust cluster(villageid)		
			
			*Mean control
			xi: reg diarrhea_followupOther treatment, robust cluster(villageid)
	
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	keep diarrhea_followupOther  treatment hhid branchid villageid childID
	gen merge=childID
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_TableA4_ASTE_C.dta", nogen 
	save "data/temp/AEJ2018_TableA4_ASTE_C.dta", replace	

	
use	"data/temp/AEJ2018_TableA4_ASTE_C.dta", clear
	xi i.branchid
	*OUTPUT:
		*\Average starndardized effects
		avg_effect postnatal_followupOthers malaria_followupOthers diarrhea_followupOther,  ///
			x(treatment _Ibranchid* ) effectvar(treatment) controltest(treatment==0) keepmissing cluster(villageid)
