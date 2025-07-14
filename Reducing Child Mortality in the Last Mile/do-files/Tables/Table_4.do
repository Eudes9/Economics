*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table 4 in the paper 
*               Date: June 2018       
*                                                      
******************************************************************************************************************************************

/* Note: to run this do file you first need to install the package zscore06
		available from http://fmwww.bc.edu/RePEc/bocode/z/ */
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

	
/******************************************************************************
					Height for age z-score 
*******************************************************************************/
	
	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg haz06 treatment  i.branchid, robust cluster(villageid)
			
			*Mean control 		
			xi: reg haz06 treatment, robust cluster(villageid)
			
		
		*\Panel B: Children under 24 months
			*Program impact
			xi: reg haz06 treatment  i.branchid if anthro_age<24, robust cluster(villageid)
			
			*Mean control
			xi: reg haz06 treatment if anthro_age<24, robust cluster(villageid)
			

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg haz06 treatment  i.branchid if anthro_age>=24, robust cluster(villageid)
			
			*Mean control
			xi: reg haz06 treatment if anthro_age>=24, robust cluster(villageid)			
	

/******************************************************************************
					Height for age z-score < -2
*******************************************************************************/

	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg neg2_haz06 treatment i.branchid, robust cluster(villageid)
			
			*Mean control 		
			xi: reg neg2_haz06 treatment, robust cluster(villageid)
		
		*\Panel B: Children under 24 months
			*Program impact
			xi: reg neg2_haz06 treatment i.branchid if anthro_age<24, robust cluster(villageid)
			
			*Mean control
			xi: reg neg2_haz06 treatment if anthro_age<24, robust cluster(villageid)
			

		*\Panel C: Children 24-60 months, 
			*Program impact
			xi: reg neg2_haz06 treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			
			*Mean control
			xi: reg neg2_haz06 treatment if anthro_age>=24, robust cluster(villageid)
			


/******************************************************************************
					Weight for height z-score 
*******************************************************************************/

	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg whz06 treatment  i.branchid, robust cluster(villageid)
			
			*Mean control
			xi: reg whz06 treatment, robust cluster(villageid)

			
		*\Panel B: Children under 24 months
			*Program impact
			xi: reg whz06 treatment i.branchid if anthro_age<24, robust cluster(villageid)
			
			*Mean control
			xi: reg whz06 treatment if anthro_age<24, robust cluster(villageid)

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg whz06 treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			
			*Mean control
			xi: reg whz06 treatment if anthro_age>=24, robust cluster(villageid)


/******************************************************************************
					Weight for height z-score < -2
*******************************************************************************/

	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg neg2_whz06 treatment i.branchid, robust cluster(villageid)
			
			*Mean control
			xi: reg neg2_whz06 treatment, robust cluster(villageid)

		*\Panel B: Children under 24 months
			*Program impact
			xi: reg neg2_whz06 treatment i.branchid if anthro_age<24, robust cluster(villageid)
			
			*Mean control
			xi: reg neg2_whz06 treatment if anthro_age<24, robust cluster(villageid)

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg neg2_whz06 treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			
			*Mean control
			xi: reg neg2_whz06 treatment if anthro_age>=24, robust cluster(villageid)


/******************************************************************************
						Hemoglobine level
*******************************************************************************/

	gen hb_10_child= anthro_hemoglobin<10 if !missing(anthro_hemoglobin) 
		label variable hb_10_child "Child's HB<10g/dl: moderate to severe anemia"

	*OUTPUT:
		*\Panel A: Children under 60 months, 
			*Program impact 		
			xi: reg anthro_hemoglobin treatment i.branchid, robust cluster(villageid)
			
			*Program impact 		
			xi: reg anthro_hemoglobin treatment, robust cluster(villageid)


		*\Panel B: Children under 24 months
			*Program impact
			xi: reg anthro_hemoglobin treatment i.branchid if anthro_age<24, robust cluster(villageid)
			
			*Mean control
			xi: reg anthro_hemoglobin treatment if anthro_age<24, robust cluster(villageid)

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg anthro_hemoglobin treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			
			*Mean control
			xi: reg anthro_hemoglobin treatment if anthro_age>=24, robust cluster(villageid)



/******************************************************************************
					Hemoglobine level < 10g/dl
*******************************************************************************/

	*OUTPUT:
		*\Panel A: Children under 60 months
			*Program impact 		
			xi: reg hb_10_child treatment i.branchid, robust cluster(villageid)
			
			*Mean control	
			xi: reg hb_10_child treatment, robust cluster(villageid)


		*\Panel B: Children under 24 months
			*Program impact
			xi: reg hb_10_child treatment i.branchid if anthro_age<24, robust cluster(villageid)
			
			*Mean control
			xi: reg hb_10_child treatment if anthro_age<24, robust cluster(villageid)

		*\Panel C: Children 24-60 months
			*Program impact
			xi: reg hb_10_child treatment i.branchid if anthro_age>=24, robust cluster(villageid)
			
			*Mean control
			xi: reg hb_10_child treatment if anthro_age>=24, robust cluster(villageid)


