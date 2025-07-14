*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: 	1) Define the program to compute infant mortality at baseline 
*							2) Run the program and generate the infant_mortality_computation_2018 dataset	
*							3) Prepare the dataset for the household-level analysis (Panel B)
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************
 
/******************************************************************************************
				1) Define the program to compute child mortality measures 
*******************************************************************************************/

capture program drop infant_mortality_baseline
program define infant_mortality_baseline
	/* the program has two arguments, expressed as dates (month and year) according to CMC standard: 
			1) the beginning of the time interval of interest 
			2) the end of the time interval of interest -- i.e. when the baseline survey took place */
	args startperiod endperiod
	
	* drop children that died before the beginning of the interval of interest or after its end 
	drop if datebirth_cmc<`startperiod' | datebirth_cmc>=`endperiod'
	
	* generate the variables that count the number of months the child was exposed to the risk of death before turning 1 year old
	* define first birthday (i.e. when the child turns 1 year old)
	gen date12m_cmc=datebirth_cmc+12
	* define age at the beginning of the study period 
	gen aabeginning=(`startperiod'-datebirth_cmc)-0.5 
	* define age at the end of the study period
	gen aaend=(`endperiod'-datebirth_cmc)+0.5 
	* compute month of exposure under 1 year:
	gen count_month_u1=(datedeath_cmc-`startperiod')+0.5 if ///
		datebirth_cmc<`startperiod' & datedeath_cmc>=`startperiod' & ///
		datedeath_cmc<=`endperiod' & aad<12 & aabeginning<12
	replace count_month_u1=(date12m_cmc-`startperiod')+0.5 ///
		if datebirth_cmc<`startperiod' & datedeath_cmc>=`startperiod' ///
		& datedeath_cmc<=`endperiod' & aad>=12 & aabeginning<12
	replace count_month_u1=(date12m_cmc-`startperiod')+0.5 if ///
		datebirth_cmc<`startperiod' & (datedeath_cmc>`endperiod' | died==0) ///
		& aabeginning<12 & date12m_cmc>=`startperiod' & date12m_cmc<=`endperiod'
	replace count_month_u1=(`endperiod'-`startperiod')+1 if ///
		datebirth_cmc<`startperiod' & (datedeath_cmc>`endperiod' | died==0) ///
		& aabeginning<12 & date12m_cmc>`endperiod'	
	replace count_month_u1=(`endperiod'-datebirth_cmc)+0.5 ///
		if datebirth_cmc>=`startperiod' & datebirth_cmc<=`endperiod' ///
		& (datedeath_cmc>`endperiod' | died==0) & aaend<12		
	replace count_month_u1=12 if datebirth_cmc>=`startperiod' & ///
		datebirth_cmc<=`endperiod' & (datedeath_cmc>`endperiod' | died==0) & aaend>=12
	replace count_month_u1=datedeath_cmc-datebirth_cmc if ///
		datebirth_cmc>=`startperiod' & datedeath_cmc<=`endperiod' & aad<12
	replace count_month_u1=12 if datebirth_cmc>=`startperiod' ///
		& datedeath_cmc<=`endperiod' & aad>=12
	* compute the deaths under 1y	
	gen death_under1=(datedeath_cmc>=`startperiod' & datedeath_cmc<=`endperiod' & aad<12)	 
end		


/******************************************************************************
			2) Generate dataset infant_mortality_computation_2018
*******************************************************************************/

* Endline in September 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==9
	* Set startperiod= 1305 (Sept 2008) endperiod=1332  (Dec 2010)
	infant_mortality_baseline 1305 1332 // 
save "data/temp/AEJ2018_infant_mortality_computation.dta", replace
* Endline in October 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==10
	infant_mortality_baseline 1306 1332 
	append using "data/temp/AEJ2018_infant_mortality_computation.dta"
save "data/temp/AEJ2018_infant_mortality_computation.dta", replace
* Endline in November 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==11
	infant_mortality_baseline 1307 1332
	append using "data/temp/AEJ2018_infant_mortality_computation.dta"
save "data/temp/AEJ2018_infant_mortality_computation.dta", replace
* Endline in December 2013
use "data/AEJ2018_child_mortality.dta", clear
	keep if dateofinterview_m==12
	infant_mortality_baseline 1308 1332 
	append using "data/temp/AEJ2018_infant_mortality_computation.dta"
save "data/temp/AEJ2018_infant_mortality_computation.dta", replace


		
/*******************************************************************************
		3) Prepare the dataset for the household-level analysis (Panel B)
*******************************************************************************/

* Note: use endline information to reconstruct composition at baseline
* i) consider children under 5 at endline (taking into account also children that died in the study period)
use "data/AEJ2018_child_mortality.dta", clear
	drop if datebirth_cmc>1333 // drop if born after Jan 2011
	drop if datedeath_cmc<1333 // drop if died before Jan 2011
	gen HHmembers_A=1
	collapse (sum) HHmembers_A, by(hhid treatment villageid branchid)
save "data/temp/AEJ2018_HHmembers_A.dta", replace

* ii) consider children between 5 and 17 at endline 
use "data/AEJ2018_HHroster_5to17.dta", clear
	gen HHmembers_B=1
	collapse (sum) HHmembers_B, by(hhid treatment villageid branchid)
save "data/temp/AEJ2018_HHmembers_B.dta", replace

* iii) consider HH members 18 and abobve at endline
use "data/AEJ2018_HHroster_ab18.dta", clear
	gen HHmembers_C=1
	collapse (sum) HHmembers_C, by(hhid treatment villageid branchid)	
save "data/temp/AEJ2018_HHmembers_C.dta", replace
