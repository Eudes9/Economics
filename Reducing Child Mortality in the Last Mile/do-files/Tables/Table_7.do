*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table 7 in the paper 
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************
	
	
/*******************************************************************************
				(i) Follow up after child sick with diarrhea
*******************************************************************************/
use "data/AEJ2018_diarrhea.dta", clear 

	*OUTPUT:
		*\Program impact	
		xi: reg diarrhea_followup treatment i.branchid, robust cluster(villageid)	

		*\Mean control	
		xi: reg diarrhea_followup treatment, robust cluster(villageid)	


/*******************************************************************************
				(ii) Child with diarrhea referred to HF
*******************************************************************************/

	*OUTPUT:
		*\Program impact	
		xi: reg diarrhea_referral treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control	
		xi: reg diarrhea_referral treatment, robust cluster(villageid)	
		
	*** Save dataset to generate the Average Standardized Treatment Effect (below) ***
	/* Note: the merging below will be done with the goal of having all variables in one dataset, 
		so to run the avg_effect command. The auxiliary variable "merge" will be used for the merging.
		The merging will be such that the final dataset will contain: 
			1 observation per HH for variables defined at the HH level,
			1 observation per child, for variables defined at the child level,
			1 observation per woman for variables defined at the woman kevel, */
	keep diarrhea_followup diarrhea_referral treatment hhid branchid villageid childID
	gen merge=childID
save "data/temp/AEJ2018_Table7_ASTE.dta", replace		
	

/*******************************************************************************
				(iii) Follow up after child sick with malaria
*******************************************************************************/	
use "data/AEJ2018_malaria.dta", clear

	*OUTPUT:
		*\Program impact
		xi: reg malaria_followup treatment i.branchid, robust cluster(villageid)
				
		*\Mean control
		xi: reg malaria_followup treatment, robust cluster(villageid)
	
/*******************************************************************************
					(iv) Child with malaria referred to HF
*******************************************************************************/	

	*OUTPUT:
		*\Program impact	
		xi: reg malaria_referral treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control	
		xi: reg malaria_referral treatment, robust cluster(villageid)	

	*** for ASTE (below)  ***
	keep malaria_followup malaria_referral treatment hhid branchid villageid childID
	gen merge=childID
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_Table7_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table7_ASTE.dta", replace	

/*******************************************************************************
						(v) Advised to delive in HF
*******************************************************************************/
use "data/AEJ2018_postnatal.dta", clear
	
		*OUTPUT:
		*\Program impact	
		xi: reg postnatal_adviseddeliv treatment i.branchid, robust cluster(villageid)	
		
		*\Mean control
		xi: reg postnatal_adviseddeliv treatment, robust cluster(villageid)	


	*** for ASTE (below)  ***
	keep postnatal_adviseddeliv hhid treatment branchid villageid postnatal_womanID
	gen merge=postnatal_womanID
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_Table7_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table7_ASTE.dta", replace	


/*******************************************************************************
					(vi) Ever used family planning
*******************************************************************************/
use "data/AEJ2018_HHmain.dta", clear

		*OUTPUT:
		*\Program impact	
		xi: reg HH_bheavior_fp treatment i.branchid, ///
		robust cluster(villageid)	
		
		*\Mean control
		xi: reg HH_bheavior_fp treatment, ///
		robust cluster(villageid)	
		
		
	*** for ASTE (below)  ***
	keep HH_bheavior_fp treatment hhid branchid villageid 
	gen merge=1 // so that only merged with 1 per HH
	merge 1:1 hhid treatment villageid merge using "data/temp/AEJ2018_Table7_ASTE.dta", nogen 
save "data/temp/AEJ2018_Table7_ASTE.dta", replace	

	
/*******************************************************************************
					(vii) Average standardized effect
*******************************************************************************/
use	"data/temp/AEJ2018_Table7_ASTE.dta", clear
	xi i.branchid // just to generate _Ibranchid*
	
		*OUTPUT:
		*\Program impact		
		avg_effect diarrhea_followup diarrhea_referral malaria_followup malaria_referral postnatal_adviseddeliv HH_bheavior_fp, ///
			x(treatment _Ibranchid* ) effectvar(treatment) controltest(treatment==0) keepmissing cluster(villageid)	
