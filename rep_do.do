/*
1. Please upload files to a folder of your preference 
2. Change the working directory below in line 6 and uncomment
3. Selmlog.ado file needs to be placed in this directory. See http://www.parisschoolofeconomics.com/gurgand-marc/selmlog/selmlog13.html 
*/
// global folder = "C:\Research\sustainable-intensification\GitHub_files\isfmca-replication"
version 18.0
cd ${folder}
pwd
use rep_data.dta, clear
global xlist female age edu hhsize depratio dis_market dis_extension plot_distance land_certificate poorsoil goodsoil farmsize tTLU_owned if_pesticides maize barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations if_loan if_nonfarm ext_visit ext_training fellow_farmer rain_py d_year2 d_year3 
global ylist female age edu hhsize depratio  dis_market dis_extension plot_distance land_certificate poorsoil goodsoil farmsize tTLU_owned if_pesticides maize barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations if_loan if_nonfarm ext_visit ext_training fellow_farmer rain_py  d_year2 d_year3
global iv sd_rainfall his_average
local temp female age edu hhsize depratio dis_market dis_extension plot_distance land_certificate poorsoil goodsoil farmsize tTLU_owned if_pesticides maize barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations if_loan if_nonfarm ext_visit ext_training fellow_farmer rain_py 
local i=1
foreach var of varlist `temp' {   
qui egen m_`var'=mean(`var'), by(qid)
local i=`i'+1 
}
global m_listx m_female m_age m_edu m_hhsize m_depratio m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_farmsize m_tTLU_owned m_if_pesticides m_maize m_barley m_shock_count m_coping_cost_sum m_organizations m_if_loan m_if_nonfarm m_ext_visit m_ext_training m_fellow_farmer m_rain_py 
global m_listy m_female m_age m_edu m_hhsize m_depratio m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_farmsize m_tTLU_owned m_if_pesticides m_maize m_barley m_shock_count m_coping_cost_sum m_organizations m_if_loan m_if_nonfarm m_ext_visit m_ext_training m_fellow_farmer m_rain_py 
mlogit isfm $xlist $iv $m_listx i.region, base(1) cluster (qid)
outreg2 using mlogit_isfm, excel replace sideway bdec(2) cdec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Adoption")
mlogit isfmca $xlist $iv $m_listx i.region, base(1) cluster (qid)
outreg2 using mlogit_isfm, excel append sideway bdec(2) cdec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Adoption")
rename HDDS hdds
ge hdds1=hdds if isfm==1 //none 
ge hdds2=hdds if isfm==2 //2 isfm
ge hdds3=hdds if isfm==3 //isfm full
do selmlog.ado
selmlog hdds1 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) showm mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict dd1, xb
gen dd001=dd1 if isfm==1
gen dd002=dd1 if isfm==2
gen dd003=dd1 if isfm==3
drop _m1 _m2 _m3 
selmlog hdds2  $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict dd2, xb
gen dd102=dd2 if isfm==2
drop _m1 _m2 _m3
selmlog hdds3  $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict dd3, xb
gen dd113=dd3 if isfm==3
drop _m1 _m2 _m3

**# Probability of experience of food insecurity - one step with SELMLOG
ge food_insecurity1=food_insecurity if isfm==1 //none 
ge food_insecurity2=food_insecurity if isfm==2 //isfm2
ge food_insecurity3=food_insecurity if isfm==3 //isfmfull
do selmlog.ado
selmlog food_insecurity1 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict fi1, xb
gen fi001=fi1 if isfm==1
gen fi002=fi1 if isfm==2
gen fi003=fi1 if isfm==3
drop _m1 _m2 _m3 
selmlog food_insecurity2 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict fi2, xb
gen isfm2effect=fi2 if isfm==2
drop _m1 _m2 _m3 
selmlog food_insecurity3  $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict fi3, xb
gen isfm3effect=fi3 if isfm==3
drop _m1 _m2 _m3 
drop food_insecurity1 food_insecurity2 food_insecurity3

**# food expenditure - MESR one step selmlog
ge def_food_exp1=lndef_food_exp if isfm==1 //none 
ge def_food_exp2=lndef_food_exp if isfm==2 //iv
ge def_food_exp3=lndef_food_exp if isfm==3 //isfm
do selmlog.ado
selmlog def_food_exp1 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict fe1, xb
gen fe001=fe1 if isfm==1
gen fe002=fe1 if isfm==2
gen fe003=fe1 if isfm==3
drop _m1 _m2 _m3
selmlog def_food_exp2 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict fe2, xb
gen isfm2predict1=fe2 if isfm==2
drop _m1 _m2 _m3
selmlog def_food_exp3 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict fe3, xb
gen isfm3predict1=fe3 if isfm==3
drop _m1 _m2 _m3 

**# Poor - MESR with linear probability
ge poor1=poor if isfm==1 //none 
ge poor2=poor if isfm==2 //isfm2
ge poor3=poor if isfm==3 //isfm3
do selmlog.ado
selmlog poor1 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict poorr1, xb
gen poor001=poorr1 if isfm==1
gen poor002=poorr1 if isfm==2
gen poor003=poorr1 if isfm==3
drop _m1 _m2 _m3
selmlog poor2 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region ) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict poorr2, xb
gen poor102=poorr2 if isfm==2
drop _m1 _m2 _m3 
selmlog poor3 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region ) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict poorr3, xb
gen poor113=poorr3 if isfm==3
drop _m1 _m2 _m3 

**# pov_gap - MESR one step selmlog
ge pov_gap1=pov_gap if isfm==1 //none 
ge pov_gap2=pov_gap if isfm==2 //iv
ge pov_gap3=pov_gap if isfm==3 //isfm
do selmlog.ado
selmlog pov_gap1 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region ) boot(100) dmf(1) gen(m) showm mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict gap1, xb
gen ga001=gap1 if isfm==1
gen ga002=gap1 if isfm==2
gen ga003=gap1 if isfm==3
drop _m1 _m2 _m3
selmlog pov_gap2  $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region ) boot(100) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict gap2, xb
gen ga102=gap2 if isfm==2
drop _m1 _m2 _m3 
selmlog pov_gap3  $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region ) boot(100) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict gap3, xb
gen ga113=gap3 if isfm==3
drop _m1 _m2 _m3 

**# pov_severity - MESR one step selmlog
ge pov_severity1=pov_severity if isfm==1 //none 
ge pov_severity2=pov_severity if isfm==2 //iv
ge pov_severity3=pov_severity if isfm==3 //isfm
do selmlog.ado
selmlog pov_severity1 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region ) boot(100) dmf(1) gen(m) showm mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict gap4, xb
gen gap001=gap4 if isfm==1
gen gap002=gap4 if isfm==2
gen gap003=gap4 if isfm==3
drop _m1 _m2 _m3
selmlog pov_severity2 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region ) boot(100) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict gap5, xb
gen gap102=gap5 if isfm==2
drop _m1 _m2 _m3 
selmlog pov_severity3 $ylist $m_listy region, select(isfm=$xlist $iv $m_listx region ) boot(100) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
predict gap6, xb
gen gap113=gap6 if isfm==3
drop _m1 _m2 _m3 
**# putexcel isfm
putexcel set "resultsisfm.xlsx", sheet("ATT") modify
putexcel A2 = ("HDDS")
putexcel A4 = ("Experience of food insecurity")
putexcel A6 = ("Real per capita food expenditure (ln)")
putexcel A8 = ("Probability of being poor")
putexcel A10 = ("Poverty gap")
putexcel A12 = ("Poverty severity")
putexcel A2 = ("Severity of poverty")
putexcel B2 = ("Two ISFM practices")
putexcel B3 = ("Three ISFM practices")
putexcel B4 = ("Two ISFM practices")
putexcel B5 = ("Three ISFM practices")
putexcel B6 = ("Two ISFM practices")
putexcel B7 = ("Three ISFM practices")
putexcel B8 = ("Two ISFM practices")
putexcel B9 = ("Three ISFM practices")
putexcel B10 = ("Two ISFM practices")
putexcel B11 = ("Three ISFM practices")
putexcel B12 = ("Two ISFM practices")
putexcel B13 = ("Three ISFM practices")
putexcel C1 = ("Observed outcome")
putexcel D1 = ("Counterfactual outcome")
putexcel E1 = ("ATT")
putexcel F1 = ("St Err")
putexcel G1 = ("p values")
putexcel H1 = ("Observations")
*isfm vs none hdds
ttest dd102=dd002
gen att1= r(mu_1)- r(mu_2)
putexcel C2 = (r(mu_1))
putexcel D2 = (r(mu_2))
putexcel E2 = (att1)
putexcel F2 = (r(se))
putexcel G2 = (r(p))
putexcel H2 = (r(N_1))
ttest dd113=dd003
gen att2= r(mu_1)- r(mu_2)
putexcel C3 = (r(mu_1))
putexcel D3 = (r(mu_2))
putexcel E3 = (att2)
putexcel F3 = (r(se))
putexcel G3 = (r(p))
putexcel H3 = (r(N_1))
*isfm vs none food insecurity
ttest isfm2effect=fi002
gen att3= r(mu_1)- r(mu_2)
putexcel C4 = (r(mu_1))
putexcel D4 = (r(mu_2))
putexcel E4 = (att3)
putexcel F4 = (r(se))
putexcel G4 = (r(p))
putexcel H4 = (r(N_1))
ttest isfm3effect=fi003
gen att4= r(mu_1)- r(mu_2)
putexcel C5 = (r(mu_1))
putexcel D5 = (r(mu_2))
putexcel E5 = (att4)
putexcel F5 = (r(se))
putexcel G5 = (r(p))
putexcel H5 = (r(N_1))
* isfm vs none food expenditure
ttest isfm2predict1=fe002
gen att5= r(mu_1)- r(mu_2)
putexcel C6 = (r(mu_1))
putexcel D6 = (r(mu_2))
putexcel E6 = (att5)
putexcel F6 = (r(se))
putexcel G6 = (r(p))
putexcel H6 = (r(N_1))
ttest isfm3predict1=fe003
gen att6= r(mu_1)- r(mu_2)
putexcel C7 = (r(mu_1))
putexcel D7 = (r(mu_2))
putexcel E7 = (att6)
putexcel F7 = (r(se))
putexcel G7 = (r(p))
putexcel H7 = (r(N_1))
*isfm2 vs none poor
ttest poor102=poor002
gen att7= r(mu_1)- r(mu_2)
putexcel C8 = (r(mu_1))
putexcel D8 = (r(mu_2))
putexcel E8 = (att7)
putexcel F8 = (r(se))
putexcel G8 = (r(p))
putexcel H8 = (r(N_1))
ttest poor113=poor003
gen att8= r(mu_1)- r(mu_2)
putexcel C9 = (r(mu_1))
putexcel D9 = (r(mu_2))
putexcel E9 = (att8)
putexcel F9 = (r(se))
putexcel G9 = (r(p))
putexcel H9 = (r(N_1))
*isfm vs none poverty gap
ttest ga102=ga002
gen att9= r(mu_1)- r(mu_2)
putexcel C10 = (r(mu_1))
putexcel D10 = (r(mu_2))
putexcel E10 = (att9)
putexcel F10 = (r(se))
putexcel G10 = (r(p))
putexcel H10 = (r(N_1))
ttest ga113=ga003
gen att10= r(mu_1)- r(mu_2)
putexcel C11 = (r(mu_1))
putexcel D11 = (r(mu_2))
putexcel E11 = (att10)
putexcel F11 = (r(se))
putexcel G11 = (r(p))
putexcel H11 = (r(N_1))
*isfm vs none poverty severity
ttest gap102=gap002
gen att11= r(mu_1)- r(mu_2)
putexcel C12 = (r(mu_1))
putexcel D12 = (r(mu_2))
putexcel E12 = (att11)
putexcel F12 = (r(se))
putexcel G12 = (r(p))
putexcel H12 = (r(N_1))
ttest gap113=gap003
gen att12= r(mu_1)- r(mu_2)
putexcel C13 = (r(mu_1))
putexcel D13 = (r(mu_2))
putexcel E13 = (att12)
putexcel F13 = (r(se))
putexcel G13 = (r(p))
putexcel H13 = (r(N_1))

drop hdds1 hdds2 hdds3 dd* ga* att* pov_severity1 pov_severity2 pov_severity3 pov_gap1 pov_gap2 pov_gap3 poor1 poor2 poor3 poor1* poorr* poor0* fe1 fe0* fe2 fe3 isfm2predict1 isfm3predict1 isfm3effect def_food_exp1 def_food_exp2 def_food_exp3 isfm2effect fi*
ge hdds1=hdds if isfmca==1 //none 
ge hdds2=hdds if isfmca==2 //isfmca
ge hdds3=hdds if isfmca==3 //ca
ge hdds4=hdds if isfmca==4 //isfm
do selmlog.ado
selmlog hdds1 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd1, xb
gen dd0001=dd1 if isfmca==1
gen dd0002=dd1 if isfmca==2
gen dd0003=dd1 if isfmca==3
gen dd0004=dd1 if isfmca==4
drop _m1 _m2 _m3 _m4
selmlog hdds2  $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd2, xb
gen isfmcaimpact=dd2 if isfmca==2
drop _m1 _m2 _m3 _m4
selmlog hdds3  $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd3, xb
gen caimpact=dd3 if isfmca==3
drop _m1 _m2 _m3 _m4 
selmlog hdds4  $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd4, xb
gen isfmimpact=dd4 if isfmca==4
drop _m1 _m2 _m3 _m4 
drop dd1 dd2 dd3 dd4

**# Probability of experience of food insecurity - one step with SELMLOG - ISFMCA
ge food_insecurity1=food_insecurity if isfmca==1 //none 
ge food_insecurity2=food_insecurity if isfmca==2 //isfmca
ge food_insecurity3=food_insecurity if isfmca==3 //ca
ge food_insecurity4=food_insecurity if isfmca==4 //isfm
do selmlog.ado
selmlog food_insecurity1 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd1, xb
gen fi0001=dd1 if isfmca==1
gen fi0002=dd1 if isfmca==2
gen fi0003=dd1 if isfmca==3
gen fi0004=dd1 if isfmca==4
drop _m1 _m2 _m3 _m4 
selmlog food_insecurity2 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd2, xb
gen isfmcaimpact1=dd2 if isfmca==2
drop _m1 _m2 _m3 _m4 
selmlog food_insecurity3 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd3, xb
gen caimpact1=dd3 if isfmca==3
drop _m1 _m2 _m3 _m4 
selmlog food_insecurity4 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd4, xb
gen isfmimpact1=dd4 if isfmca==4
drop _m1 _m2 _m3 _m4 
drop dd1 dd2 dd3 dd4 food_insecurity1 food_insecurity2 food_insecurity3 food_insecurity4

**# food expenditure - MESR one step selmlog - ISFMCA
ge lndef_food_exp1=lndef_food_exp if isfmca==1 //none 
ge lndef_food_exp2=lndef_food_exp if isfmca==2 //isfmca
ge lndef_food_exp3=lndef_food_exp if isfmca==3 //ca
ge lndef_food_exp4=lndef_food_exp if isfmca==4 //isfm
do selmlog.ado
selmlog lndef_food_exp1 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd1, xb
gen fe0001=dd1 if isfmca==1
gen fe0002=dd1 if isfmca==2
gen fe0003=dd1 if isfmca==3
gen fe0004=dd1 if isfmca==4
drop _m1 _m2 _m3 _m4 
selmlog lndef_food_exp2 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd2, xb
gen isfmcaimpact2=dd2 if isfmca==2
drop _m1 _m2 _m3 _m4 
selmlog lndef_food_exp3 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd3, xb
gen caimpact2=dd3 if isfmca==3
drop _m1 _m2 _m3 _m4 
selmlog lndef_food_exp4 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict dd4, xb
gen isfmimpact2=dd4 if isfmca==4
drop _m1 _m2 _m3 _m4 
drop dd1 dd2 dd3 dd4 hdds1 hdds2 hdds3 hdds4 lndef_food_exp1 lndef_food_exp2 lndef_food_exp3 lndef_food_exp4

**# poor - MESR one step selmlog - ISFMCA
ge poor1=poor if isfmca==1 //none 
ge poor2=poor if isfmca==2 //isfmca
ge poor3=poor if isfmca==3 //ca
ge poor4=poor if isfmca==4 //isfm
do selmlog.ado
selmlog poor1 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict gap1, xb
gen pr0001=gap1 if isfmca==1
gen pr0002=gap1 if isfmca==2
gen pr0003=gap1 if isfmca==3
gen pr0004=gap1 if isfmca==4
drop _m1 _m2 _m3 _m4 
selmlog poor2 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict gap2, xb
gen isfmcaimpact3=gap2 if isfmca==2
drop _m1 _m2 _m3 _m4 
selmlog poor3 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict gap3, xb
gen caimpact3=gap3 if isfmca==3
drop _m1 _m2 _m3 _m4 
selmlog poor4 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict gap4, xb
gen isfmimpact3=gap4 if isfmca==4
drop _m1 _m2 _m3 _m4 
drop gap*

**# pov_gap - MESR one step selmlog - ISFMCA
ge pov_gap1=pov_gap if isfmca==1 //none 
ge pov_gap2=pov_gap if isfmca==2 //isfmca
ge pov_gap3=pov_gap if isfmca==3 //ca
ge pov_gap4=pov_gap if isfmca==4 //isfm
do selmlog.ado
selmlog pov_gap1 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict gap1, xb
gen gap0001=gap1 if isfmca==1
gen gap0002=gap1 if isfmca==2
gen gap0003=gap1 if isfmca==3
gen gap0004=gap1 if isfmca==4
drop _m1 _m2 _m3 _m4 
selmlog pov_gap2 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict gap2, xb
gen isfmcaimpact4=gap2 if isfmca==2
drop _m1 _m2 _m3 _m4 
selmlog pov_gap3 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict gap3, xb
gen caimpact4=gap3 if isfmca==3
drop _m1 _m2 _m3 _m4 
selmlog pov_gap4 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict gap4, xb
gen isfmimpact4=gap4 if isfmca==4
drop _m1 _m2 _m3 _m4 
drop gap1 gap2 gap3

**# pov_severity - MESR one step selmlog - ISFMCA
ge pov_severity1=pov_severity if isfmca==1 //none 
ge pov_severity2=pov_severity if isfmca==2 //isfmca
ge pov_severity3=pov_severity if isfmca==3 //ca
ge pov_severity4=pov_severity if isfmca==4 //isfm
do selmlog.ado
selmlog pov_severity1 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict sev1, xb
gen sev0001=sev1 if isfmca==1
gen sev0002=sev1 if isfmca==2
gen sev0003=sev1 if isfmca==3
gen sev0004=sev1 if isfmca==4
drop _m1 _m2 _m3 _m4 
selmlog pov_severity2 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict sev2, xb
gen isfmcaimpact5=sev2 if isfmca==2
drop _m1 _m2 _m3 _m4 
selmlog pov_severity3 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict sev3, xb
gen caimpact5=sev3 if isfmca==3
drop _m1 _m2 _m3 _m4 
selmlog pov_severity4 $ylist $m_listy region, select(isfmca=$xlist $iv $m_listx region) boot(200) dmf(1) gen(m) mloptions(baseoutcome(1) cluster (qid))
rename m1 _m1
rename m2 _m2
rename m3 _m3
rename m4 _m4
predict sev4, xb
gen isfmimpact5=sev4 if isfmca==4
drop _m1 _m2 _m3 _m4 
drop pov_severity1 pov_severity2 pov_severity3 pov_severity4
**# putexcel isfmca
putexcel set "resultsisfm.xlsx", sheet("ATT2") modify
putexcel A2 = ("HDDS")
putexcel A5 = ("Experience of food insecurity")
putexcel A8 = ("Real per capita food expenditure (ln)")
putexcel A11 = ("Probability of being poor")
putexcel A14 = ("Poverty gap")
putexcel A17 = ("Severity of poverty")
putexcel B2 = ("ISFM and CA")
putexcel B3 = ("CA")
putexcel B4 = ("ISFM")
putexcel B5 = ("ISFM and CA")
putexcel B6 = ("CA")
putexcel B7 = ("ISFM")
putexcel B8 = ("ISFM and CA")
putexcel B9 = ("CA")
putexcel B10 =("ISFM")
putexcel B11 =("ISFM and CA")
putexcel B12 =("CA")
putexcel B13 =("ISFM")
putexcel B14 =("ISFM and CA")
putexcel B15 =("CA")
putexcel B16 =("ISFM")
putexcel B17 =("ISFM and CA")
putexcel B18 =("CA")
putexcel B19 =("ISFM")
putexcel C1 = ("Observed outcome")
putexcel D1 = ("Counterfactual outcome")
putexcel E1 = ("ATT")
putexcel F1 = ("St Err")
putexcel G1 = ("p values")
putexcel H1 = ("Observations")
*isfmca vs none hdds
ttest isfmcaimpact=dd0002
gen att1= r(mu_1)- r(mu_2)
putexcel C2 = (r(mu_1)), nformat(#.###)
putexcel D2 = (r(mu_2)), nformat(#.###)
putexcel E2 = (att1) , nformat(#.###)
putexcel F2 = (r(se)) , nformat(#.###)
putexcel G2 = (r(p)) , nformat(#.###)
putexcel H2 = (r(N_1)), nformat(#.###)
ttest caimpact=dd0003
gen att2= r(mu_1)- r(mu_2)
putexcel C3 = (r(mu_1)), nformat(#.###)
putexcel D3 = (r(mu_2)), nformat(#.###)
putexcel E3 = (att2), nformat(#.###)
putexcel F3 = (r(se)), nformat(#.###)
putexcel G3 = (r(p)), nformat(#.###)
putexcel H3 = (r(N_1)) , nformat(#.###)
ttest isfmimpact=dd0004 
gen att3= r(mu_1)- r(mu_2)
putexcel C4 = (r(mu_1)) , nformat(#.###)
putexcel D4 = (r(mu_2)) , nformat(#.###)
putexcel E4 = (att3) , nformat(#.###)
putexcel F4 = (r(se)), nformat(#.###)
putexcel G4 = (r(p)) , nformat(#.###)
putexcel H4 = (r(N_1)), nformat(#.###)
*isfmca vs none food insecurity
ttest isfmcaimpact1=fi0002
gen att4= r(mu_1)- r(mu_2)
putexcel C5 = (r(mu_1)) , nformat(#.###)
putexcel D5 = (r(mu_2)) , nformat(#.###)
putexcel E5 = (att4) , nformat(#.###)
putexcel F5 = (r(se)) , nformat(#.###)
putexcel G5 = (r(p)) , nformat(#.###)
putexcel H5 = (r(N_1)) , nformat(#.###)
ttest caimpact1=fi0003
gen att5= r(mu_1)- r(mu_2)
putexcel C6 = (r(mu_1)), nformat(#.###)
putexcel D6 = (r(mu_2)), nformat(#.###)
putexcel E6 = (att5), nformat(#.###)
putexcel F6 = (r(se)), nformat(#.###)
putexcel G6 = (r(p)), nformat(#.###)
putexcel H6 = (r(N_1)), nformat(#.###)
ttest isfmimpact1=fi0004
gen att6= r(mu_1)- r(mu_2)
putexcel C7 = (r(mu_1)), nformat(#.###)
putexcel D7 = (r(mu_2)), nformat(#.###)
putexcel E7 = (att6), nformat(#.###)
putexcel F7 = (r(se)), nformat(#.###)
putexcel G7 = (r(p)), nformat(#.###)
putexcel H7 = (r(N_1)), nformat(#.###)
*isfmca vs none food expenditure
ttest isfmcaimpact2=fe0002
gen att7= r(mu_1)- r(mu_2)
putexcel C8 = (r(mu_1)), nformat(#.###)
putexcel D8 = (r(mu_2)), nformat(#.###)
putexcel E8 = (att7), nformat(#.###)
putexcel F8 = (r(se)), nformat(#.###)
putexcel G8 = (r(p)), nformat(#.###)
putexcel H8 = (r(N_1)), nformat(#.###)
ttest caimpact2=fe0003
gen att8= r(mu_1)- r(mu_2)
putexcel C9 = (r(mu_1)), nformat(#.###)
putexcel D9 = (r(mu_2)), nformat(#.###)
putexcel E9 = (att8), nformat(#.###)
putexcel F9 = (r(se)), nformat(#.###)
putexcel G9 = (r(p)), nformat(#.###)
putexcel H9 = (r(N_1)), nformat(#.###)
ttest isfmimpact2=fe0004
gen att9= r(mu_1)- r(mu_2)
putexcel C10 = (r(mu_1)), nformat(#.###)
putexcel D10 = (r(mu_2)), nformat(#.###)
putexcel E10 = (att9), nformat(#.###)
putexcel F10 = (r(se)), nformat(#.###)
putexcel G10 = (r(p)), nformat(#.###)
putexcel H10 = (r(N_1)), nformat(#.###)
*isfmca vs none poor
ttest isfmcaimpact3=pr0002
gen att10= r(mu_1)- r(mu_2)
putexcel C11 = (r(mu_1)), nformat(#.###)
putexcel D11 = (r(mu_2)), nformat(#.###)
putexcel E11 = (att10), nformat(#.###)
putexcel F11 = (r(se)), nformat(#.###)
putexcel G11 = (r(p)), nformat(#.###)
putexcel H11 = (r(N_1)), nformat(#.###)
ttest caimpact3=pr0003
gen att11= r(mu_1)- r(mu_2)
putexcel C12 = (r(mu_1)), nformat(#.###)
putexcel D12 = (r(mu_2)), nformat(#.###)
putexcel E12 = (att11), nformat(#.###)
putexcel F12 = (r(se)), nformat(#.###)
putexcel G12 = (r(p)), nformat(#.###)
putexcel H12 = (r(N_1)), nformat(#.###)
ttest isfmimpact3=pr0004
gen att12= r(mu_1)- r(mu_2)
putexcel C13 = (r(mu_1)), nformat(#.###)
putexcel D13 = (r(mu_2)), nformat(#.###)
putexcel E13 = (att12), nformat(#.###)
putexcel F13 = (r(se)), nformat(#.###)
putexcel G13 = (r(p)), nformat(#.###)
putexcel H13 = (r(N_1)), nformat(#.###)
*isfmca vs none poverty gap
ttest isfmcaimpact4=gap0002
gen att13= r(mu_1)- r(mu_2)
putexcel C14 = (r(mu_1)), nformat(#.###)
putexcel D14 = (r(mu_2)), nformat(#.###)
putexcel E14 = (att13), nformat(#.###)
putexcel F14 = (r(se)), nformat(#.###)
putexcel G14 = (r(p)), nformat(#.###)
putexcel H14 = (r(N_1)), nformat(#.###)
ttest caimpact4=gap0003
gen att14= r(mu_1)- r(mu_2)
putexcel C15 = (r(mu_1)), nformat(#.###)
putexcel D15 = (r(mu_2)), nformat(#.###)
putexcel E15 = (att14), nformat(#.###)
putexcel F15 = (r(se)), nformat(#.###)
putexcel G15 = (r(p)), nformat(#.###)
putexcel H15 = (r(N_1)), nformat(#.###)
ttest isfmimpact4=gap0004
gen att15= r(mu_1)- r(mu_2)
putexcel C16 = (r(mu_1)), nformat(#.###)
putexcel D16 = (r(mu_2)), nformat(#.###)
putexcel E16 = (att15), nformat(#.###)
putexcel F16 = (r(se)), nformat(#.###)
putexcel G16 = (r(p)), nformat(#.###)
putexcel H16 = (r(N_1)), nformat(#.###)
*isfmca vs none severity
ttest isfmcaimpact5=sev0002
gen att16= r(mu_1)- r(mu_2)
putexcel C17 = (r(mu_1)), nformat(#.###)
putexcel D17 = (r(mu_2)), nformat(#.###)
putexcel E17 = (att16), nformat(#.###)
putexcel F17 = (r(se)), nformat(#.###)
putexcel G17 = (r(p)), nformat(#.###)
putexcel H17 = (r(N_1)), nformat(#.###)
ttest caimpact5=sev0003
gen att17= r(mu_1)- r(mu_2)
putexcel C18 = (r(mu_1)), nformat(#.###)
putexcel D18 = (r(mu_2)), nformat(#.###)
putexcel E18 = (att17), nformat(#.###)
putexcel F18 = (r(se)), nformat(#.###)
putexcel G18 = (r(p)), nformat(#.###)
putexcel H18 = (r(N_1)), nformat(#.###)
ttest isfmimpact5=sev0004
gen att18= r(mu_1)- r(mu_2)
putexcel C19 = (r(mu_1)), nformat(#.###)
putexcel D19 = (r(mu_2)), nformat(#.###)
putexcel E19 = (att18), nformat(#.###)
putexcel F19 = (r(se)), nformat(#.###)
putexcel G19 = (r(p)), nformat(#.###)
putexcel H19 = (r(N_1)), nformat(#.###)
**# Sharpened q-values
/*Anderson, M. L. (2008). Multiple inference and gender differences in the effects of early
intervention: A reevaluation of the abecedarian, perry preschool, and early training
projects. Journal of the American Statistical Association, 103 (484), 1481–1495.
https://doi.org/10.1198/016214508000000841 */
* ISFM
clear all
set obs 12
bro
quietly gen float pval = .
replace pval= 0.0001 in 1
replace pval= 0.0001 in 2 
replace pval= 0.0001 in 3
replace pval= 0.0079 in 4
replace pval= 0.0001 in 5
replace pval= 0.0001 in 6
replace pval= 0.0001 in 7
replace pval= 0.0001 in 8
replace pval= 0.0001 in 9
replace pval= 0.0088 in 10
replace pval= 0.0001 in 11
replace pval= 0.0239 in 12
pause

* Collect the total number of p-values tested

quietly sum pval
local totalpvals = r(N)

* Sort the p-values in ascending order and generate a variable that codes each p-value's rank

quietly gen int original_sorting_order = _n
quietly sort pval
quietly gen int rank = _n if pval~=.

* Set the initial counter to 1 

local qval = 1

* Generate the variable that will contain the BKY (2006) sharpened q-values

gen bky06_qval = 1 if pval~=.

* Set up a loop that begins by checking which hypotheses are rejected at q = 1.000, then checks which hypotheses are rejected at q = 0.999, then checks which hypotheses are rejected at q = 0.998, etc.  The loop ends by checking which hypotheses are rejected at q = 0.001.


while `qval' > 0 {
	* First Stage
	* Generate the adjusted first stage q level we are testing: q' = q/1+q
	local qval_adj = `qval'/(1+`qval')
	* Generate value q'*r/M
	gen fdr_temp1 = `qval_adj'*rank/`totalpvals'
	* Generate binary variable checking condition p(r) <= q'*r/M
	gen reject_temp1 = (fdr_temp1>=pval) if pval~=.
	* Generate variable containing p-value ranks for all p-values that meet above condition
	gen reject_rank1 = reject_temp1*rank
	* Record the rank of the largest p-value that meets above condition
	egen total_rejected1 = max(reject_rank1)

	* Second Stage
	* Generate the second stage q level that accounts for hypotheses rejected in first stage: q_2st = q'*(M/m0)
	local qval_2st = `qval_adj'*(`totalpvals'/(`totalpvals'-total_rejected1[1]))
	* Generate value q_2st*r/M
	gen fdr_temp2 = `qval_2st'*rank/`totalpvals'
	* Generate binary variable checking condition p(r) <= q_2st*r/M
	gen reject_temp2 = (fdr_temp2>=pval) if pval~=.
	* Generate variable containing p-value ranks for all p-values that meet above condition
	gen reject_rank2 = reject_temp2*rank
	* Record the rank of the largest p-value that meets above condition
	egen total_rejected2 = max(reject_rank2)

	* A p-value has been rejected at level q if its rank is less than or equal to the rank of the max p-value that meets the above condition
	replace bky06_qval = `qval' if rank <= total_rejected2 & rank~=.
	* Reduce q by 0.001 and repeat loop
	drop fdr_temp* reject_temp* reject_rank* total_rejected*
	local qval = `qval' - .001
}
	

