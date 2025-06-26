*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate wealth_quantiles.dta for the analysis in Table A.5 in the Online Appendix of the paper 
*               Date: June 2018       
*                                                      
*******************************************************************************************************************************************

use "data/AEJ2018_HHmain.dta", clear
	gen HH_mobilephone=(HH_phone==1 | HH_anyone_phone==1) if HH_anyone_phone!=. | HH_anyone_phone!=. 
	gen HH_finished_floor=(HH_floor_material!=1 & HH_floor_material!=777) if HH_floor_material!=.c 
	/// high quality includes: parquet, wood, bricks, concrete, tiles, mosaic, cement, stones, plastic, carpets 
	replace HH_finished_floor=1 if regexm(HH_floor_material_oth,"Plast")==1 | ///
								regexm(HH_floor_material_oth,"Carp")==1
	gen HH_roof_irontiles=(HH_roof_material!=1) if HH_roof_material!=.c 
	// high quality includes: iron, tiles, asbestos, ceiling 	
	replace HH_roof_irontiles=0 if regexm(HH_roof_material_oth, "yet")==1

	pca HH_mobilephone HH_clothes HH_meals HH_electricity HH_TV HH_radio HH_finished_floor HH_roof_irontiles
	estat kmo
	predict assetindex_pca
		label var assetindex_pca "mobile, clothes, meals, electricity, TV, radio, floor, roof" 	
	cap erase "data/temp/AEJ2018_wealth_quantiles.dta"
	levelsof villageid, local(villages)
		foreach vill in `villages' {
			preserve
				keep if villageid==`vill'
				xtile quartile=assetindex_pca, nq(4)
				xtile quantile_2=assetindex_pca, nq(2)
				keep assetindex_pca quartile quantile_2 hhid
				cap append using "data/temp/AEJ2018_wealth_quantiles.dta"
				save "data/temp/AEJ2018_wealth_quantiles.dta", replace
			restore
		}


