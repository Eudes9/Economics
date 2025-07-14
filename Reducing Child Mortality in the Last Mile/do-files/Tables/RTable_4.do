
ssc install zscore06

use "data/AEJ2018_anthro.dta", clear
	gen length=round(anthro_height,.5) 
	egen weight=rowmean(anthro_weight_1 anthro_weight_2 anthro_weight_3)
	recode anthro_swell anthro_female (0=2)	// edits needed for the command zscore06 to run correctly 
	zscore06 , a(anthro_age) s(anthro_female) h(length) w(weight) measure(anthro_standlay) o(anthro_swell)
	gen byte neg2_haz06=(haz06 <-2) if !missing(haz06) 
	gen byte neg2_whz06=(whz06 <-2) if !missing(whz06) 
	
	*drop irrealistic outliers
	foreach var in haz06 {
		replace `var'=. if `var'<-6 | `var'>6
		replace neg2_`var'=. if `var'<-6 | `var'>6
	} 
	foreach var in whz06 {
		replace `var'=. if `var'<-6 | `var'>5
		replace neg2_`var'=. if `var'<-6 | `var'>5
	} 

summarize haz06 neg2_haz06
tabulate neg2_haz06

	
/* Create a matrix to store results */
matrix output = J(13, 7, .)  // 13 rows for outcomes, 7 columns for variables

/******************************************************************************
					Height for age z-score 
*******************************************************************************/
	
	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg haz06 treatment  i.branchid, robust cluster(villageid)
			matrix output[1,1] = _b[treatment]  // Coefficient for treatment effect
			matrix output[2,1] = _se[treatment]  // Standard error for treatment effect
			*Mean control 		
			xi: reg haz06 treatment, robust cluster(villageid)
			matrix output[3,1] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[4,1] = e(N) 
		
		*\Panel B: Children under 24 months
			*Program impact
			xi: reg haz06 treatment  i.branchid if anthro_age<24, robust cluster(villageid)
			matrix output[5,1] = _b[treatment]  // Coefficient for treatment effect
			matrix output[6,1] = _se[treatment]  // Standard error for treatment effect
			*Mean control
			xi: reg haz06 treatment if anthro_age<24, robust cluster(villageid)
			matrix output[7,1] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[8,1] = e(N) 
		

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg haz06 treatment  i.branchid if anthro_age>=24, robust cluster(villageid)
			matrix output[9,1] = _b[treatment]  // Coefficient for treatment effect
			matrix output[10,1] = _se[treatment]  // Standard error for treatment effect
			*Mean control
			xi: reg haz06 treatment if anthro_age>=24, robust cluster(villageid)			
			matrix output[11,1] = _b[_cons]  //Real mean control (from margins, the first element is the intercept)
			matrix output[12,1] = e(N) 
			
			

/******************************************************************************
					Height for age z-score < -2
*******************************************************************************/

	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg neg2_haz06 treatment i.branchid, robust cluster(villageid)
			matrix output[1,2] = _b[treatment]  // Coefficient for treatment effect
			matrix output[2,2] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control 		
			xi: reg neg2_haz06 treatment, robust cluster(villageid)
		    matrix output[3,2] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[4,2] = e(N) 
		
		*\Panel B: Children under 24 months
			*Program impact
			xi: reg neg2_haz06 treatment i.branchid if anthro_age<24, robust cluster(villageid)
			matrix output[5,2] = _b[treatment]  // Coefficient for treatment effect
			matrix output[6,2] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg neg2_haz06 treatment if anthro_age<24, robust cluster(villageid)
			matrix output[7,2] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[8,2] = e(N) 

		*\Panel C: Children 24-60 months, 
			*Program impact
			xi: reg neg2_haz06 treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			matrix output[9,2] = _b[treatment]  // Coefficient for treatment effect
			matrix output[10,2] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg neg2_haz06 treatment if anthro_age>=24, robust cluster(villageid)
			matrix output[11,2] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[12,2] = e(N) 


/******************************************************************************
					Weight for height z-score 
*******************************************************************************/

	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg whz06 treatment  i.branchid, robust cluster(villageid)
			matrix output[1,3] = _b[treatment]  // Coefficient for treatment effect
			matrix output[2,3] = _se[treatment]  // Standard error for treatment effect
			
			
			*Mean control
			xi: reg whz06 treatment, robust cluster(villageid)
			matrix output[3,3] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[4,3] = e(N) 

			
		*\Panel B: Children under 24 months
			*Program impact
			xi: reg whz06 treatment i.branchid if anthro_age<24, robust cluster(villageid)
			matrix output[5,3] = _b[treatment]  // Coefficient for treatment effect
			matrix output[6,3] = _se[treatment]  // Standard error for treatment effect
			
			
			
			*Mean control
			xi: reg whz06 treatment if anthro_age<24, robust cluster(villageid)
			matrix output[7,3] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[8,3] = e(N) 

			

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg whz06 treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			matrix output[9,3] = _b[treatment]  // Coefficient for treatment effect
			matrix output[10,3] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg whz06 treatment if anthro_age>=24, robust cluster(villageid)
			matrix output[11,3] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[12,3] = e(N) 


