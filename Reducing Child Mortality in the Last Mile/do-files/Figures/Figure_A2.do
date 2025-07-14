*******************************************************************************************************************************************
*				
* 				Paper: Reducing Child Mortality in the Last Mile: A Randomized Social Entrepreneurship Intervention in Uganda
*				Authors: Martina Björkman Nyqvist, Andrea Guariso, Jakob Svensson, David Yanagizawa-Drott 
*				Purpose: Generate Figure A.2 in the Online Appendix of the paper 
*               Date: June 2018       
*                                                      
*******************************************************************************************************************************************

/*******************************************************************************
								Figure A2
			Yearly CHP Purchases and Margins Across Products
*******************************************************************************/	
use "data/AEJ2018_CHPpurchases2013.dta", replace
	gsort -retailmargin_avg
	gen order=_n
	labmask order,values(label)
	
	*OUTPUT:
		*\Yearly CHP Purchases and Margins Across Products		
		twoway (bar retailmargin_avg order, yaxis(1) ///
				ytitle( "Average retail margin (%)") yscale(range(0 70)) ///
				ylabel(0(10)70) xtitle( "") xlabel(1(1)13, angle(ninety) ///
				valuelabel) legend(off) ysize(5)) ///
				(connected sales_2013 order, yaxis(2) ///
				ytitle( "CHPs purchases (Millions of UGX)", axis(2))) 
