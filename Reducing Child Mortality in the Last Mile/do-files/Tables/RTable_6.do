
/******************************************************************************
						(i) Child delivery at HF 	 

*******************************************************************************/
use "data/AEJ2018_postnatal.dta", clear	
matrix output = J(6, 10, .)  // 13 rows for outcomes, 7 columns for variables

	/* Program Impact */
xi: reg postnatal_nothome treatment i.branchid, robust cluster(villageid)
/* Store Program Impact Results */
matrix output[1,1] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,1] = _se[treatment]  // Standard error for treatment effect
matrix output[3,1] = e(r2)  // R² from the regression
matrix output[4,1] = e(N)  // Number of observations

/* Mean Control */
xi: reg postnatal_nothome treatment, robust cluster(villageid)
/* Store Mean Control Results */
matrix output[5,1] = _b[_cons]  // Mean control (constant term)


/******************************************************************************
				(ii) Follow up visit first week post delivery 	 
*******************************************************************************/

	/* Program Impact */
xi: reg postnatal_followup treatment i.branchid, robust cluster(villageid)
/* Store Program Impact Results */
matrix output[1,2] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,2] = _se[treatment]  // Standard error for treatment effect
matrix output[3,2] = e(r2)  // R² from the regression
matrix output[4,2] = e(N)  // Number of observations

/* Mean Control */
xi: reg postnatal_followup treatment, robust cluster(villageid)
/* Store Mean Control Results */
matrix output[5,2] = _b[_cons]  // Mean control (constant term)

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

	/* Output for Program Impact */
xi: reg HHroster_u5_breastfed treatment i.branchid, robust cluster(villageid)
/* Store results for Program Impact */
matrix output[1,3] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,3] = _se[treatment]  // Standard error for treatment effect
matrix output[3,3] = e(r2)  // R² from the regression
matrix output[4,3] = e(N)  // Number of observations

/* Output for Mean Control */
xi: reg HHroster_u5_breastfed treatment, robust cluster(villageid)
/* Store results for Mean Control */
matrix output[5,3] = _b[_cons]  // Mean control (constant term)


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
	
	/* Program Impact */
xi: reg fortified_vitA treatment i.branchid, robust cluster(villageid)
/* Store Program Impact Results */
matrix output[1,4] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,4] = _se[treatment]  // Standard error for treatment effect
matrix output[3,4] = e(r2)  // R² from the regression
matrix output[4,4] = e(N)  // Number of observations

/* Mean Control */
xi: reg fortified_vitA treatment, robust cluster(villageid)
/* Store Mean Control Results */
matrix output[5,4] = _b[_cons]  // Mean control (constant term)

	
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

	/* Program Impact */
xi: reg malaria_treatednet treatment i.branchid, robust cluster(villageid)
/* Store Program Impact Results */
matrix output[1,5] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,5] = _se[treatment]  // Standard error for treatment effect
matrix output[3,5] = e(r2)  // R² from the regression
matrix output[4,5] = e(N)  // Number of observations

/* Mean Control */
xi: reg malaria_treatednet treatment, robust cluster(villageid)
/* Store Mean Control Results */
matrix output[5,5] = _b[_cons]  // Mean control (constant term)

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

	/* Program Impact */
xi: reg HH_bheavior_treatwater treatment i.branchid, robust cluster(villageid)
/* Store Program Impact Results */
matrix output[1,6] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,6] = _se[treatment]  // Standard error for treatment effect
matrix output[3,6] = e(r2)  // R² from the regression
matrix output[4,6] = e(N)  // Number of observations

/* Mean Control */
xi: reg HH_bheavior_treatwater treatment, robust cluster(villageid)
/* Store Mean Control Results */
matrix output[5,6] = _b[_cons]  // Mean control (constant term)

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

	/* Program Impact */
xi: reg postnatal_fully_immunized treatment i.branchid, robust cluster(villageid)
/* Store Program Impact Results */
matrix output[1,7] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,7] = _se[treatment]  // Standard error for treatment effect
matrix output[3,7] = e(r2)  // R² from the regression
matrix output[4,7] = e(N)  // Number of observations

/* Mean Control */
xi: reg postnatal_fully_immunized treatment, robust cluster(villageid)
/* Store Mean Control Results */
matrix output[5,7] = _b[_cons]  // Mean control (constant term)

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

/* Program Impact */
xi: reg diarrhea_ORSZinc treatment i.branchid, robust cluster(villageid)
/* Store Program Impact Results */
matrix output[1,8] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,8] = _se[treatment]  // Standard error for treatment effect
matrix output[3,8] = e(r2)  // R² from the regression
matrix output[4,8] = e(N)  // Number of observations

/* Mean Control */
xi: reg diarrhea_ORSZinc treatment, robust cluster(villageid)
/* Store Mean Control Results */
matrix output[5,8] = _b[_cons]  // Mean control (constant term)

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
	
	/* Program Impact */
xi: reg malaria_ACT_3d treatment i.branchid, robust cluster(villageid)
/* Store Program Impact Results */
matrix output[1,9] = _b[treatment]  // Coefficient for treatment effect
matrix output[2,9] = _se[treatment]  // Standard error for treatment effect
matrix output[3,9] = e(r2)  // R² from the regression
matrix output[4,9] = e(N)  // Number of observations

/* Mean Control */
xi: reg malaria_ACT_3d treatment, robust cluster(villageid)
/* Store Mean Control Results */
matrix output[5,9] = _b[_cons]  // Mean control (constant term)

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


matrix list output 	
clear
svmat output, names(c)

rename c1 		Child
rename c2       Followup
rename c3 		Childw
rename c4 		Childt
rename c5 		Childun
rename c6 		Treat
rename c7       Childfully
rename c8		Childwdiare
rename c9		Childwmalaria
rename c10		AVERAGE



gen Variable = ""
replace Variable = "Program_impact" if _n == 1
replace Variable = "Standard_deviation" if _n == 2
replace Variable = "R²" if _n == 3
replace Variable = "Observations" if _n == 4
replace Variable = "Mean_control" if _n == 5
replace Variable = "BranchFE" if _n == 6

list Variable Child Followup Childw Childt Childun Treat Childfully Childwdiare Childwmalaria AVERAGE,noobs clean

