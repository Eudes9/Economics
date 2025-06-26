***********************************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate postnatal_TableA6.dta and antenatal_TableA6.dta for the analysis in Table A.6 in the Online Appendix of the paper 					
*               Date: June 2018       
*                                                      
***********************************************************************************************************************************************************
	
/*******************************************************************************
		1) generate postnatal_TableA6.dta and antenatal_TableA6.dta
*******************************************************************************/

/* Generate the two dataset to capture whether within the Hh there is a pregnant woman (antenatal_TableA6.dta)
	or a woman that has recently delivered (postnatal_TableA6.dta) */
	
use "data/AEJ2018_postnatal.dta", clear
	keep if treatment==1 
	collapse (min)postnatal_delivery_m, by(villageid hhid) 
	// i.e. how many months ago was pregnant
save "data/temp/AEJ2018_postnatal_TableA6.dta", replace

use "data/AEJ2018_antenatal.dta", clear
	keep if treatment==1 
	collapse (min)antenatal_pregnancy, by(villageid hhid) 
	// i.e. how far are you in your pregnancy
save "data/temp/AEJ2018_antenatal_TableA6.dta", replace



/******************************************************************************
		2) generate postnatal_TableA6.dta and antenatal_TableA6.dta
*******************************************************************************/

* 1) 
use "data/AEJ2018_HHroster_ab18.dta", clear
	gen HHroster_ab18_whereVHT=(HHroster_ab18_where_1==8 | HHroster_ab18_where_2==8 ///
					| HHroster_ab18_where_3==8) if HHroster_ab18_where!=""
	gen HHroster_ab18_whereCHP=(HHroster_ab18_where_1==10 | HHroster_ab18_where_2==10 | ///
					HHroster_ab18_where_3==10) if HHroster_ab18_where!="" 
	collapse (max) HHroster_ab18_whereVHT HHroster_ab18_whereCHP, by(hhid)	
save "data/temp/AEJ2018_Interactions_TableA6_rosterab18.dta", replace // will be used for point B below


* 2) 
use "data/AEJ2018_HHroster_5to17.dta", clear
	gen HHroster_5to17_whereVHT=(HHroster_5to17_where_1==8 | HHroster_5to17_where_2==8 | ///
					 HHroster_5to17_where_3==8) if HHroster_5to17_where!=""
	gen HHroster_5to17_whereCHP=(HHroster_5to17_where_1==10 | ///
					 HHroster_5to17_where_2==10 | HHroster_5to17_where_3==10) if HHroster_5to17_where!=""
	collapse (max) HHroster_5to17_whereVHT HHroster_5to17_whereCHP, by(hhid)					 
save "data/temp/AEJ2018_Interactions_TableA6_roster5to17.dta", replace // will be used for point B below


* 3) 
use "data/AEJ2018_HHmain.dta", clear
	gen HH_knowledge_hinfoVHT=( HH_knowledge_hinfo_1==9 |  HH_knowledge_hinfo_2==9 |  ///
						HH_knowledge_hinfo_3==9 |  HH_knowledge_hinfo_4==9 |  ///
						HH_knowledge_hinfo_5==9 |  HH_knowledge_hinfo_6==9 |  ///
						HH_knowledge_hinfo_7==9 |  HH_knowledge_hinfo_8==9) ///
						if HH_knowledge_hinfo!=""
	gen HH_knowledge_hinfoCHP=( HH_knowledge_hinfo_1==11 |  HH_knowledge_hinfo_2==11 | ///
						HH_knowledge_hinfo_3==11 |  HH_knowledge_hinfo_4==11 | ///
						HH_knowledge_hinfo_5==11 |  HH_knowledge_hinfo_6==11 | ///
						HH_knowledge_hinfo_7==11 |  HH_knowledge_hinfo_8==11) ///
						if HH_knowledge_hinfo!=""
						
	gen HH_interactions_30dVHT = (regexm(HH_interactions_30d_org_oth,"health") | ///
						regexm(HH_interactions_30d_org_oth,"vht") | regexm(HH_interactions_30d_org_oth,"VHT") | ///
						regexm(HH_interactions_30d_org_oth,"Vht") | regexm(HH_interactions_30d_org_oth,"Health") | ///
						regexm(HH_interactions_30d_org_oth,"Village")) // i.e. include missings
	gen HH_interactions_30dCHP=(HH_interactions_30d_org_1==3 | HH_interactions_30d_org_2==3)
		replace HH_interactions_30dCHP=1 if HH_interactions_CHP30d>0 & HH_interactions_CHP30d!=. 
		
	keep hhid HH_knowledge_hinfoVHT HH_knowledge_hinfoCHP HH_interactions_30dVHT HH_interactions_30dCHP
