*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate Figure A.3 in the Online Appendix of the paper 
*               Date: June 2018       
*                                                      
*******************************************************************************************************************************************


/*******************************************************************************
							  Figure A3
						CHP Monthly Purchases
*******************************************************************************/
use "data/AEJ2018_sales_byCHP.dta", replace	
	
	*OUTPUT:
		*\CHP Monthly Purchases, density	
		kdensity earnings2013_avg, title("") xtitle("Monthly Purchases (UGX)")
