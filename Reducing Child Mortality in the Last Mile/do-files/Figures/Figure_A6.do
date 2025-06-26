*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate Figure A.6 in the Online Appendix of the paper 
*               Date: June 2018       
*                                                      
*******************************************************************************************************************************************

use "data/temp/AEJ2018_child_mortality_computation.dta", clear // dataset generated previously for Table_3.do
	collapse (sum)  death_under5 count_month_u5 death_under1 ///
					count_month_u1 death_under1m count_month_u1m, ///
					by (branchid treatment)
	replace count_month_u5=count_month_u5/12
	replace count_month_u1=count_month_u1/12
	
	gen mrate_u5= (death_under5/count_month_u5)*1000
	gen mrate_u1= (death_under1/count_month_u1)*1000
	gen mrate_u1m= (death_under1m/count_month_u1m)*1000
	
	gen mrate_u5_Ttemp=mrate_u5 if treatment==1
		bysort branchid: egen mrate_u5_T=max(mrate_u5_Ttemp)
	gen mrate_u5_Ctemp=mrate_u5 if treatment==0
		bysort branchid: egen mrate_u5_C=max(mrate_u5_Ctemp)
	gen mrate_u1_Ttemp=mrate_u1 if treatment==1
		bysort branchid: egen mrate_u1_T=max(mrate_u1_Ttemp)
	gen mrate_u1_Ctemp=mrate_u1 if treatment==0
		bysort branchid: egen mrate_u1_C=max(mrate_u1_Ctemp)
	gen mrate_u1m_Ttemp=mrate_u1m if treatment==1
		bysort branchid: egen mrate_u1m_T=max(mrate_u1m_Ttemp)
	gen mrate_u1m_Ctemp=mrate_u1m if treatment==0
		bysort branchid: egen mrate_u1m_C=max(mrate_u1m_Ctemp)		
	
	collapse mrate_u5_T mrate_u5_C mrate_u1_T mrate_u1_C mrate_u1m_T mrate_u1m_C, by(branchid)
	
	* generate a simple auxiliary variable for getting the 45 degrees line
	gen line_45=mrate_u5_T
	replace line_45=0 if branchid==1
	replace line_45=35 if branchid==42

	*OUTPUT:
		*\Program Impact Across Geographic Zones
		twoway (scatter mrate_u5_T mrate_u5_C, leg(off) ///
				xtitle( "Under-5 mortality (Control)") ///
				ytitle( "Under-5 mortality (Treatment)") ///
				yscale(range(0 30)) ylabel(0(5)35) xscale(range(0 30)) ///
				xlabel(0(5)35)) (line line_45 line_45)