save "data/temp/AEJ2018_Interactions_TableA6_HHmain.dta", replace // will be used for point B below
	
	
* 4)
use "data/AEJ2018_malaria.dta", clear
	gen malaria_treatednetVHT=(malaria_bednet_where==7 & malaria_treatednet==1) 
	gen malaria_treatednetCHP=(malaria_bednet_where==9 & malaria_treatednet==1)
	
	gen malaria_ACT_1=((malaria_medicine_1<10 & malaria_medicine_1_check==2) | ///
		malaria_medicine_1_corrected<10) if malaria_medicine_1!=. 
		replace malaria_ACT_1=0 if malaria_treated==0	// i.e. equal to 1 if treated the sick child AND with ACT
	gen malaria_medicineACTVHT_1=(malaria_ACT_1==1 & (malaria_medicine_1s_a==9 | ///
		malaria_medicine_1s_b==9)) if malaria_medicine_1source!=""
	gen malaria_medicineACTVHTCHP_1=(malaria_ACT_1==1 & (malaria_medicine_1s_a==11 | ///
		malaria_medicine_1s_b==11)) if malaria_medicine_1source!=""
	gen malaria_ACT_2=((malaria_medicine_2<10 & malaria_medicine_2_check==2) | ///
		malaria_medicine_2_corrected<10) if malaria_medicine_2!=.
		replace malaria_ACT_2=0 if  malaria_treated==0	
	gen malaria_medicineACTVHT_2=(malaria_ACT_2==1 & (malaria_medicine_2s_a==9 | ///
		malaria_medicine_2s_b==9)) if malaria_medicine_2source!=""
	gen malaria_medicineACTVHTCHP_2=(malaria_ACT_2==1 & (malaria_medicine_2s_a==11 | ///
		malaria_medicine_2s_b==11)) if malaria_medicine_2source!=""
	gen malaria_medicineACTVHT=(malaria_medicineACTVHT_1 ==1 | malaria_medicineACTVHT_2==1) ///
		if malaria_medicineACTVHT_1!=. | malaria_medicineACTVHT_2!=.
		replace malaria_medicineACTVHT=0 if malaria_ACT_1==0 // i.e. if did not treat or did not buy ACT=0
	gen malaria_medicineACTCHP=(malaria_medicineACTVHTCHP_1 ==1 | ///
		malaria_medicineACTVHTCHP_2 ==1) if malaria_medicineACTVHTCHP_1!=. | ///
		malaria_medicineACTVHTCHP_2!=.
		replace malaria_medicineACTCHP=0 if malaria_ACT_1==0 // i.e. if did not treat or did not buy ACT=0
	
	gen malaria_followupVHT=(malaria_followup_who==5) if malaria_followup_who!=.
		replace malaria_followupVHT=0 if malaria_followup==0 // i.e. if no follow up
	gen malaria_followupCHP=(malaria_followup_who==3) if malaria_followup_who!=.
		replace malaria_followupCHP=0 if malaria_followup==0 // i.e. if no follow up	
	
	gen malaria_referralVHT=(malaria_referral_who==5) if malaria_referral_who!=.
		replace malaria_referralVHT=0 if malaria_referral==0 // i.e. if no referral
	gen malaria_referralCHP=(malaria_referral_who==3) if malaria_referral_who!=.
		replace malaria_referralCHP=0 if malaria_referral==0 // i.e. if no referral
		
	collapse (max)  malaria_treatednetVHT malaria_treatednetCHP malaria_medicineACTVHT ///
					malaria_medicineACTCHP malaria_followupVHT ///
					malaria_followupCHP malaria_referralVHT ///
					malaria_referralCHP, by(hhid)
	save "data/temp/AEJ2018_Interactions_TableA6_malaria.dta", replace // will be used for point B below
	
	