/******************************************************************************
					Weight for height z-score < -2
*******************************************************************************/

	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg neg2_whz06 treatment i.branchid, robust cluster(villageid)
			matrix output[1,4] = _b[treatment]  // Coefficient for treatment effect
			matrix output[2,4] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg neg2_whz06 treatment, robust cluster(villageid)
			matrix output[3,4] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[4,4] = e(N) 


		*\Panel B: Children under 24 months
			*Program impact
			xi: reg neg2_whz06 treatment i.branchid if anthro_age<24, robust cluster(villageid)
			matrix output[5,4] = _b[treatment]  // Coefficient for treatment effect
			matrix output[6,4] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg neg2_whz06 treatment if anthro_age<24, robust cluster(villageid)
			matrix output[7,4] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[8,4] = e(N) 

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg neg2_whz06 treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			matrix output[9,4] = _b[treatment]  // Coefficient for treatment effect
			matrix output[10,4] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg neg2_whz06 treatment if anthro_age>=24, robust cluster(villageid)
			matrix output[11,4] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[12,4] = e(N) 


/******************************************************************************
						Hemoglobine level
*******************************************************************************/

	gen hb_10_child= anthro_hemoglobin<10 if !missing(anthro_hemoglobin) 
		label variable hb_10_child "Child's HB<10g/dl: moderate to severe anemia"

	*OUTPUT:
		*\Panel A: Children under 60 months, 
			*Program impact 		
			xi: reg anthro_hemoglobin treatment i.branchid, robust cluster(villageid)
			matrix output[1,5] = _b[treatment]  // Coefficient for treatment effect
			matrix output[2,5] = _se[treatment]  // Standard error for treatment effect
			
			*Mean Control		
			xi: reg anthro_hemoglobin treatment, robust cluster(villageid)
			matrix output[3,5] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[4,5] = e(N) 


		*\Panel B: Children under 24 months
			*Program impact
			xi: reg anthro_hemoglobin treatment i.branchid if anthro_age<24, robust cluster(villageid)
			matrix output[5,5] = _b[treatment]  // Coefficient for treatment effect
			matrix output[6,5] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg anthro_hemoglobin treatment if anthro_age<24, robust cluster(villageid)
			matrix output[7,5] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[8,5] = e(N) 

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg anthro_hemoglobin treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			matrix output[9,5] = _b[treatment]  // Coefficient for treatment effect
			matrix output[10,5] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg anthro_hemoglobin treatment if anthro_age>=24, robust cluster(villageid)
			matrix output[11,5] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[12,5] = e(N) 



/******************************************************************************
					Hemoglobine level < 10g/dl
*******************************************************************************/

	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg hb_10_child treatment i.branchid, robust cluster(villageid)
			matrix output[1,6] = _b[treatment]  // Coefficient for treatment effect
			matrix output[2,6] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control	
			xi: reg hb_10_child treatment, robust cluster(villageid)
			matrix output[3,6] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[4,6] = e(N) 


		*\Panel B: Children under 24 months
			*Program impact
			xi: reg hb_10_child treatment i.branchid if anthro_age<24, robust cluster(villageid)
			matrix output[5,6] = _b[treatment]  // Coefficient for treatment effect
			matrix output[6,6] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg hb_10_child treatment if anthro_age<24, robust cluster(villageid)
			matrix output[7,6] = _b[_cons]   //Real mean control (from margins, the first element is the intercept)
			matrix output[8,6] = e(N) 

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg hb_10_child treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			matrix output[9,6] = _b[treatment]  // Coefficient for treatment effect
			matrix output[10,6] = _se[treatment]  // Standard error for treatment effect
			
			*Mean control
			xi: reg hb_10_child treatment if anthro_age>=24, robust cluster(villageid)
			matrix output[11,6] = _b[treatment]  // Coefficient for treatment effect
			matrix output[12,6] = _se[treatment]  // Standard error for treatment effect
			
			/* Rename the variables in the dataset */
clear
svmat output, names(c)

rename c1 		Heightforagezscore 
rename c2       Heightforagezscore2
rename c3 		Weightforheight
rename c4 		Weightforheight2
rename c5 		Hemoglobinlevel
rename c6 		Hemoglobinlevel10

gen Variable = ""
replace Variable = "Program impact" if _n == 1
replace Variable = "Standard_deviation" if _n == 2
replace Variable = "Mean_control" if _n == 3
replace Variable = "Observations" if _n == 4
replace Variable = "Program impact" if _n == 5
replace Variable = "Standard_deviation" if _n == 6
replace Variable = "Mean_control" if _n == 7
replace Variable = "Observations" if _n == 8
replace Variable = "Program impact" if _n == 9
replace Variable = "Standard_deviation" if _n == 10
replace Variable = "Mean_control" if _n == 11
replace Variable = "Observations" if _n == 12
replace Variable = "BranchFE" if _n == 13

/* Add a new observation */
gen BranchFE = ""  // Initialize the BranchFE variable


list Variable Heightforagezscore  Heightforagezscore2 Weightforheight Weightforheight2 Hemoglobinlevel Hemoglobinlevel10,noobs clean


