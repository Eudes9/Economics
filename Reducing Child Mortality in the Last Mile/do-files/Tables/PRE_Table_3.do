*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: 	1) Define the program to compute child mortality measures 
*							2) Run the program and generate the child_mortality_computation dataset	
*							3) Define the program to compute child mortality measures using the life-table (DHS) approach	
*							4) Run the program and generate the child_mortality_computationDHS dataset		
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************

/******************************************************************************************
				1) Define the program to compute child mortality measures 
*******************************************************************************************/

capture program drop child_mortality
program define child_mortality
	/* the program has two arguments, expressed as dates (month and year) according to CMC standard: 
			1) the beginning of the study period -- i.e. when the program started and CHPs were assigned
			2) the end of the study peiord -- i.e. when the endline survey took place */
	args CHPassigned endperiod 
	
	* drop children that died before the beginning of the study period
	drop if datedeath_cmc<`CHPassigned'
	
	* generate the variables that count the number of months the child was exposed to the risk of death
	* i) UNDER-5 MORTALITY
	* compute month of exposure under 5 years:
	gen count_month_u5=(datedeath_cmc-`CHPassigned')+0.5 if ///
		datebirth_cmc<`CHPassigned' & datedeath_cmc>=`CHPassigned' ///
		& datedeath_cmc<=`endperiod'
		replace count_month_u5=(`endperiod'-`CHPassigned')+1 if ///
			datebirth_cmc<`CHPassigned' & (datedeath_cmc>`endperiod' | died==0) 
		replace count_month_u5=(`endperiod'-datebirth_cmc)+0.5 if ///
			datebirth_cmc>=`CHPassigned' & datebirth_cmc<=`endperiod' & ///
			(datedeath_cmc>`endperiod' | died==0) 
		replace count_month_u5=datedeath_cmc-datebirth_cmc if ///
			datebirth_cmc>=`CHPassigned' & datebirth_cmc<=`endperiod' & datedeath_cmc<=`endperiod'
	* compute the deaths under 5yrs	
	gen death_under5=(datedeath_cmc>=`CHPassigned' & datedeath_cmc<=`endperiod' & died==1)
	
	* ii) INFANT MORTALITY
	* define first birthday (i.e. when the child turns 1 year old)
	gen date12m_cmc=datebirth_cmc+12
	* define age at the beginning of the study period 
	gen aabeginning=(`CHPassigned'-datebirth_cmc)-0.5 
	* define age at the end of the study period
	gen aaend=(`endperiod'-datebirth_cmc)+0.5 
	* compute month of exposure under 1 year:
	gen count_month_u1=(datedeath_cmc-`CHPassigned')+0.5 if ///
		datebirth_cmc<`CHPassigned' & datedeath_cmc>=`CHPassigned' ///
		& datedeath_cmc<=`endperiod' & aad<12 & aabeginning<12
		replace count_month_u1=(date12m_cmc-`CHPassigned')+0.5 if ///
			datebirth_cmc<`CHPassigned' & datedeath_cmc>=`CHPassigned' & ///
			datedeath_cmc<=`endperiod' & aad>=12 & aabeginning<12
		replace count_month_u1=(date12m_cmc-`CHPassigned')+0.5 if ///
			datebirth_cmc<`CHPassigned' & (datedeath_cmc>`endperiod' | died==0) ///
			& aabeginning<12 & date12m_cmc>=`CHPassigned' & date12m_cmc<=`endperiod'
		replace count_month_u1=(`endperiod'-`CHPassigned')+1 if ///
			datebirth_cmc<`CHPassigned' & (datedeath_cmc>`endperiod' | died==0) ///
			& aabeginning<12 & date12m_cmc>`endperiod'	
		replace count_month_u1=(`endperiod'-datebirth_cmc)+0.5 if ///
			datebirth_cmc>=`CHPassigned' & datebirth_cmc<=`endperiod' & ///
			(datedeath_cmc>`endperiod' | died==0) & aaend<12		
		replace count_month_u1=12 if datebirth_cmc>=`CHPassigned' & ///
			datebirth_cmc<=`endperiod' & (datedeath_cmc>`endperiod' | died==0) & aaend>=12
		replace count_month_u1=datedeath_cmc-datebirth_cmc if ///
			datebirth_cmc>=`CHPassigned' & datedeath_cmc<=`endperiod' & aad<12
		replace count_month_u1=12 if datebirth_cmc>=`CHPassigned' & ///
			datedeath_cmc<=`endperiod' & aad>=12
	* compute the deaths under 1y	
	gen death_under1=(datedeath_cmc>=`CHPassigned' & datedeath_cmc<=`endperiod' & aad<12)
	
	* iii) NEONATAL MORTALITY:
	* compute number of births:
	gen count_month_u1m=(datebirth_cmc>=`CHPassigned' & ///
		datebirth_cmc<=`endperiod') if datebirth_cmc>=`CHPassigned' & ///
		datebirth_cmc<=`endperiod'  
	* compute number of deaths within the first month:	
	gen death_under1m=(datedeath_cmc>=`CHPassigned' & ///
		datedeath_cmc<=`endperiod' & aad==0) if ///
		datebirth_cmc>=`CHPassigned' & datebirth_cmc<=`endperiod'  
end		


/******************************************************************************
					2) Generate dataset child_mortality_computation
*******************************************************************************/

* Endline in September 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==9
	* set CHPassigned= 1333 (Jan 2011=1333) endperiod=1365  (Sep 2013=1365)
	child_mortality 1333 1365 
save "data/temp/AEJ2018_child_mortality_computation.dta", replace

* Endline in October 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==10
	child_mortality 1333 1366 
	append using "data/temp/AEJ2018_child_mortality_computation.dta"
save "data/temp/AEJ2018_child_mortality_computation.dta", replace

* Endline in November 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==11
	child_mortality 1333 1367
	append using "data/temp/AEJ2018_child_mortality_computation.dta"
save "data/temp/AEJ2018_child_mortality_computation.dta", replace

* Endline in December 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==12
	child_mortality 1333 1368 
	append using "data/temp/AEJ2018_child_mortality_computation.dta"
save "data/temp/AEJ2018_child_mortality_computation.dta", replace

	
	
/*********************************************************************************************************************************
					3) Define the program to compute child mortality measures using the life-table (DHS) approach
**********************************************************************************************************************************/	

/* DHS method: compute component death probabilities for age segments 0, 1-2, 3-5, 6-11, 12-23, 24-35, 36-47, and 48-59 
	
	e.g. compute the component death probability for age segment 6m-11m between Jan2012 and Dec2012
	1) define 3 cohorts: 	A) children born Feb2011-Jul2012 -> partly exposed
							B) children born Jul2012-Jan2012 -> fully exposed
							C) children born Jan2012-Jun2012 -> partly exposed
	2) compute component death probability : 	
		NUMERATOR: 	0.5*(number of deaths between 6m-12m of children in cohort A) + (number of deaths between 6m-12m of children in cohort B) + 0.5*(number of deaths between 6m-12m of children in cohort C) 
		DENOMINATOR:0.5*(number of survivers above 6m of children in cohort A) + (number of survivers above 6m of children in cohort b) + 0.5*(number of survivers above 6m of children in cohort C)
		
		N.B. exception if ending with survey date: (only) NUMERATOR: 0.5*A + B + C  ->>>>> (instead of + 0.5*C)
		as we always consider end of survey as end period, we alwayas have + C instead of +0.5C
		
 	3) Calculate the component survival probability by subtracting the component death probability from one
 	4) Calculate the product of the component survival probabilities for 0, 1-2, 3-5, and 6-11 months of age
 	5) Subtract the product from 1 and multiply by 1000 to get the infant mortality rate. */

capture program drop child_mortality_DHS_temp
program define child_mortality_DHS_temp
	/* the program has two arguments, expressed as dates (month and year) according to CMC standard: 
			1) the beginning of the study period -- i.e. when the program started and CHPs were assigned
			2) the end of the study peiord -- i.e. when the endline survey took place */
	args startperiod endperiod
	
	* drop children that died before the beginning of the study period
	drop if datedeath_cmc<`startperiod'
	
* 0 months	
	gen cohort0_5=(datebirth_cmc>=`startperiod' &  datebirth_cmc<=`endperiod') 
	gen died_0_5=(datedeath_cmc>=`startperiod' & datedeath_cmc<=`endperiod' & aad==0)

* 1-2 months
	gen cohort12_5A= (datebirth_cmc>=`startperiod'-2 & datebirth_cmc<`startperiod')
	gen cohort12_5B= (datebirth_cmc>=`startperiod' & datebirth_cmc<`endperiod'-2)
	gen cohort12_5C= (datebirth_cmc>=`endperiod'-2 & datebirth_cmc<`endperiod')
	gen died_12_5A=((aad>=1 & aad<=2) & cohort12_5A==1)
	gen died_12_5B=((aad>=1 & aad<=2) & cohort12_5B==1)
	gen died_12_5C=((aad>=1 & aad<=2) & cohort12_5C==1)

* 3-5 months
	gen cohort35_5A= (datebirth_cmc>=`startperiod'-5 & datebirth_cmc<`startperiod'-2)
	gen cohort35_5B= (datebirth_cmc>=`startperiod'-2 & datebirth_cmc<`endperiod'-5)
	gen cohort35_5C= (datebirth_cmc>=`endperiod'-5 & datebirth_cmc<`endperiod'-2)
	gen died_35_5A=((aad>=3 & aad<=5) & cohort35_5A==1)
	gen died_35_5B=((aad>=3 & aad<=5) & cohort35_5B==1)
	gen died_35_5C=((aad>=3 & aad<=5) & cohort35_5C==1)
	
* 6-11 months
	gen cohort611_5A= (datebirth_cmc>=`startperiod'-11 & datebirth_cmc<`startperiod'-5)
	gen cohort611_5B= (datebirth_cmc>=`startperiod'-5 & datebirth_cmc<`endperiod'-11)
	gen cohort611_5C= (datebirth_cmc>=`endperiod'-11 & datebirth_cmc<`endperiod'-5)
	gen died_611_5A=((aad>=6 & aad<=11) & cohort611_5A==1)
	gen died_611_5B=((aad>=6 & aad<=11) & cohort611_5B==1)
	gen died_611_5C=((aad>=6 & aad<=11) & cohort611_5C==1)

* 12-23 months
	gen cohort1223_5A= (datebirth_cmc>=`startperiod'-23 & datebirth_cmc<`startperiod'-11)
	gen cohort1223_5B= (datebirth_cmc>=`startperiod'-11 & datebirth_cmc<`endperiod'-23)
	gen cohort1223_5C= (datebirth_cmc>=`endperiod'-23 & datebirth_cmc<`endperiod'-11)
	gen died_1223_5A=((aad>=12 & aad<=23) & cohort1223_5A==1)
	gen died_1223_5B=((aad>=12 & aad<=23) & cohort1223_5B==1)
	gen died_1223_5C=((aad>=12 & aad<=23) & cohort1223_5C==1)
	
* 24-35 months 
	gen cohort2435_5A= (datebirth_cmc>=`startperiod'-35 & datebirth_cmc<`startperiod'-23)
	gen cohort2435_5B= (datebirth_cmc>=`startperiod'-23 & datebirth_cmc<`endperiod'-35)
	gen cohort2435_5C= (datebirth_cmc>=`endperiod'-35 & datebirth_cmc<`endperiod'-23)
	gen died_2435_5A=((aad>=24 & aad<=35) & cohort2435_5A==1)
	gen died_2435_5B=((aad>=24 & aad<=35) & cohort2435_5B==1)
	gen died_2435_5C=((aad>=24 & aad<=35) & cohort2435_5C==1)

* 36-47 months 
	gen cohort3647_5A= (datebirth_cmc>=`startperiod'-47 & datebirth_cmc<`startperiod'-35)
	gen cohort3647_5B= (datebirth_cmc>=`startperiod'-35 & datebirth_cmc<`endperiod'-47)
	gen cohort3647_5C= (datebirth_cmc>=`endperiod'-47 & datebirth_cmc<`endperiod'-35)
	gen died_3647_5A=((aad>=36 & aad<=47) & cohort3647_5A==1)
	gen died_3647_5B=((aad>=36 & aad<=47) & cohort3647_5B==1)
	gen died_3647_5C=((aad>=36 & aad<=47) & cohort3647_5C==1)

* 48-59 months 
	gen cohort4859_5A= (datebirth_cmc>=`startperiod'-59 & datebirth_cmc<`startperiod'-47)
	gen cohort4859_5B= (datebirth_cmc>=`startperiod'-47 & datebirth_cmc<`endperiod'-59)
	gen cohort4859_5C= (datebirth_cmc>=`endperiod'-59 & datebirth_cmc<`endperiod'-47)
	gen died_4859_5A=((aad>=48 & aad<=59) & cohort4859_5A==1)
	gen died_4859_5B=((aad>=48 & aad<=59) & cohort4859_5B==1)
	gen died_4859_5C=((aad>=48 & aad<=59) & cohort4859_5C==1)
end


/******************************************************************************
					4) Generate dataset child_mortality_computationDHS
*******************************************************************************/

* Endline in September 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==9
	child_mortality_DHS_temp 1333 1365 
save "data/temp/AEJ2018_child_mortality_computationDHS.dta", replace

* Endline in October 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==10
	child_mortality_DHS_temp 1333 1366 
	append using "data/temp/AEJ2018_child_mortality_computationDHS.dta"
save "data/temp/AEJ2018_child_mortality_computationDHS.dta", replace

* Endline in November 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==11
	child_mortality_DHS_temp 1333 1367
	append using "data/temp/AEJ2018_child_mortality_computationDHS.dta"
save "data/temp/AEJ2018_child_mortality_computationDHS.dta", replace

* Endline in December 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==12
	child_mortality_DHS_temp 1333 1368 
	append using "data/temp/AEJ2018_child_mortality_computationDHS.dta"
save "data/temp/AEJ2018_child_mortality_computationDHS.dta", replace

		
