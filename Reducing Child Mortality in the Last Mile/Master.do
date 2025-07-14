
clear all 
set more off
cd ""	// set the current directory 
cap log close
log using "data/do-files/AEJ2018_Reducing_Child_Mortality_in_the_Last_Mile.txt", text replace // records output in the log file

/*******************************************************************************
				GENERATE TABLES INCLUDED IN THE PAPER 
*******************************************************************************/

	*TABLE 1: Baseline Characteristics
		do "data/do-files/Tables/Table_1.do"
		
	*TABLE 2: Baseline Characteristics of Households not Lost to Follow-up and Surveyed at Endline
		do "data/do-files/Tables/Table_2.do"
		
	*TABLE 3: Program Impact on Child Mortality
		do "data/do-files/Tables/Table_3.do"
		
	*TABLE 4: Program Impact on Child Weight, Height, and Hemoglobin Levels
		do "data/do-files/Tables/Table_4.do"

	*TABLE 5: Program Impact on CHP Interaction and Health Knowledge
		do "data/do-files/Tables/Table_5.do"
		
	*TABLE 6: Program Impact on Preventive and Treatment Services
		do "data/do-files/Tables/Table_6.do"
		
	*TABLE 7: Program Impact on iCCM and MNCH Services
		do "data/do-files/Tables/Table_7.do"
		
	*TABLE 8: Population Data and Flows
		do "data/do-files/Tables/Table_8.do"
		
/*******************************************************************************
				GENERATE TABLES INCLUDED IN THE ONLINE APPENDIX
*******************************************************************************/

	*TABLE A4: Program Impact on Health Visits
		do "do files/Tables/Table_A4.do"
		
	*TABLE A5: Under-5 Mortality by Wealth Quantiles 
		do "do files/Tables/Table_A5.do"
		
	*TABLE A6: CHPs Activity
		do "do files/Tables/Table_A6.do"


/*******************************************************************************
				GENERATE FIGURES INCLUDED IN THE ONLINE APPENDIX
*******************************************************************************/
	
	*Figure A2: Yearly CHP Purchases and Margins Across Products
	do "do files/Figures/Figure_A2.do"
	
	*Figure A3: CHP Monthly Purchases
	do "do files/Figures/Figure_A3.do"
	
	*Figure A5: Correlations Between Child Mortality and Intermediate Outcomes
	do "do files/Figures/Figure_A5.do"
	
	*Figure A6: Program Impact Across Geographic Zones
	do "do files/Figures/Figure_A6.do"
	
log close
