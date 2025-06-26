
ssc install avg_effect	
		
use "data/AEJ2018_HHmain.dta", clear		
matrix output = J(6, 8, .)  // 13 rows for outcomes, 7 columns for variables

/******************************************************************************
					(i) HH visited by a CHP in last 30 days 	 
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_interactions_CHPlastmonth treatment i.branchid, robust cluster(villageid)
		matrix output[1,1] = _b[treatment]  // Coefficient for treatment effect
		matrix output[2,1] = _se[treatment]  // Standard error for treatment effect
		matrix output[6,1] = e(r2)  // R² from the regression
	
		*\Mean control
		xi: reg HH_interactions_CHPlastmonth treatment, robust cluster(villageid)
		matrix output[3,1] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
		//matrix output[4,1] = "YES"
		matrix output[5,1] = e(N) 
		
/******************************************************************************
				 (ii) Diarrhea from drinking untrated water 	 
*******************************************************************************/
		
	*OUTPUT:
		*\Program Impact 
		xi: reg HH_knowledge_diarrhea treatment i.branchid, robust cluster(villageid)
		matrix output[1,2] = _b[treatment]  // Coefficient for treatment effect
		matrix output[2,2] = _se[treatment]  // Standard error for treatment effect
		matrix output[6,2] = e(r2)  // R² from the regression

		
		*\Mean control
		xi: reg HH_knowledge_diarrhea treatment, robust cluster(villageid)
		matrix output[3,2] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
		//matrix output[4,2] = "YES"
		matrix output[5,2] = e(N) 


/******************************************************************************
				 (iii) Zinc is effective against diarrhea
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_knowledge_diarrheazinc treatment i.branchid, robust cluster(villageid)
		matrix output[1,3] = _b[treatment]  // Coefficient for treatment effect
		matrix output[2,3] = _se[treatment]  // Standard error for treatment effect
		matrix output[6,3] = e(r2)  // R² from the regression

		
		*Mean control
		xi: reg HH_knowledge_diarrheazinc treatment, robust cluster(villageid)
		matrix output[3,3] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
		//matrix output[4,3] = "YES"
		matrix output[5,3] = e(N) 

		
/******************************************************************************
			(iv) Mosquito bites are the only cause of malaria
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_knowledge_malaria_onlymosq treatment i.branchid, robust cluster(villageid)	
		matrix output[1,4] = _b[treatment]  // Coefficient for treatment effect
		matrix output[2,4] = _se[treatment]  // Standard error for treatment effect
		matrix output[6,4] = e(r2)  // R² from the regression

		
		*\Mean control
		xi: reg HH_knowledge_malaria_onlymosq treatment, robust cluster(villageid)
		matrix output[3,4] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
		//matrix output[4,4] = "YES"
		matrix output[5,4] = e(N) 

		
/******************************************************************************
					(v) Aware of food with added nutrients
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_knowledge_nutrients treatment i.branchid, robust cluster(villageid)
		matrix output[1,5] = _b[treatment]  // Coefficient for treatment effect
		matrix output[2,5] = _se[treatment]  // Standard error for treatment effect
		matrix output[6,5] = e(r2)  // R² from the regression

		
		*\Mean control 	
		xi: reg HH_knowledge_nutrients treatment, robust cluster(villageid)
		matrix output[3,5] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
		//matrix output[4,5] = "YES"
		matrix output[5,5] = e(N) 


/******************************************************************************
					(vi) Bednets can help prevent malaria
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 		
		xi: reg HH_knowledge_nets treatment i.branchid, robust cluster(villageid)	
		matrix output[1,6] = _b[treatment]  // Coefficient for treatment effect
		matrix output[2,6] = _se[treatment]  // Standard error for treatment effect
		matrix output[6,6] = e(r2)  // R² from the regression
		
		*\Mean control		
		xi: reg HH_knowledge_nets treatment, robust cluster(villageid)
		matrix output[3,6] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
		//matrix output[4,6] = "YES"
		matrix output[5,6] = e(N) 



/******************************************************************************
					(vi) Women should deliver at hospital
*******************************************************************************/

	*OUTPUT:
		*\Program Impact 	
		xi: reg HH_knowledge_delivery_hf treatment i.branchid, robust cluster(villageid)	
		matrix output[1,7] = _b[treatment]  // Coefficient for treatment effect
		matrix output[2,7] = _se[treatment]  // Standard error for treatment effect
		matrix output[6,7] = e(r2)  // R² from the regression
		
		*\Mean control
		xi: reg HH_knowledge_delivery_hf treatment, robust cluster(villageid)	
		matrix output[3,7] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
		//matrix output[4,7] = "YES"
		matrix output[5,7] = e(N) 

/******************************************************************************
					(vii) Average standardized effects
*******************************************************************************/

xi i.branchid // generate _Ibranchid*
	*OUTPUT:
		*\Program Impact 		
avg_effect 	HH_knowledge_diarrhea HH_knowledge_diarrheazinc HH_knowledge_malaria_onlymosq HH_knowledge_nutrients ///
					HH_knowledge_nets HH_knowledge_delivery_hf, ///
					x(treatment _Ibranchid* ) effectvar(treatment) controltest(treatment==0) keepmissing cluster(villageid)	

matrix list output 	
clear
svmat output, names(c)

rename c1 		HHvisited
rename c2       Diarrhea
rename c3 		Zinc
rename c4 		Mosquito
rename c5 		Aware
rename c6 		Bednets
rename c7       Women
rename c8		Average

gen Variable = ""
replace Variable = "Program_impact" if _n == 1
replace Variable = "Standard_deviation" if _n == 2
replace Variable = "Mean_control" if _n == 3
replace Variable = "BranchFE" if _n == 4
replace Variable = "Observations" if _n == 5
replace Variable = "R²" if _n == 6

list Variable HHvisited Diarrhea Zinc Mosquito Aware Bednets Women Average,noobs clean













					
					