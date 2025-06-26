* Nettoyer et importer les données
clear all
import delimited "C:\Users\jeane\Documents\empiric_data\finalfolder\fnal_panel.csv", clear
cd "C:\Users\jeane\Documents\empiric_data\finalfolder"

* Préparation du panel
gen date = ym(floor(timeperiod/100), mod(timeperiod, 100))
format date %tm
encode country, generate(country_id)
xtset country_id date

* Générer les leads pour chaque horizon
forvalues h = 0/5 {
    gen comm_`h' = F`h'.communication_service
}

* Initialiser matrices
matrix define irf_matrix_comm = J(6, 10, .)
matrix define se_matrix_comm  = J(6, 10, .)

* Boucle sur les horizons
forvalues h = 0/5 {
    xtscc comm_`h' i.country_id#c.flood_shock ///
        money_supply  exchange_rate ///
        trade_openness gdp construction_ratio ///
        i.date
	* Store model for later tabulation
    eststo model_`h'
    forvalues c = 1/9 {
        matrix irf_matrix_comm[`h'+1, `c'] = _b[c.flood_shock#`c'.country_id]
        matrix se_matrix_comm[`h'+1, `c']  = _se[c.flood_shock#`c'.country_id]
    }
    matrix irf_matrix_comm[`h'+1, 10] = `h'
}

esttab model_0 model_1 model_2 model_3 model_4 model_5 ///
    using "IRF_regressions_robust_flood_communication.tex", ///
    se star(* 0.1 ** 0.05 *** 0.01) ///
    label title("Effect of flood Shock on Communication (by Horizon)") ///
    mtitles("h=0" "h=1" "h=2" "h=3" "h=4" "h=5") ///
    replace

* Calcul des intervalles de confiance
matrix irf_upper_comm = irf_matrix_comm + 1.96 * se_matrix_comm
matrix irf_lower_comm = irf_matrix_comm - 1.96 * se_matrix_comm

* Sauvegarder les matrices en variables
svmat irf_matrix_comm, name(irf_)
svmat irf_lower_comm,  name(lower_)
svmat irf_upper_comm,  name(upper_)

* Calcul des intervalles de confiance à 68% (≈ ±1 SE)
matrix irf_upper68_comm = irf_matrix_comm + 1 * se_matrix_comm
matrix irf_lower68_comm = irf_matrix_comm - 1 * se_matrix_comm

* Convertir en variables
svmat irf_upper68_comm, name(upper68_)
svmat irf_lower68_comm, name(lower68_)

rename lower68_1 irf_lower68_Austria
rename lower68_2 irf_lower68_France
rename lower68_3 irf_lower68_Germany
rename lower68_4 irf_lower68_Hungary
rename lower68_5 irf_lower68_Italy
rename lower68_6 irf_lower68_Poland
rename lower68_7 irf_lower68_Slovakia
rename lower68_8 irf_lower68_Slovenia
rename lower68_9 irf_lower68_Spain

rename upper68_1 irf_upper68_Austria
rename upper68_2 irf_upper68_France
rename upper68_3 irf_upper68_Germany
rename upper68_4 irf_upper68_Hungary
rename upper68_5 irf_upper68_Italy
rename upper68_6 irf_upper68_Poland
rename upper68_7 irf_upper68_Slovakia
rename upper68_8 irf_upper68_Slovenia
rename upper68_9 irf_upper68_Spain



* Renommer les colonnes
rename irf_1 irf_Austria
rename irf_2 irf_France
rename irf_3 irf_Germany
rename irf_4 irf_Hungary
rename irf_5 irf_Italy
rename irf_6 irf_Poland
rename irf_7 irf_Slovakia
rename irf_8 irf_Slovenia
rename irf_9 irf_Spain
rename irf_10 horizon

rename lower_1 irf_lower_Austria
rename lower_2 irf_lower_France
rename lower_3 irf_lower_Germany
rename lower_4 irf_lower_Hungary
rename lower_5 irf_lower_Italy
rename lower_6 irf_lower_Poland
rename lower_7 irf_lower_Slovakia
rename lower_8 irf_lower_Slovenia
rename lower_9 irf_lower_Spain

rename upper_1 irf_upper_Austria
rename upper_2 irf_upper_France
rename upper_3 irf_upper_Germany
rename upper_4 irf_upper_Hungary 
rename upper_5 irf_upper_Italy
rename upper_6 irf_upper_Poland
rename upper_7 irf_upper_Slovakia
rename upper_8 irf_upper_Slovenia
rename upper_9 irf_upper_Spain

* Exporter les graphiques
local countries "Austria France Germany Hungary Italy Poland Slovakia Slovenia Spain"

foreach c of local countries {
    twoway ///
    (rarea irf_upper_`c' irf_lower_`c' horizon, color(gs14) lw(none)) ///
	(rarea irf_upper68_`c' irf_lower68_`c' horizon, color(gs12) lwidth(none)) /// <-- 68% CI
    (line irf_`c' horizon, lcolor(black) lwidth(medium)), ///
        title("flood–`c'", size(medsmall) color(black)) ///
        ytitle("Consumer Price index for Communication Service", size(small)) ///
        xtitle("Horizon (months)", size(small)) ///
        ylabel(, angle(horizontal) labsize(small) nogrid) ///
        xlabel(0(1)5, angle(90) labsize(vsmall)) ///
        legend(off) ///
        graphregion(color(white)) ///
        plotregion(margin(zero)) ///
        yline(0, lcolor(gs8) lpattern(dash)) ///
        scheme(s1color)
		
    graph export "C:\Users\jeane\Documents\empiric_data\finalfolder\Figures\robustness\flood\communication\IRF_communication_service_`c'.png", ///
        width(1000) height(700) replace
}





