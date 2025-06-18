clear all

capture log close
set more off
/* create log file*/

log using "D:\Master in Economics_AMSE\Stata\Group_Project_Stata\Working_Stata_Child_Mortality_Under_5\Log_Group_Project_Child_Mortality_Under_5.log", replace
/* Final Version_ clean version that contain only need results, have deleted all other attempted equation */
/*all attempt code are in last version*/

/*import data set and put first row as variable */

import excel "D:\Master in Economics_AMSE\Stata\Group_Project_Stata\Working_Stata_Child_Mortality_Under_5\P_Data_Extract_From_World_Development_Indicators.xlsx", sheet("Data") firstrow

/*Section 1 Cleaning and */


/*Filter the dataset to include only the year 2000 - 2021*/

keep if Time>=2000 & Time<2022

/* rename of variable */

rename Mortalityrateunder5per10 Child_mort 

rename L basic_water_rural
rename Currenthealthexpenditureof Health_Expenditure

rename Adolescentfertilityratebirth FertilityRate_Adolescent

rename AQ Sanitation_Access

rename GDPpercapitaconstant2015US gdp_percap_const

/*keep only used variables*/

keep CountryCode CountryName Time Child_mort basic_water_rural Health_Expenditure FertilityRate_Adolescent Sanitation_Access gdp_percap_const

/* generate log of gdp*/

gen lgdp_const= log(gdp_percap_const)

/* Section 2 descriptive statistics*/
/* summarize and plot*/
describe
summarize  Child_mort basic_water_rural Health_Expenditure Sanitation_Access FertilityRate_Adolescent

tabstat Child_mort , by(CountryCode)
tabstat Child_mort , by(Time)

/*Generate mean for each variable per year for plot*/

egen mean_child_mort = mean(Child_mort), by(Time)

egen mean_basic_water_rural = mean(basic_water_rural), by(Time)

egen mean_Health_Expenditure= mean(Health_Expenditure), by(Time)

egen mean_FertilityRate_Adolescent = mean(FertilityRate_Adolescent) , by(Time)

egen mean_Sanitation_Access= mean(Sanitation_Access), by(Time)




/*1.2 plot*/
/*1 the average mortality rate per year */

twoway (scatter mean_child_mort Time,msize(tiny)lwidth (medium)connect(L)) , ///
    title("Average of Child Under 5 Mortality Rate per 1000 Live Births""In Subsaharan Countries from 2020 to 2021", size(small) justification(middle)) ///
    ytitle(" ") ///
	xtitle(" ") ///
	note("Source: WB Development Indicators 2022",position(6)  size(small) justification(left) alignment(bottom))

//2 Mortality vs people using water in rural areal

twoway ( scatter  mean_child_mort Time,  yaxis(1) lc(red) msize(tiny) connect(L) lwidth (medium) ) ( scatter mean_basic_water_rural Time, yaxis(2) lc(black) connect(L) msize(tiny) lwidth (medium)), ///
    title("Relationship between Child Under 5 Mortality Rate per 1000 Live Births" "and People Using At Least Basic Drinking Water Services In Rural Area",size(small)justification(middle)) ///
    legend(label(1 "Average of Mortality Rate") label(2 "Percentage of Basic Water Used") size(small)) ///
	ytitle("Average of Mortality Rate", axis(1)size(small)) ytitle("Percentage of Basic Drinking Water Used",axis(2) size(small)) ///
	note("Source: WB Development Indicators 2022",position(6)  size(small) justification(left) alignment(bottom))		
	
	
//3 Mortality and Health Expenditure

twoway ( scatter  mean_child_mort Time,  yaxis(1) lc(red) msize(tiny) connect(L) lwidth (medium) ) ( scatter mean_Sanitation_Access Time, yaxis(2) lc(black) connect(L) msize(tiny) lwidth (medium)), ///
    title("Relationship between Child Under 5 Mortality Rate per 1000 Live Births" "and Current Health Expenditure as Percentage of GDP",size(small)justification(middle)) ///
    legend(label(1 " Average of Mortality Rate") label(2 "Health Expenditure as Percentage of GDP") size(small)) ///
	ytitle("Average of Mortality Rate", axis(1)size(small)) ytitle("Health Expenditure as Percentage of GDP",axis(2) size(small)) ///
	note("Source: WB Development Indicators 2022",position(6)  size(small) justification(left) alignment(bottom))	
	
	
//4 Mortality vs Sanitation

twoway ( scatter  mean_child_mort Time,  yaxis(1) lc(red) msize(tiny) connect(L) lwidth (medium) ) ( scatter mean_Sanitation_Access Time, yaxis(2) lc(black) connect(L) msize(tiny) lwidth (medium)), ///
    title("Relationship between Child Under 5 Mortality Rate per 1000 Live Births" "And People Using At Least Basic Sanitation Services In Rural Areas",size(small)justification(middle)) ///
    legend(label(1 " Average of Mortality Rate") label(2 "Access to Sanitation services") size(small)) ///
	ytitle("Average of Mortality Rate", axis(1)size(small)) ytitle("Percentage of Using At Least Basic Sanitation",axis(2) size(small)) ///
	note("Source: WB Development Indicators 2022",position(6)  size(small) justification(left) alignment(bottom))

//5 Mortality vs Adolescent fertility rate birth	

twoway ( scatter  mean_child_mort Time,  yaxis(1) lc(red) msize(tiny) connect(L) lwidth (medium) ) ( scatter mean_FertilityRate_Adolescent Time, yaxis(2) lc(black) connect(L) msize(tiny) lwidth (medium)), ///
    title("Relationship between Child Under 5 Mortality Rate per 1000 Live Births" "and Adolescent Fertility Rate per 1000 women(15-18)",size(small)justification(middle)) ///
    legend(label(1 " Average of Mortality Rate") label(2 "Access to Sanitation services") size(small)) ///
	ytitle("Average of Mortality Rate", axis(1)size(small)) ytitle("Average of Fertility rate per 1000 women(15-18)",axis(2) size(small)) ///
	note("Source: WB Development Indicators 2022",position(6)  size(small) justification(left) alignment(bottom))

/* 6 Plot the mortality rates for each country*/

graph hbar (asis) Child_mort if Time==2021, over( CountryName, sort(Child_mort) descending label(labsize(vsmall))) ///
    title("Child mortality rate for Sub-sahara African countries,2021",size(small)) ///
	ytitle("") ///
    note("Source: WB Development Indicators 2022",position(6)  size(small) justification(left) alignment(bottom))



/*
Section 3: Methodology of your empirical analysis
– Basic equation(s) for your regressions.
– Potential biases, how are you going to/could you take
them into account?
– Main equation(s) for your regressions
*/
describe

/* First Naive equation */

reg Child_mort basic_water_rural

/*Significant, negative */


/*Country fixed effects */

tab CountryCode, gen(Dcountry)

/*Regression with chosen controls and fixed effects */

reg Child_mort basic_water_rural lgdp Health_Expenditure FertilityRate_Adolescent Sanitation_Access Dcountry*, vce(cluster CountryCode)

ssc install outreg2
outreg2 using results.doc, replace

log close