quietly sort original_sorting_order
pause off
set more on


* ISFMCA
clear all
set obs 18
bro
quietly gen float pval = .
replace pval= 0.0001 in 1
replace pval= 0.0001 in 2 
replace pval= 0.0071 in 3
replace pval= 0.0001 in 4
replace pval= 0.0001 in 5
replace pval= 0.0001 in 6
replace pval= 0.1821 in 7
replace pval= 0.0029 in 8
replace pval= 0.8738 in 9
replace pval= 0.0001 in 10
replace pval= 0.7513 in 11
replace pval= 0.0001 in 12
replace pval= 0.0001 in 13
replace pval= 0.1846 in 14
replace pval= 0.0027 in 15
replace pval= 0.0017 in 16
replace pval= 0.0750 in 17
replace pval= 0.0235 in 18
pause

* Collect the total number of p-values tested

quietly sum pval
local totalpvals = r(N)

* Sort the p-values in ascending order and generate a variable that codes each p-value's rank

quietly gen int original_sorting_order = _n
quietly sort pval
quietly gen int rank = _n if pval~=.

* Set the initial counter to 1 

local qval = 1

* Generate the variable that will contain the BKY (2006) sharpened q-values

gen bky06_qval = 1 if pval~=.

* Set up a loop that begins by checking which hypotheses are rejected at q = 1.000, then checks which hypotheses are rejected at q = 0.999, then checks which hypotheses are rejected at q = 0.998, etc.  The loop ends by checking which hypotheses are rejected at q = 0.001.


