
clear all 
set more off
cd ""	// set the current directory 
cap log close
log using "data/do-files/AEJ2018_Reducing_Child_Mortality_in_the_Last_Mile.txt", text replace // records output in the log file


	*TABLE 1: Baseline Characteristics
		do "data/do-files/Tables/RTable_1.do"
		
	*TABLE 2: Baseline Characteristics of Households not Lost to Follow-up and Surveyed at Endline
		do "data/do-files/Tables/RTable_2.do"
		
	*TABLE 3: Program Impact on Child Mortality
		do "data/do-files/Tables/RTable_3.do"
		
	*TABLE 4: Program Impact on Child Weight, Height, and Hemoglobin Levels
		do "data/do-files/Tables/RTable_4.do"

	*TABLE 5: Program Impact on CHP Interaction and Health Knowledge
		do "data/do-files/Tables/RTable_5.do"
		
	*TABLE 6: Program Impact on Preventive and Treatment Services
		do "data/do-files/Tables/RTable_6.do"
		

log close
