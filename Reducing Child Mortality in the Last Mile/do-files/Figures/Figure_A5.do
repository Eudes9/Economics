*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate Figure A.5 in the Online Appendix of the paper 
*               Date: June 2018       
*                                                      
*******************************************************************************************************************************************

/* Note: to run this do file you first need to install the package oaxaca
		available from http://fmwww.bc.edu/RePEc/bocode/o/ */
ssc install oaxaca
		
use "data/temp/AEJ2018_child_mortality_computation.dta", clear // dataset generated in PRE_Table_3.do
	collapse (sum) death_under5 count_month_u5, by (villageid treatment)
	replace count_month_u5=count_month_u5/12	
	gen mrate_u5= (death_under5/count_month_u5)*1000

	merge 1:1 treatment villageid using "data/temp/AEJ2018_FigureA5.dta", nogen // dataset generate at the end of Table_6.do

/*******************************************************************************
					Results described in the text
*******************************************************************************/
*decomposition
oaxaca mrate_u5 HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater, by( treatment) omega
 
*Key take away: 34% can be accounted for by observed mean differences, the rest is unexplained

* Suggestive evidence that it's quality of the coverage that help explain the "unexplained part"
* Note that in T, all coefficients have the "right" sign and are jointly significant in T
reg mrate_u5 HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater if treatment==1, robust
test HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater

* Note that in C, several coefficients have the "wrong" sign and they are not jointly significant
reg mrate_u5 HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater if treatment ==0, robust
test HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater

* Predict mortality in CONTROL if coverage in control was equal to treatment coverage
sum HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater if treatment==1
reg mrate_u5 HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater if treatment ==0, robust
lincom HHroster_u5_breastfed*.982+ postnatal_followup*.191 +postnatal_nothome*.869+ fortified_vitA*.736+ ///
	postnatal_fully_immunized*.91 +diarrhea_ORSZinc*.377+ malaria_treatednet*.405+ malaria_ACT_3d*.662+ HH_bheavior_treatwater*.814+_cons

* Predict mortality in TREATMENT if coverage in control was equal to CONTROL coverage
sum HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater if treatment==0
reg mrate_u5 HHroster_u5_breastfed postnatal_followup postnatal_nothome fortified_vitA ///
	postnatal_fully_immunized diarrhea_ORSZinc malaria_treatednet malaria_ACT_3d HH_bheavior_treatwater if treatment ==1, robust
lincom HHroster_u5_breastfed*.984+ postnatal_followup*.117 +postnatal_nothome*.849+ fortified_vitA*.732+ ///
	postnatal_fully_immunized*.908 +diarrhea_ORSZinc*.315+ malaria_treatednet*.391+ malaria_ACT_3d*.672+ HH_bheavior_treatwater*.779+_cons

*Summary stat
sum mrate_u5 if treatment==1
sum mrate_u5 if treatment==0


/*******************************************************************************
								Figure A5
		Correlations Between Child Mortality and Intermediate Outcomes
*******************************************************************************/

* Note all coefficients have the "right" sign and are jointly significant in T
	foreach v in mrate_u5 postnatal_nothome postnatal_followup HHroster_u5_breastfed  ///
				 fortified_vitA malaria_treatednet HH_bheavior_treatwater  ///
				 postnatal_fully_immunized diarrhea_ORSZinc malaria_ACT_3d {
			egen Z_`v'=std(`v') 
		}
		
	foreach v in postnatal_nothome postnatal_followup HHroster_u5_breastfed  ///
				 fortified_vitA malaria_treatednet HH_bheavior_treatwater  ///
				 postnatal_fully_immunized diarrhea_ORSZinc malaria_ACT_3d {
			qui reg Z_`v' ${X_`v'} 	 if treatment ==1
				predict resT_`v' 	 if treatment ==1, resid
			qui reg Z_`v' ${X_`v'} 	 if treatment ==0
				predict resC_`v' 	 if treatment ==0, resid
			gen res_`v'=resT_`v' if treatment ==1
			replace res_`v'=resC_`v' if treatment ==0
			qui reg Z_mrate_u5 ${X_`v'} 	 if treatment ==1
				predict yresT_`v' 	 		 if treatment ==1, resid
			qui reg Z_mrate_u5 ${X_`v'} 	 if treatment ==0
				predict yresC_`v' 	 		 if treatment ==0, resid
			gen 	yres_`v'=yresT_`v'  	 if treatment ==1
			replace yres_`v'=yresC_`v'  	 if treatment ==0
		}


	*OUTPUT:
		*\Treatment Villages
		preserve
			keep if treatment==1
			twoway  lfit Z_mrate_u5 res_postnatal_nothome || lfit Z_mrate_u5 res_postnatal_followup || ///
					lfit Z_mrate_u5 res_HHroster_u5_breastfed  || ///
					lfit Z_mrate_u5 res_fortified_vitA   || ///
					lfit Z_mrate_u5 res_malaria_treatednet    || ///
					lfit Z_mrate_u5 res_HH_bheavior_treatwater   || ///
					lfit Z_mrate_u5 res_postnatal_fully_immunized     || ///
					lfit Z_mrate_u5 res_diarrhea_ORSZinc  || ///
					lfit Z_mrate_u5 res_malaria_ACT_3d ///
					, legend(off) graphregion(color(white)) xtitle("Prevention & Treatments, Std Resduals") ///
					ytitle("U5 Mortality, residuals") title("Treatment Villages") xscale(range(-4 4)) xlabel(-4(2)4) ///
					yscale(range(-1 1)) ylabel(-1(.5)1)
		restore
		
		
		*\Control Villages		
		preserve
			keep if treatment==0
			twoway  lfit Z_mrate_u5 res_postnatal_nothome || lfit Z_mrate_u5 res_postnatal_followup || ///
					lfit Z_mrate_u5 res_HHroster_u5_breastfed  || ///
					lfit Z_mrate_u5 res_fortified_vitA   || ///
					lfit Z_mrate_u5 res_malaria_treatednet    || ///
					lfit Z_mrate_u5 res_HH_bheavior_treatwater   || ///
					lfit Z_mrate_u5 res_postnatal_fully_immunized     || ///
					lfit Z_mrate_u5 res_diarrhea_ORSZinc  || ///
					lfit Z_mrate_u5 res_malaria_ACT_3d ///
					, legend(off) graphregion(color(white)) xtitle("Prevention & Treatments, Std Resduals") ///
					ytitle("U5 Mortality, residuals") title("Control Villages") xscale(range(-4 4)) xlabel(-4(2)4) ///
					yscale(range(-1 1)) ylabel(-1(.5)1)
		restore	