* 5)
use "data/AEJ2018_diarrhea.dta", clear 
	gen diarrhea_medicineVHT_1=(diarrhea_medicine_1s_a==9 |  ///
		diarrhea_medicine_1s_b==9) if diarrhea_medicine_1source!=""
	gen diarrhea_medicineCHP_1=(diarrhea_medicine_1s_a==11 |  ///
		diarrhea_medicine_1s_b==11) if diarrhea_medicine_1source!=""
	gen diarrhea_medicineVHT_2=(diarrhea_medicine_2s_a==9 |  ///
		diarrhea_medicine_2s_b==9) if diarrhea_medicine_2source!=""
	gen diarrhea_medicineCHP_2=(diarrhea_medicine_2s_a==11 |  ///
		diarrhea_medicine_2s_b==11) if diarrhea_medicine_2source!=""
	gen diarrhea_medicineVHT=(diarrhea_medicineVHT_1==1 | diarrhea_medicineVHT_2==1) if ///
		diarrhea_medicineVHT_1!=. | diarrhea_medicineVHT_2!=.
		replace diarrhea_medicineVHT=0 if diarrhea_treated==0 // i.e. if did not treat 
	gen diarrhea_medicineCHP=(diarrhea_medicineCHP_1==1 | diarrhea_medicineCHP_2==1) if ///
		diarrhea_medicineCHP_1!=. | diarrhea_medicineCHP_1!=.
		replace diarrhea_medicineCHP=0 if diarrhea_treated==0 // i.e. if did not treat 
	
	gen diarrhea_followupVHT=(diarrhea_followup_who==5) if diarrhea_followup_who!=.
		replace diarrhea_followupVHT=0 if diarrhea_followup==0 // i.e. if no follow up
	gen diarrhea_followupCHP=(diarrhea_followup_who==3) if diarrhea_followup_who!=.
		replace diarrhea_followupCHP=0 if diarrhea_followup==0 // i.e. if no follow up
	
	gen diarrhea_referralVHT=(diarrhea_referral_who==5) if diarrhea_referral_who!=.
		replace diarrhea_referralVHT=0 if diarrhea_referral==0 // i.e. if no referral
	gen diarrhea_referralCHP=(diarrhea_referral_who==3) if diarrhea_referral_who!=.
		replace diarrhea_referralCHP=0 if diarrhea_referral==0 // i.e. if no referral
		
	collapse (max) diarrhea_medicineVHT diarrhea_medicineCHP ///
					diarrhea_followupVHT diarrhea_followupCHP  ///
					diarrhea_referralVHT diarrhea_referralCHP, by(hhid)