while `qval' > 0 {
	* First Stage
	* Generate the adjusted first stage q level we are testing: q' = q/1+q
	local qval_adj = `qval'/(1+`qval')
	* Generate value q'*r/M
	gen fdr_temp1 = `qval_adj'*rank/`totalpvals'
	* Generate binary variable checking condition p(r) <= q'*r/M
	gen reject_temp1 = (fdr_temp1>=pval) if pval~=.
	* Generate variable containing p-value ranks for all p-values that meet above condition
	gen reject_rank1 = reject_temp1*rank
	* Record the rank of the largest p-value that meets above condition
	egen total_rejected1 = max(reject_rank1)

	* Second Stage
	* Generate the second stage q level that accounts for hypotheses rejected in first stage: q_2st = q'*(M/m0)
	local qval_2st = `qval_adj'*(`totalpvals'/(`totalpvals'-total_rejected1[1]))
	* Generate value q_2st*r/M
	gen fdr_temp2 = `qval_2st'*rank/`totalpvals'
	* Generate binary variable checking condition p(r) <= q_2st*r/M
	gen reject_temp2 = (fdr_temp2>=pval) if pval~=.
	* Generate variable containing p-value ranks for all p-values that meet above condition
	gen reject_rank2 = reject_temp2*rank
	* Record the rank of the largest p-value that meets above condition
	egen total_rejected2 = max(reject_rank2)

	* A p-value has been rejected at level q if its rank is less than or equal to the rank of the max p-value that meets the above condition
	replace bky06_qval = `qval' if rank <= total_rejected2 & rank~=.
	* Reduce q by 0.001 and repeat loop
	drop fdr_temp* reject_temp* reject_rank* total_rejected*
	local qval = `qval' - .001
}
	

