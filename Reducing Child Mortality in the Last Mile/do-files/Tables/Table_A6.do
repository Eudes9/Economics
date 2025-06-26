*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate output for Table A.5 in the Online Appendix of the paper 
*               Date: June 2018       
*                                                      
*******************************************************************************************************************************************

/* Preliminary step: run the file PRE_Table_6.do to generate the dataset wealth_quantiles.dta for the analysis  */
run "do files/Tables/PRE_Table_A6.do"
	
/*******************************************************************************
							HHs ever visited by a CHP 
*******************************************************************************/	
use "data/AEJ2018_HHmain.dta", clear
	keep if treatment==1 // only look at treatment villages
	
	*OUTPUT:
		*\(i) Distance from CHP	
		xi: reg HH_interactions_CHPever HH_distanceCHP i.branchid, robust cluster(villageid)	
					
		*\(ii) Distance from VHT				
		xi: reg HH_interactions_CHPever HH_distanceVHT i.branchid, robust cluster(villageid)				
	
		*\(iii) Distance from CHP and Distance from VHT		
		xi: reg HH_interactions_CHPever HH_distanceCHP HH_distanceVHT i.branchid, robust cluster(villageid)
	
	merge 1:1 villageid hhid using "data/temp/AEJ2018_postnatal_TableA6.dta", nogen // dataset generated in PRE_Table_A6.do
	merge 1:1 villageid hhid using "data/temp/AEJ2018_antenatal_TableA6.dta", nogen // dataset generated in PRE_Table_A6.do
	gen HH_priority=(postnatal_delivery_m<7 | (antenatal_pregnancy!=.)) // i.e. delivered in past 6 months or currently at least 3 months pregnant
	
	*OUTPUT:
		*\(iv) Priority HH				
		xi: reg HH_interactions_CHPever HH_priority i.branchid, robust cluster(villageid)	
		

/*******************************************************************************
						HHs visited by a CHP in last 30 days
*******************************************************************************/	
	
	*OUTPUT:
		*\(v) Distance from CHP
		xi: reg HH_interactions_CHPlastmonth HH_distanceCHP i.branchid, robust cluster(villageid)
		
		*\(vi) Distance from VHT
		xi: reg HH_interactions_CHPlastmonth HH_distanceVHT i.branchid, robust cluster(villageid)
		
		*\(vii) Distance from CHP and Distance from VHT
		xi: reg HH_interactions_CHPlastmonth HH_distanceCHP HH_distanceVHT i.branchid, robust cluster(villageid)
	
	*OUTPUT:
		*\(viii) Priority HH		
		xi: reg HH_interactions_CHPlastmonth HH_priority i.branchid, robust cluster(villageid)	


/*******************************************************************************
							Ever interacted with
*******************************************************************************/
use "data/AEJ2018_HHmain.dta", clear
	merge 1:1 hhid using "data/temp/AEJ2018_Interactions_TableA6_rosterab18.dta", nogen	
	merge 1:1 hhid using "data/temp/AEJ2018_Interactions_TableA6_roster5to17.dta", nogen
	merge 1:1 hhid using "data/temp/AEJ2018_Interactions_TableA6_HHmain.dta", nogen
	merge 1:1 hhid using "data/temp/AEJ2018_Interactions_TableA6_malaria.dta", nogen
	merge 1:1 hhid using "data/temp/AEJ2018_Interactions_TableA6_diarrhea.dta", nogen
	merge 1:1 hhid using "data/temp/AEJ2018_Interactions_TableA6_postnatal.dta", nogen
	merge 1:1 hhid using "data/temp/AEJ2018_Interactions_TableA6_antenatal.dta", nogen

	gen interactionCHP=(HHroster_ab18_whereCHP==1 | HHroster_5to17_whereCHP==1 | HH_knowledge_hinfoCHP==1 | ///
		HH_interactions_30dCHP==1 | malaria_treatednetCHP==1 | malaria_medicineACTCHP==1 | ///
		malaria_followupCHP==1 | malaria_referralCHP==1 | diarrhea_medicineCHP==1 | ///
		diarrhea_followupCHP==1 | diarrhea_referralCHP==1 | postnatal_boughtkitCHP==1 | ///
		postnatal_whoadvisedCHP==1 | postnatal_followupCHP==1 | postnatal_VitA_whereCHP==1 | ///
		antenatal_referralCHP==1 | antenatal_vitCHP==1)
	gen interactionVHT=(HHroster_ab18_whereVHT==1 | HHroster_5to17_whereVHT==1 | HH_knowledge_hinfoVHT==1 | ///
		HH_interactions_30dVHT==1 | malaria_treatednetVHT==1 | malaria_medicineACTVHT==1 | ///
		malaria_followupVHT==1 | malaria_referralVHT==1 | diarrhea_medicineVHT==1 | ///
		diarrhea_followupVHT==1 | diarrhea_referralVHT==1 | postnatal_boughtkitVHT==1 | ///
		postnatal_whoadvisedVHT==1 | postnatal_followupVHT==1 | postnatal_VitA_whereVHT==1 | ///
		antenatal_referralVHT==1 | antenatal_vitVHT==1)
	
	*OUTPUT:
		*\CHP
			*Program impact
			xi: reg interactionCHP treatment i.branchid, robust cluster(villageid)	
			
		*\VHT
			*Program imapct
			xi: reg interactionVHT treatment i.branchid, robust cluster(villageid) 

			