save "data/temp/AEJ2018_Interactions_TableA6_diarrhea.dta", replace // will be used for point B below
		
		
* 6) 
use "data/AEJ2018_postnatal.dta", clear
	gen postnatal_boughtkitVHT=(postnatal_boughtkit==7) if postnatal_boughtkit!=.
		replace postnatal_boughtkitVHT=0 if postnatal_deliverykit==0 // i.e. if did not use safe delivery kit
	gen postnatal_boughtkitCHP=(postnatal_boughtkit==9) if postnatal_boughtkit!=.
		replace postnatal_boughtkitCHP=0 if postnatal_deliverykit==0 // i.e. if did not use safe delivery kit
		
	gen postnatal_whoadvisedVHT=(postnatal_whoadvised_1==4 | postnatal_whoadvised_2==4 | ///
		postnatal_whoadvised_3==4 | postnatal_whoadvised_4==4 | ///
		postnatal_whoadvised_5==4) if postnatal_whoadvised!=""
		replace postnatal_whoadvisedVHT=0 if postnatal_adviseddeliv==0 // i.e. if not advised
	gen postnatal_whoadvisedCHP=(postnatal_whoadvised_1==5 | postnatal_whoadvised_2==5 | ///
						postnatal_whoadvised_3==5 | postnatal_whoadvised_4==5 | ///
						postnatal_whoadvised_5==5) if postnatal_whoadvised!=""
		replace postnatal_whoadvisedCHP=0 if postnatal_adviseddeliv==0 // i.e. if not advised
		
	gen postnatal_followupVHT=(postnatal_followup_who_1==4 | postnatal_followup_who_2==4 | ///
						postnatal_followup_who_3==4 | postnatal_followup_who_4==4) ///
						if postnatal_followup_who!=""
		replace postnatal_followupVHT=0 if postnatal_followup==0 // i.e. if no followup
	gen postnatal_followupCHP=(postnatal_followup_who_1==5 | postnatal_followup_who_2==5 | ///
						postnatal_followup_who_3==5 | postnatal_followup_who_4==5) ///
						if postnatal_followup_who!=""
		replace postnatal_followupCHP=0 if postnatal_followup==0 // i.e. if no followup
		
	gen postnatal_VitA_whereVHT=(postnatal_VitA_where_1==6 | postnatal_VitA_where_2==6 | ///
						postnatal_VitA_where_3==6) if postnatal_VitA_where!=""
		replace postnatal_VitA_whereVHT=0 if postnatal_VitA==0 // i.e. if didn't get any
	gen postnatal_VitA_whereCHP=(postnatal_VitA_where_1==8 | postnatal_VitA_where_2==8 | ///
						postnatal_VitA_where_3==8) if postnatal_VitA_where!=""
		replace postnatal_VitA_whereCHP=0 if postnatal_VitA==0 // i.e. if didn't get any
		
	collapse (max)   postnatal_boughtkitVHT postnatal_boughtkitCHP ///
					 postnatal_whoadvisedVHT postnatal_whoadvisedCHP ///
					 postnatal_followupVHT postnatal_followupCHP ///
					 postnatal_VitA_whereVHT postnatal_VitA_whereCHP, by(hhid)
save "data/temp/AEJ2018_Interactions_TableA6_postnatal.dta", replace // will be used for point B below

		
* 7)
use "data/AEJ2018_antenatal.dta", clear
	gen antenatal_referralVHT=(antenatal_whoreferred_1==4 | antenatal_whoreferred_2==4) if antenatal_whoreferred!=""
		replace antenatal_referralVHT=0 if antenatal_referral==0 // i.e. nobody referred
	gen antenatal_referralCHP=(antenatal_whoreferred_1==5 | antenatal_whoreferred_2==5) if antenatal_whoreferred!=""
		replace antenatal_referralCHP=0 if antenatal_referral==0 // i.e. nobody referred
	
	gen antenatal_vitVHT=( antenatal_vit_where_1==8  |  antenatal_vit_where_2==8 |  ///
						antenatal_vit_where_3==8) if antenatal_vit_where!=""
		replace antenatal_vitVHT=0 if antenatal_vit==0 // i.e. did not get any
	gen antenatal_vitCHP=( antenatal_vit_where_1==10  |  antenatal_vit_where_2==10 |  ///
						antenatal_vit_where_3==10) if antenatal_vit_where!=""
		replace antenatal_vitCHP=0 if antenatal_vit==0 // i.e. did not get any
		
	collapse (max) 	antenatal_referralVHT antenatal_referralCHP ///
					antenatal_vitVHT antenatal_vitCHP, by(hhid)
save "data/temp/AEJ2018_Interactions_TableA6_antenatal.dta", replace // will be used for point B below