quietly sort original_sorting_order
pause off
set more on
*"Note: Sharpened FDR q-vals can be LESS than unadjusted p-vals when many hypotheses are rejected, because if you have many true rejections, then you can tolerate several false rejections too (this effectively just happens for p-vals that are so large that you are not going to reject them regardless)."
**# Hausman test for independence of irrelevant alternatives assumption (IIA) and joint signifficance test for Hausman variables
cd ${folder}
use rep_data.dta, clear
global xlist female age edu hhsize depratio dis_market dis_extension plot_distance land_certificate poorsoil goodsoil farmsize tTLU_owned if_pesticides maize barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations if_loan if_nonfarm ext_visit ext_training fellow_farmer rain_py d_year2 d_year3 
global ylist female age edu hhsize depratio  dis_market dis_extension plot_distance land_certificate poorsoil goodsoil farmsize tTLU_owned if_pesticides maize barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations if_loan if_nonfarm ext_visit ext_training fellow_farmer rain_py  d_year2 d_year3
global iv sd_rainfall his_average
local temp female age edu hhsize depratio dis_market dis_extension plot_distance land_certificate poorsoil goodsoil farmsize tTLU_owned if_pesticides maize barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations if_loan if_nonfarm ext_visit ext_training fellow_farmer rain_py 
local i=1
foreach var of varlist `temp' {   
qui egen m_`var'=mean(`var'), by(qid)
local i=`i'+1 
}
global m_listx m_female m_age m_edu m_hhsize m_depratio m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_farmsize m_tTLU_owned m_if_pesticides m_maize m_barley m_shock_count m_coping_cost_sum m_organizations m_if_loan m_if_nonfarm m_ext_visit m_ext_training m_fellow_farmer m_rain_py 
global m_listy m_female m_age m_edu m_hhsize m_depratio m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_farmsize m_tTLU_owned m_if_pesticides m_maize m_barley m_shock_count m_coping_cost_sum m_organizations m_if_loan m_if_nonfarm m_ext_visit m_ext_training m_fellow_farmer m_rain_py 
mlogit isfm $xlist $iv $m_listx i.region, base(1)
estimates store isfm1
mlogit isfm $xlist $iv $m_listx i.region if isfm != 2, base(1)
hausman . isfm1, alleqs constant
mlogit isfm $xlist $iv $m_listx i.region if isfm != 3, base(1)
hausman . isfm1, alleqs constant
drop _est_isfm1
* no evidence of IIA violation
mlogit isfm $xlist $iv $m_listx i.region, base(1)
testparm m_age m_edu m_hhsize m_depratio m_female m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_shock_count m_coping_cost_sum m_organizations m_farmsize m_if_loan m_if_nonfarm m_tTLU_owned m_ext_visit m_ext_training m_fellow_farmer m_rain_py m_if_pesticides m_maize m_barley, equation(2)
testparm m_age m_edu m_hhsize m_depratio m_female m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_shock_count m_coping_cost_sum m_organizations m_farmsize m_if_loan m_if_nonfarm m_tTLU_owned m_ext_visit m_ext_training m_fellow_farmer m_rain_py m_if_pesticides m_maize m_barley, equation(3)
/*isfmca*/
mlogit isfmca $xlist $iv $m_listx i.region, base(1)
estimates store allcat
mlogit isfmca $xlist $iv $m_listx i.region if isfmca != 2, base(1)
estimates store isfmca1
mlogit isfmca $xlist $iv $m_listx i.region if isfmca != 3, base(1)
estimates store isfmca2
mlogit isfmca $xlist $iv $m_listx i.region if isfmca != 4, base(1)
estimates store isfmca3
hausman allcat isfmca1, alleqs constant
hausman allcat isfmca2, alleqs constant
hausman allcat isfmca3, alleqs constant
drop _est_allcat _est_isfmca1 _est_isfmca2 _est_isfmca3
* the results says that IIA has not been violated for above.
mlogit isfmca $xlist $iv $m_listx i.region, base(1)
testparm m_age m_edu m_hhsize m_depratio m_female m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_shock_count m_coping_cost_sum m_organizations m_farmsize m_if_loan m_if_nonfarm m_tTLU_owned m_ext_visit m_ext_training m_fellow_farmer m_rain_py m_if_pesticides m_maize m_barley, equation(2)
testparm m_age m_edu m_hhsize m_depratio m_female m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_shock_count m_coping_cost_sum m_organizations m_farmsize m_if_loan m_if_nonfarm m_tTLU_owned m_ext_visit m_ext_training m_fellow_farmer m_rain_py m_if_pesticides m_maize m_barley, equation(3)
testparm m_age m_edu m_hhsize m_depratio m_female m_dis_market m_dis_extension m_plot_distance m_land_certificate m_poorsoil m_goodsoil m_shock_count m_coping_cost_sum m_organizations m_farmsize m_if_loan m_if_nonfarm m_tTLU_owned m_ext_visit m_ext_training m_fellow_farmer m_rain_py m_if_pesticides m_maize m_barley, equation(4)

**# Simple falsification tests 
* Some do not agree with this and see problems. Overall it is not testable, but here is a simple test as per Di. Faclo et al. 2011, a valid instrument will affect adoption decision but not affect the outcome of those who did not adopt. 
reg HDDS $ylist $m_listy region $iv if isfm==1, robust
outreg2 using falsification, excel replace sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("HDDS")
reg food_insecurity $ylist $m_listy region $iv if isfm==1, robust
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Experience of food insecurity")
reg lndef_food_exp $$ylist $m_listy region $iv if isfm==1, robust
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Real per capita food expenditure (ln)")
reg poor $ylist $m_listy region $iv if isfm==1, robust
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Probability of being poor")
reg pov_gap $ylist $m_listy region $iv if isfm==1, robust
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Poverty gap")
reg pov_severity $ylist $m_listy region $iv if isfm==1, robust
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Severity of poverty")
reg HDDS $ylist $m_listy region $iv if isfmca==1, robust
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("HDDS")
reg food_insecurity $ylist $m_listy region $iv if isfmca==1 , robust 
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Experience of food insecurity")
reg lndef_food_exp $ylist $m_listy region $iv if isfmca==1, robust 
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Real per capita food expenditure (ln)")
reg poor $ylist $m_listy region $iv if isfmca==1, robust 
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Probability of being poor")
reg pov_gap $ylist $m_listy region $iv if isfmca==1, robust 
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Poverty gap")
reg pov_severity $ylist $m_listy region $iv if isfmca==1, robust 
outreg2 using falsification, excel append sideway bdec(3) cdec(3) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) keep (sd_rainfall his_average) cti("Severity of poverty")


**# Alternative methods - random effects and ipwra
// global folder = "C:\Research\sustainable-intensification\GitHub_files\isfmca-replication"
cd ${folder}
use rep_data.dta, clear
global xfixed i.isfm i.female age edu hhsize depratio dis_market dis_extension plot_distance i.land_certificate i.poorsoil i.goodsoil farmsize tTLU_owned if_pesticides maize barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations i.if_loan if_nonfarm i.ext_visit i.ext_training i.fellow_farmer rain_py i.region
xtset qid year
quietly xtreg lndef_food_exp  $xfixed, fe
estimates store fixed
quietly xtreg lndef_food_exp $xfixed, re
estimates store random
hausman fixed random, sigmamore //random
use rep_data.dta, clear
xtset qid year
quietly xtreg pov_gap $xfixed, fe
estimates store fixed
quietly xtreg pov_gap $xfixed, re
estimates store random
hausman fixed random, sigmamore //random
use rep_data.dta, clear
xtset qid year
quietly xtreg pov_severity $xfixed, fe
estimates store fixed
quietly xtreg pov_severity $xfixed, re
estimates store random
hausman fixed random, sigmamore //random
use rep_data.dta, clear
xtset qid year
quietly xtreg food_insecurity $xfixed, fe
estimates store fixed
quietly xtreg food_insecurity $xfixed, re
estimates store random
hausman fixed random, sigmamore //random
use rep_data.dta, clear
xtset qid year
quietly xtreg poor $xfixed, fe
estimates store fixed
quietly xtreg poor $xfixed, re
estimates store random
hausman fixed random, sigmamore //random
xtreg lndef_food_exp $xfixed i.year, re cluster (qid)
outreg2 using alternative, excel replace sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food expenditure RE")
xtreg lndef_food_exp $xfixed i.year, fe cluster (qid)
outreg2 using alternative, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food expenditure FE")
xtreg HDDS $xfixed i.year, re cluster (qid)
outreg2 using alternative, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("HDDS RE")
xtreg HDDS $xfixed i.year, fe cluster (qid)
outreg2 using alternative, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("HDDS FE")
xtreg food_insecurity $xfixed i.year, re cluster (qid)
outreg2 using alternative, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food insecurity RE")
xtreg food_insecurity $xfixed i.year, fe cluster (qid)
outreg2 using alternative, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food insecurity FE")
xtreg poor $xfixed i.year, re cluster (qid)
outreg2 using alternative1, excel replace sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Probability of being poor RE")
xtreg poor $xfixed i.year, fe cluster (qid)
outreg2 using alternative1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Probability of being poor FE")
xtreg pov_gap $xfixed i.year, re cluster (qid)
outreg2 using alternative1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty gap RE")
xtreg pov_gap $xfixed i.year, fe cluster (qid)
outreg2 using alternative1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty gap FE")
xtreg pov_severity $xfixed i.year, re cluster (qid)
outreg2 using alternative1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty severity RE")
xtreg pov_severity $xfixed i.year, fe cluster (qid)
outreg2 using alternative1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty severity FE")

*ISFMCA
cd ${folder}
use rep_data.dta, clear
xtset qid year
global xfixed i.isfmca i.female age edu hhsize depratio dis_market dis_extension plot_distance i.land_certificate i.poorsoil i.goodsoil farmsize tTLU_owned if_pesticides maize barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations i.if_loan if_nonfarm i.ext_visit i.ext_training i.fellow_farmer rain_py i.region
xtreg lndef_food_exp $xfixed i.year, re cluster (qid)
outreg2 using alternativeca, excel replace sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food expenditure RE")
xtreg lndef_food_exp $xfixed i.year, fe cluster (qid)
outreg2 using alternativeca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food expenditure FE")
xtreg HDDS $xfixed i.year, re cluster (qid)
outreg2 using alternativeca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("HDDS RE")
xtreg HDDS $xfixed i.year, fe cluster (qid)
outreg2 using alternativeca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("HDDS FE")
xtreg food_insecurity $xfixed i.year, re cluster (qid)
outreg2 using alternativeca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food insecurity RE")
xtreg food_insecurity $xfixed i.year, fe cluster (qid)
outreg2 using alternativeca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food insecurity FE")
xtreg poor $xfixed i.year, re cluster (qid)
outreg2 using alternative1ca, excel replace sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Probability of being poor RE")
xtreg poor $xfixed i.year, fe cluster (qid)
outreg2 using alternative1ca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Probability of being poor FE")
xtreg pov_gap $xfixed i.year, re cluster (qid)
outreg2 using alternative1ca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty gap RE")
xtreg pov_gap $xfixed i.year, fe cluster (qid)
outreg2 using alternative1ca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty gap FE")
xtreg pov_severity $xfixed i.year, re cluster (qid)
outreg2 using alternative1ca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty severity RE")
xtreg pov_severity $xfixed i.year, fe cluster (qid)
outreg2 using alternative1ca, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty severity FE")


* IPWRA
cd ${folder}
use rep_data.dta, clear
preserve
global xipwra i.female age edu hhsize depratio dis_market dis_extension plot_distance i.land_certificate i.poorsoil i.goodsoil farmsize tTLU_owned i.if_pesticides i.maize i.barley alt shock_count coping_cost_sum shallow_slope steep_slope organizations i.if_loan if_nonfarm i.ext_visit i.ext_training i.fellow_farmer rain_py i.region
keep if year==2014
recode isfm (3=2)
teffects ipwra (lndef_food_exp $xipwra) (isfm $xipwra, probit), atet
outreg2 using ipwra, excel replace sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food expenditure 2014") drop($xipwra)
restore
preserve
keep if year==2016
recode isfm (3=2)
teffects ipwra (lndef_food_exp $xipwra) (isfm $xipwra, probit), atet

outreg2 using ipwra, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food expenditure 2016") drop($xipwra)
restore
preserve
keep if year==2019
recode isfm (3=2)
teffects ipwra (lndef_food_exp $xipwra) (isfm $xipwra, probit), atet
outreg2 using ipwra, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food expenditure 2019") drop($xipwra)
restore
preserve
keep if year==2014
recode isfm (3=2)
teffects ipwra (HDDS $xipwra) (isfm  $xipwra, probit), atet
outreg2 using ipwra, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("HDDS 2014") drop($xipwra)
restore
preserve
keep if year==2016
recode isfm (3=2)
teffects ipwra (HDDS $xipwra) (isfm  $xipwra, probit), atet
outreg2 using ipwra, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("HDDS 2016") drop($xipwra)
restore
preserve
keep if year==2019
recode isfm (3=2)
teffects ipwra (HDDS $xipwra) (isfm  $xipwra, probit), atet
outreg2 using ipwra, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("HDDS 2019") drop($xipwra)
restore
preserve
keep if year==2014
recode isfm (3=2)
teffects ipwra (food_insecurity $xipwra, probit) (isfm $xipwra, probit), atet
outreg2 using ipwra, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food insecure 2014") drop($xipwra)
restore
preserve
keep if year==2016
recode isfm (3=2)
teffects ipwra (food_insecurity $xipwra, probit) (isfm  $xipwra, probit), atet
outreg2 using ipwra, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food insecure 2016") drop($xipwra)
restore
preserve
keep if year==2019
recode isfm (3=2)
teffects ipwra (food_insecurity $xipwra, probit) (isfm  $xipwra, probit), atet
outreg2 using ipwra, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Food insecure 2019") drop($xipwra)
restore
preserve
keep if year==2014
recode isfm (3=2)
teffects ipwra (poor $xipwra, probit) (isfm $xipwra, probit), atet
outreg2 using ipwra1, excel replace sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Probability of being poor 2014") drop($xipwra)
restore
preserve
keep if year==2019
recode isfm (3=2)
teffects ipwra (poor $xipwra, probit) (isfm  $xipwra, probit), atet
outreg2 using ipwra1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Probability of being poor 2019") drop($xipwra)
restore
preserve
keep if year==2014
recode isfm (3=2)
teffects ipwra (pov_gap $xipwra, fprobit) (isfm  $xipwra, probit), atet
outreg2 using ipwra1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty gap 2014") drop($xipwra)
restore
preserve
keep if year==2016
recode isfm (3=2)
teffects ipwra (pov_gap $xipwra, fprobit) (isfm  $xipwra, probit), atet
outreg2 using ipwra1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty gap 2016") drop($xipwra)
restore
preserve
keep if year==2019
recode isfm (3=2)
teffects ipwra (pov_gap $xipwra, fprobit) (isfm  $xipwra, probit), atet
outreg2 using ipwra1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty gap 2014") drop($xipwra)
restore
preserve
keep if year==2014
recode isfm (3=2)
teffects ipwra (pov_severity $xipwra, fprobit) (isfm  $xipwra, probit), atet
outreg2 using ipwra1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty severity 2014") drop($xipwra)
restore
preserve
keep if year==2016
recode isfm (3=2)
teffects ipwra (pov_severity $xipwra, fprobit) (isfm $xipwra, probit), atet
outreg2 using ipwra1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty severity 2016") drop($xipwra)
restore
preserve
keep if year==2019
recode isfm (3=2)
teffects ipwra (pov_severity $xipwra, fprobit) (isfm  $xipwra, probit), atet
outreg2 using ipwra1, excel append sideway dec(2) label symbol(***, **, *) alpha (.01, .05, .10) stats(coef se) cti("Poverty severity 2019") drop($xipwra)
restore
clear
